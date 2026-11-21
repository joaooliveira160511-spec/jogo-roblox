-- medir_custo_luzes_heartbeat.lua
-- Rodado com execute_luau, datamodel CLIENT, com o jogo em Play.
--
-- Mede o custo de CPU do LuzesCliente pelo Stats.HeartbeatTimeMs, que NÃO sofre o teto de 15 fps que o Studio impõe
-- ao quadro (ver o README). Faz duas medidas seguidas: com o LuzesCliente ligado (6 s, amostrando também o brilho de
-- uma chama normal, uma enfraquecida, uma piscando e uma apagada, e a transparência de uma janela) e com ele
-- desligado (5 s, referência).
--
-- Para medir a versão ANTIGA nas mesmas condições: desligar o LuzesCliente atual e, no datamodel SERVER, rodar
--   local c = game.ServerStorage.LuzesCliente_v1:Clone(); c.Name = "LuzesClienteV1Teste"; c.Enabled = true
--   c.Parent = game.Players:GetPlayers()[1].PlayerGui
-- e repetir só a primeira medida (a cópia roda no cliente a partir da PlayerGui). Não religar o script novo depois
-- da antiga na mesma sessão: ele leria como brilho-base um valor já animado.
--
-- Resultado no chat (Studio, cerca de 13 fps): sem script 1,65 ms; antiga 5,19 ms; atual 3,23 ms.

local RS = game:GetService("RunService")
local CS = game:GetService("CollectionService")
local Stats = game:GetService("Stats")
local lp = game:GetService("Players").LocalPlayer
local PS = lp.PlayerScripts
local cam = workspace.CurrentCamera
local out = {}
task.wait(6) -- deixa o mapa e os scripts assentarem

local nova = PS:FindFirstChild("LuzesCliente")
out[#out+1] = "LuzesCliente Enabled=" .. tostring(nova and nova.Enabled)
local cp = cam.CFrame.Position
local function maisPerto(filtro)
  local best, bd
  for _, inst in ipairs(CS:GetTagged("Luz")) do
    if inst:IsA("BasePart") and inst.Name == "Chama" and inst:FindFirstChildOfClass("PointLight") and filtro(inst) then
      local d = (inst.Position - cp).Magnitude
      if not bd or d < bd then best, bd = inst, d end
    end
  end
  return best, bd
end
local alvos = {
  {nome = "ligada (normal)", filtro = function(i) return i:GetAttribute("Estado") == "ligada" and not i:GetAttribute("Fraca") end},
  {nome = "ligada (fraca)", filtro = function(i) return i:GetAttribute("Fraca") == true end},
  {nome = "piscando", filtro = function(i) return i:GetAttribute("Estado") == "piscando" end},
  {nome = "apagada", filtro = function(i) return i:GetAttribute("Estado") == "apagada" end},
}
-- uma janela (com Decal) para checar a transparência
local janela, dj
for _, inst in ipairs(CS:GetTagged("Luz")) do
  local v = inst:IsA("BasePart") and inst:FindFirstChildOfClass("Decal")
  if v and inst:GetAttribute("Estado") == "ligada" then
    local d = (inst.Position - cp).Magnitude
    if not dj or d < dj then janela, dj = inst, d end
  end
end
for _, a in ipairs(alvos) do
  local inst, d = maisPerto(a.filtro)
  a.inst, a.d = inst, d
  a.luz = inst and inst:FindFirstChildOfClass("PointLight")
  a.min, a.max, a.mud, a.offFrames, a.ult, a.n = math.huge, -math.huge, 0, 0, nil, 0
end
local vela = janela and janela:FindFirstChildOfClass("Decal")
local tmin, tmax, tmud, tult = math.huge, -math.huge, 0, nil

local function amostra(seg, coleta)
  local t_end, arr = os.clock() + seg, {}
  while os.clock() < t_end do
    RS.RenderStepped:Wait()
    arr[#arr+1] = Stats.HeartbeatTimeMs
    if coleta then
      for _, a in ipairs(alvos) do
        if a.luz then
          local b = a.luz.Brightness
          a.n += 1
          if b < a.min then a.min = b end
          if b > a.max then a.max = b end
          if a.ult and math.abs(b - a.ult) > 1e-6 then a.mud += 1 end
          a.ult = b
          if not a.luz.Enabled then a.offFrames += 1 end
        end
      end
      if vela then
        local tr = vela.Transparency
        if tr < tmin then tmin = tr end
        if tr > tmax then tmax = tr end
        if tult and math.abs(tr - tult) > 1e-6 then tmud += 1 end
        tult = tr
      end
    end
  end
  local s = 0 for _, v in ipairs(arr) do s += v end
  table.sort(arr)
  return s / #arr, arr[math.floor(#arr * 0.9)], arr[#arr], #arr
end

local m, p90, mx, n = amostra(6, true)
out[#out+1] = string.format("HeartbeatTimeMs com o script ligado : media=%.2f ms | p90=%.2f | maximo=%.2f | amostras=%d", m, p90, mx, n)
for _, a in ipairs(alvos) do
  if a.inst then
    out[#out+1] = string.format("  %-16s %-22s dist=%4.0f | brilho min=%.3f max=%.3f | mudancas=%d/%d | quadros desligada=%d",
      a.nome, a.inst:FindFirstAncestorOfClass("Model").Name, a.d, a.min, a.max, a.mud, a.n, a.offFrames)
  end
end
if vela then out[#out+1] = string.format("  janela %-16s dist=%4.0f | Transparency min=%.3f max=%.3f | mudancas=%d", janela:FindFirstAncestorOfClass("Model").Name, dj, tmin, tmax, tmud) end

nova.Enabled = false
task.wait(0.8)
local m0, p900, mx0, n0 = amostra(5, false)
out[#out+1] = string.format("HeartbeatTimeMs SEM script de luz     : media=%.2f ms | p90=%.2f | maximo=%.2f | amostras=%d", m0, p900, mx0, n0)
return table.concat(out, "\n")
