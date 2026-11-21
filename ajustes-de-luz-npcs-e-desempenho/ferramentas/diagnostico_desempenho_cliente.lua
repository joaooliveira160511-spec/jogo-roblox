-- diagnostico_desempenho_cliente.lua
-- Rodado com execute_luau, datamodel CLIENT, com o jogo em Play. Só lê; não altera nada.
--
-- Mede o tempo de quadro por 3 s (RenderStepped), lê a configuração de iluminação e conta, no Workspace inteiro,
-- peças, peças que projetam sombra, decals, emissores e luzes. Foi o primeiro passo do diagnóstico de desempenho.
--
-- Resultado no chat (Studio): média de 132 ms (8 fps) nesta primeira amostra; 141.083 peças, 66.065 com CastShadow,
-- 460 PointLight ativas (23 com sombra) e 10.560 decals.
-- Atenção: em testes seguintes, com a cena esvaziada, o quadro ficou em 66,7 ms (15 fps) de qualquer jeito. Esse é um
-- teto do Studio nessa medição, e não custo do jogo; por isso medir só o FPS não separa o custo de cada parte.

local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local out = {}

-- 1) tempo de quadro (3 s)
local dts, t_end = {}, os.clock() + 3
while os.clock() < t_end do dts[#dts+1] = RS.RenderStepped:Wait() end
table.sort(dts)
local soma = 0 for _, d in ipairs(dts) do soma += d end
out[#out+1] = string.format("QUADROS: n=%d | media=%.1f ms (%.0f fps) | p95=%.1f ms | pior=%.1f ms", #dts, soma/#dts*1000, #dts/soma, dts[math.floor(#dts*0.95)]*1000, dts[#dts]*1000)

-- 2) configuracao
out[#out+1] = "StreamingEnabled=" .. tostring(workspace.StreamingEnabled)
local ok, tech = pcall(function() return tostring(Lighting.Technology) end)
out[#out+1] = "Lighting.Technology=" .. (ok and tech or "?") .. " | GlobalShadows=" .. tostring(Lighting.GlobalShadows) .. " | ShadowSoftness=" .. tostring(Lighting.ShadowSoftness) .. " | FogEnd=" .. Lighting.FogEnd
local ok2, ql = pcall(function() return tostring(settings().Rendering.QualityLevel) end)
out[#out+1] = "QualityLevel=" .. (ok2 and ql or "?")
local ef = {}
for _, c in ipairs(Lighting:GetChildren()) do
  local en = ""
  pcall(function() en = tostring(c.Enabled) end)
  ef[#ef+1] = c.ClassName .. "(" .. en .. ")"
end
out[#out+1] = "Lighting filhos: " .. table.concat(ef, ", ")

-- 3) contagens no Workspace
local cont = {parts=0, cast=0, mesh=0, decal=0, texture=0, surfgui=0, particulas=0, partEnab=0, pointOn=0, pointShadow=0, spot=0, surf=0, beam=0, trail=0, transp=0}
local porFilho = {}
for _, filho in ipairs(workspace:GetChildren()) do
  local ds = filho:GetDescendants()
  porFilho[#porFilho+1] = string.format("%s=%d", filho.Name, #ds)
  for _, d in ipairs(ds) do
    if d:IsA("BasePart") then
      cont.parts += 1
      if d.CastShadow then cont.cast += 1 end
      if d:IsA("MeshPart") then cont.mesh += 1 end
      if d.Transparency > 0 and d.Transparency < 1 then cont.transp += 1 end
    elseif d:IsA("Decal") then cont.decal += 1
    elseif d:IsA("Texture") then cont.texture += 1
    elseif d:IsA("SurfaceGui") then cont.surfgui += 1
    elseif d:IsA("ParticleEmitter") then cont.particulas += 1; if d.Enabled then cont.partEnab += 1 end
    elseif d:IsA("PointLight") then if d.Enabled then cont.pointOn += 1; if d.Shadows then cont.pointShadow += 1 end end
    elseif d:IsA("SpotLight") or d:IsA("SurfaceLight") then cont.spot += 1
    elseif d:IsA("Beam") then cont.beam += 1
    elseif d:IsA("Trail") then cont.trail += 1 end
  end
end
table.sort(porFilho)
out[#out+1] = "Descendentes por filho do Workspace: " .. table.concat(porFilho, ", ")
out[#out+1] = string.format("PARTES=%d (CastShadow=%d, MeshPart=%d, semi-transp=%d) | decals=%d textures=%d surfaceguis=%d | emissores=%d (ativos %d) | PointLight ativas=%d (com sombra %d) | outras luzes=%d | beams=%d trails=%d",
  cont.parts, cont.cast, cont.mesh, cont.transp, cont.decal, cont.texture, cont.surfgui, cont.particulas, cont.partEnab, cont.pointOn, cont.pointShadow, cont.spot, cont.beam, cont.trail)

-- 4) scripts locais do jogador
local lp = game:GetService("Players").LocalPlayer
local sc = {}
if lp then
  for _, s in ipairs(lp:GetDescendants()) do
    if s:IsA("LocalScript") then sc[#sc+1] = s:GetFullName():gsub("^Players%.[^.]+%.", "") .. "(Enabled=" .. tostring(s.Enabled) .. ")" end
  end
end
out[#out+1] = "LocalScripts: " .. table.concat(sc, ", ")
return table.concat(out, "\n")
