-- aplicar_lampioes_fracos_e_retirar_npcs.lua
-- Rodado no Studio com execute_luau, datamodel EDIT (nunca em Play).
--
-- O que faz:
--   1) escolhe até 22 postes "ligada" (nome iniciado em "Poste") e reduz o brilho (x0,35 a x0,55) e o alcance
--      (x0,70 a x0,80) do PointLight; o Estado continua "ligada". Guarda BrilhoOriginal, AlcanceOriginal e Fraca = true
--      na Chama, para poder reverter.
--   2) retira de Workspace.NPCs os NPCs comuns que ficariam com iluminação no chão abaixo de 0,8 por causa disso,
--      movendo-os (sem apagar) para ServerStorage.NPCsRetirados.
--
-- Regras de escolha: semente fixa 20261105; distância mínima de 38 studs entre postes enfraquecidos; um poste só entra
-- se, com ele, no máximo MAXN = 12 NPCs comuns ficam abaixo de 0,8 e nenhum dos 29 NPCs originais nem os caminhantes
-- (atributo Rota) caem abaixo disso. Iluminação = soma de brilho * (1 - distância / alcance) das luzes "ligada" de
-- alcance >= 16, medida 1,5 stud acima do chão.
--
-- Resultado no chat: 18 postes enfraquecidos e 12 NPCs retirados (Workspace.NPCs: 275 -> 263).
-- Trava: aborta se já existir algum poste com atributo Fraca ou a pasta NPCsRetirados.

local CS = game:GetService("CollectionService")
local SS = game:GetService("ServerStorage")
local npcs = workspace.NPCs
local MAXN, ALVO, ESP = 12, 22, 38

-- trava de segurança: não aplicar duas vezes
for _, inst in ipairs(CS:GetTagged("Luz")) do
  if inst:GetAttribute("Fraca") then return "ABORTADO: já existem lampiões enfraquecidos." end
end
if SS:FindFirstChild("NPCsRetirados") then return "ABORTADO: pasta NPCsRetirados já existe." end

-- os 29 NPCs originais ficam protegidos
local ORIG = {}
for _, id in ipairs({"tobias","heitor","anselmo","bartolomeu","orlando","gaspar","ambrosio","leonidas","cassio","rufino","marta","eulalia","berenice","sidonia","ines","albertina","ludmila","cecilia","josefa","pedrinho","clarinha","tome","lia","davi","nico","nina","rosa","zeca","beto"}) do ORIG["NPC_"..id] = true end

-- luzes "ligada" de alcance >= 16 fora dos NPCs (mesma conta da regra de iluminação da vila)
local luzes = {}
for _, inst in ipairs(CS:GetTagged("Luz")) do
  if not inst:IsDescendantOf(npcs) and inst:GetAttribute("Estado") == "ligada" then
    local l = inst:FindFirstChildOfClass("PointLight")
    if l and l.Range >= 16 then
      local m = inst:FindFirstAncestorOfClass("Model")
      luzes[#luzes+1] = {part=inst, light=l, pos=inst.Position, B=l.Brightness, R=l.Range, poste=(m and m.Name:match("^Poste")) and m or nil, fB=1, fR=1}
    end
  end
end
local cand = {}
for _, L in ipairs(luzes) do if L.poste then cand[#cand+1] = L end end
local rng = Random.new(20261105)
for i = #cand, 2, -1 do local j = rng:NextInteger(1, i); cand[i], cand[j] = cand[j], cand[i] end
for _, L in ipairs(cand) do L.fB = 0.35 + 0.2 * rng:NextNumber(); L.fR = 0.7 + 0.1 * rng:NextNumber() end

-- ponto de medição de cada NPC
local pts = {}
for _, n in ipairs(npcs:GetChildren()) do
  local root = n:FindFirstChild("HumanoidRootPart") or n.PrimaryPart
  if root then
    local gy = root.Position.Y - (n:GetAttribute("AlturaRaiz") or 3)
    pts[#pts+1] = {n=n, p=Vector3.new(root.Position.X, gy + 1.5, root.Position.Z), prot = ORIG[n.Name] or n:GetAttribute("Rota") ~= nil}
  end
end

local dimmed = {}
local function ilum(p)
  local s = 0
  for _, L in ipairs(luzes) do
    local B, R = L.B, L.R
    if dimmed[L] then B, R = L.B * L.fB, L.R * L.fR end
    local d = (L.pos - p).Magnitude
    if d < R then s += B * (1 - d / R) end
  end
  return s
end
local base = {}
for i, P in ipairs(pts) do base[i] = ilum(P.p) end
local function avalia()
  local baixos, protegidoCai = {}, false
  for i, P in ipairs(pts) do
    local v = ilum(P.p)
    if v < 0.8 and base[i] >= 0.8 and P.n:GetAttribute("Rota") == nil then
      if P.prot then protegidoCai = true end
      baixos[#baixos+1] = P.n
    end
  end
  return baixos, protegidoCai
end

-- escolha gulosa dos postes, respeitando o orçamento de NPCs afetados
local escolhidos = {}
for _, L in ipairs(cand) do
  if #escolhidos >= ALVO then break end
  local ok = true
  for _, E in ipairs(escolhidos) do
    if Vector3.new(L.pos.X - E.pos.X, 0, L.pos.Z - E.pos.Z).Magnitude < ESP then ok = false break end
  end
  if ok then
    dimmed[L] = true
    local baixos, prot = avalia()
    if prot or #baixos > MAXN then dimmed[L] = nil else escolhidos[#escolhidos+1] = L end
  end
end
local retirar = avalia()

-- APLICAR: lampiões mais fracos (reversível pelos atributos)
for _, L in ipairs(escolhidos) do
  L.part:SetAttribute("BrilhoOriginal", L.B)
  L.part:SetAttribute("AlcanceOriginal", L.R)
  L.part:SetAttribute("Fraca", true)
  L.light.Brightness = L.B * L.fB
  L.light.Range = L.R * L.fR
end

-- APLICAR: NPCs para a pasta de retirados (não apaga)
local pasta = Instance.new("Folder")
pasta.Name = "NPCsRetirados"
pasta.Parent = SS
local nomes = {}
for _, n in ipairs(retirar) do
  nomes[#nomes+1] = n.Name
  n.Parent = pasta
end

-- conferência
local restantes = #npcs:GetChildren()
local abaixo = 0
for i, P in ipairs(pts) do
  if P.n.Parent == npcs and P.n:GetAttribute("Rota") == nil and ilum(P.p) < 0.8 then abaixo += 1 end
end
return string.format("lampioes enfraquecidos=%d | NPCs retirados=%d (%s) | NPCs restantes em Workspace.NPCs=%d | parados abaixo de 0,8 apos a mudanca=%d",
  #escolhidos, #retirar, table.concat(nomes, ", "), restantes, abaixo)
