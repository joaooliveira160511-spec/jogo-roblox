---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, expansao, orquestracao]
---
# Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção
Índice: [[Jogos - Gerais]]

## Conceito
- Terceiro bloco da extensão, no fim do módulo, antes do `return M`. Reúne as funções que montam, apagam e ajustam tudo por direção cardeal (k: 0 Leste, 1 Norte, 2 Oeste, 3 Sul), usando as das partes 7 e 8: [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]] e [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]].

## Código
```lua
-- =====================================================================
-- EXTENSÃO 3: orquestração por direção cardeal (k: 0 Leste, 1 Norte, 2 Oeste, 3 Sul).
-- Ordem de uso: limparExtensao (opcional) -> pisoDirecao -> casasDirecao -> pedregulhosDirecao.
-- Geometria: a rua continua até x = 250,4; a praça circular (raio 46) tem centro em x = 296 no referencial da rua.
-- =====================================================================
local NOMES_DIR = { [0] = "Leste", [1] = "Norte", [2] = "Oeste", [3] = "Sul" }
local POCOS = { [0] = { "ligada", false }, [1] = { "piscando", false }, [2] = { "apagada", true }, [3] = { "ligada", true } }
M.NOMES_DIR = NOMES_DIR

-- apaga tudo o que a extensão criou (casas, pedras, ruas longas, calçadas, praças, postes e adereços novos)
function M.limparExtensao(vila)
	local cont = { casas = 0, pedras = 0, praca = 0, pracas = 0, postes = 0, mobil = 0, detalhes = 0 }
	for _, c in ipairs(vila.Casas:GetChildren()) do
		for _, nome in pairs(NOMES_DIR) do
			if c.Name:find(nome) then c:Destroy(); cont.casas += 1; break end
		end
	end
	for _, c in ipairs(vila.Pedras:GetChildren()) do
		local n = c.Name
		if n:sub(1, 6) == "RuaExt" or n:sub(1, 4) == "Calc" or n:sub(1, 7) == "Circulo" then c:Destroy(); cont.pedras += 1 end
	end
	for _, p in ipairs(vila.Praca:GetChildren()) do
		if p.Name == "Calcada" or ((p.Name == "Rua" or p.Name == "MeioFioRua") and p.Position.Magnitude > 216) then p:Destroy(); cont.praca += 1 end
	end
	local pracas = vila:FindFirstChild("Pracas")
	if pracas then for _, c in ipairs(pracas:GetChildren()) do c:Destroy(); cont.pracas += 1 end end
	for _, c in ipairs(vila.Lampioes:GetChildren()) do
		if c.Name:sub(1, 5) == "Poste" and (c.Name:find("Ext") or c.Name:find("Circ")) then c:Destroy(); cont.postes += 1 end
	end
	for _, c in ipairs(vila.Mobiliario:GetChildren()) do
		if c.Name == "Poco" or c:GetPivot().Position.Magnitude > 84 then c:Destroy(); cont.mobil += 1 end
	end
	for _, c in ipairs(vila.Detalhes:GetChildren()) do
		if c.Name == "PedregulhosNovos" then c:Destroy(); cont.detalhes += 1 end
	end
	return cont
end

-- piso, postes e poço de uma direção
function M.pisoDirecao(vila, k)
	local nome = NOMES_DIR[k]
	local pracas = vila:FindFirstChild("Pracas")
	if not pracas then pracas = Instance.new("Folder"); pracas.Name = "Pracas"; pracas.Parent = vila end
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	local rng = Random.new(5000 + k)
	M.ruaExtensao(vila.Praca, k, 215.4, 250.4, 13)
	M.pedrasCampo(vila.Pedras, rot, 214.6, 249.6, -9.4, 9.45, rng, "RuaExt" .. nome)
	for _, lado in ipairs({ 1, -1 }) do
		local suf = (lado == 1 and "A" or "B")
		M.calcada(vila.Praca, k, lado, 84, 232, 11.2, 24.0)
		M.calcada(vila.Praca, k, lado, 232, 250.4, 11.2, 16.0)
		M.calcada(vila.Praca, k, lado, 62, 84, 11.2, 17.5)
		local a, b = 11.7, 23.5; if lado == -1 then a, b = -23.5, -11.7 end
		M.pedrasCampo(vila.Pedras, rot, 84.6, 231.4, a, b, rng, "Calc" .. nome .. suf)
		local c, d = 11.7, 15.6; if lado == -1 then c, d = -15.6, -11.7 end
		M.pedrasCampo(vila.Pedras, rot, 232.6, 249.8, c, d, rng, "CalcFim" .. nome .. suf)
		local e, f = 11.7, 17.1; if lado == -1 then e, f = -17.1, -11.7 end
		M.pedrasCampo(vila.Pedras, rot, 62.6, 83.4, e, f, rng, "CalcIni" .. nome .. suf)
	end
	local rng2 = Random.new(5100 + k)
	local centro = rot:VectorToWorldSpace(Vector3.new(296, 0, 0))
	M.pracaCirculo(pracas, centro, 46, rot, "Praca" .. nome)
	M.pedrasAneis(vila.Pedras, centro, 7.0, 45.2, rng2, "Circulo" .. nome)
	M.postesRua(vila.Lampioes, k, { 220 }, rng2, "PosteExt" .. nome, 4)
	M.postesCirculo(vila.Lampioes, centro, rot, 46, rng2, "PosteCirc" .. nome)
	M.poco(vila.Mobiliario, CFrame.new(centro.X, 0.5, centro.Z) * rot * CFrame.Angles(0, math.pi / 2, 0), POCOS[k][1], "poco" .. nome, POCOS[k][2])
end

-- casas de uma direção (duas fileiras e o círculo) e limpeza das pedras sob elas; devolve contagem por nível de ruína
function M.casasDirecao(vila, k, cfg)
	cfg = cfg or {}
	local nome = NOMES_DIR[k]
	local rp = M.paramsPiso(vila)
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	local centro = rot:VectorToWorldSpace(Vector3.new(296, 0, 0))
	local cont = { [0] = 0, 0, 0, 0 }
	local function conta(f) for _, c in ipairs(f) do cont[c.nivel] += 1 end end
	for _, lado in ipairs({ 1, -1 }) do
		conta(M.fileiraRua(vila.Casas, k, lado, {
			x0 = 90, x1 = 214, rng = Random.new(900 + k * 10 + (lado == 1 and 1 or 2)), prefixo = "Casa" .. nome .. (lado == 1 and "A" or "B"),
			semente = 2000 + k * 200 + (lado == 1 and 0 or 100), tBase = 0.10, tSpan = 0.45,
			forcaRuina = 1, maxRuina = cfg.maxRuinaRua or 1, mobiliario = vila.Mobiliario, rp = rp,
		}))
	end
	conta(M.circuloCasas(vila.Casas, centro, rot, 46, {
		rng = Random.new(950 + k), prefixo = "CasaCirc" .. nome, semente = 2000 + k * 200 + 150, tBase = 0.35,
		forcaRuina = 1, maxRuina = cfg.maxRuinaCirculo or 2, rp = rp,
	}))
	local removidas = 0
	for _, pre in ipairs({ "Calc", "CalcFim", "CalcIni", "RuaExt" }) do removidas += M.limpaPedras(vila.Pedras, vila.Casas, pre .. nome) end
	return cont, removidas
end

-- =====================================================================
-- EXTENSÃO 4: pedregulhos e limpeza de grama por direção.
-- =====================================================================

-- pedregulhos novos de uma direção (rua longa, calçadas e praça circular), assentados nas lajes
function M.pedregulhosDirecao(vila, k)
	local rp = M.paramsPiso(vila)
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	local centro = rot:VectorToWorldSpace(Vector3.new(296, 0, 0))
	local regioes = {
		{ cf = rot * CFrame.new(232, 0, 0), sx = 36, sz = 19 },
		{ cf = rot * CFrame.new(158, 0, 17.6), sx = 148, sz = 11.8 },
		{ cf = rot * CFrame.new(158, 0, -17.6), sx = 148, sz = 11.8 },
		{ cf = CFrame.new(centro.X, 0, centro.Z), sx = 88, sz = 88 },
	}
	local _, n = M.pedregulhosNovos(vila.Detalhes, Random.new(8000 + k), 520, regioes, rp, vila.Casas)
	return n
end

-- remove as lâminas de grama que ficam sob as calçadas e as fundações das casas novas
function M.limpaGrama(vila, grama)
	local occ = {}
	for _, p in ipairs(vila.Praca:GetChildren()) do
		if p.Name == "Calcada" then occ[#occ + 1] = { cf = p.CFrame, hx = p.Size.X / 2 + 0.4, hz = p.Size.Z / 2 + 0.4 } end
	end
	for _, c in ipairs(vila.Casas:GetChildren()) do
		local f = c:FindFirstChild("Fundacao")
		if f then occ[#occ + 1] = { cf = f.CFrame, hx = f.Size.X / 2 + 1.4, hz = f.Size.Z / 2 + 1.4 } end
	end
	local removidas = 0
	for _, pasta in ipairs(grama:GetChildren()) do
		for i, b in ipairs(pasta:GetChildren()) do
			local pos = b.Position
			if pos.Magnitude > 80 then
				for _, o in ipairs(occ) do
					local l = o.cf:PointToObjectSpace(pos)
					if math.abs(l.X) < o.hx and math.abs(l.Z) < o.hz then b:Destroy(); removidas += 1; break end
				end
			end
			if i % 1500 == 0 then task.wait() end
		end
	end
	return removidas
end

-- =====================================================================
-- EXTENSÃO 5: pivôs fixos nos Models novos.
-- O script NevoaDistante lê GetPivot() ao iniciar; com StreamingEnabled os Models chegam ao cliente
-- vazios e o pivô cai na origem, então eles seriam descarregados longe do centro. Um WorldPivot
-- explícito resolve (as casas já recebem WorldPivot em M.casaVelha).
-- =====================================================================
function M.fixaPivos(vila)
	local n = 0
	local function fixa(m)
		if m:IsA("Model") then m.WorldPivot = m:GetPivot(); n += 1 end
	end
	for _, c in ipairs(vila.Lampioes:GetChildren()) do
		if c.Name:find("Ext") or c.Name:find("Circ") then fixa(c) end
	end
	for _, c in ipairs(vila.Pedras:GetChildren()) do
		local nm = c.Name
		if nm:sub(1, 6) == "RuaExt" or nm:sub(1, 4) == "Calc" or nm:sub(1, 7) == "Circulo" then fixa(c) end
	end
	for _, c in ipairs(vila.Mobiliario:GetChildren()) do
		if c.Name == "Poco" or c:GetPivot().Position.Magnitude > 84 then fixa(c) end
	end
	return n
end
```

## Chamada de construção completa
```lua
local SS = game.ServerStorage
local velho = SS:FindFirstChild("ConstrutorVilaGrande_run"); if velho then velho:Destroy() end
local copia = SS.ConstrutorVilaGrande:Clone(); copia.Name = "ConstrutorVilaGrande_run"; copia.Parent = SS
local V = require(copia)
local vila = workspace.Vila
V.limparExtensao(vila)                                   -- opcional: refazer do zero
for k = 0, 3 do V.pisoDirecao(vila, k) end
for k = 0, 3 do V.casasDirecao(vila, k) end
for k = 0, 3 do V.pedregulhosDirecao(vila, k) end
V.limpaGrama(vila, workspace.Grama)
V.fixaPivos(vila)
```

## Pontos de atenção
- `limparExtensao` devolve o estado original: 12 casas, 28 postes, 104 Models de pedra, 30 de mobiliário e 236 peças em `Praca`.
- Não chamar `limparExtensao` depois de `limpaGrama` esperando recuperar a grama: as lâminas removidas não voltam.
- A ordem importa: as pedras são criadas antes das casas e depois limpas por sobreposição; o entulho é assentado em pedras já existentes.
- `fixaPivos` precisa rodar depois de tudo, e de novo se Models novos forem acrescentados (ver [[Carregamento por distância - Pivôs dos Models novos]]).
- Cada chamada completa leva poucos segundos em Edit; ainda assim, `task.wait()` entre casas evita travar o Studio.

## Relacionados
- [[Módulo ConstrutorVilaGrande - Visão geral e API]]
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Grama - Limpeza sob as construções novas]]
- [[Roblox Studio - ModuleScript, require e cache]]
