---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, vila-circular, muralha, anel]
---
# Módulo ConstrutorVilaGrande - Código parte 10 vila circular
Índice: [[Jogos - Gerais]]

## Conceito
- Quarto bloco da extensão, no fim do módulo, antes do `return M`, depois da orquestração por direção ([[Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção]]). Reúne as funções do anel viário com ruas laterais e da muralha de casas, e usa as funções das partes 7 e 8 (`pedrasCampo`, `pedraNova`, `poste2`, `estadoPoste`, `fileiraRua`, `casaVelha`, `entulho`, `adornos`, `limpaPedras`, `paramsPiso`, `pedregulhosNovos`, `sorteiaNivel`, `sorteiaEstado`, `limitaRuina` e a constante `JET`).
- Descrição do que cada função faz: [[Ruas laterais - Anel viário entre as ruas cardeais]], [[Cruzamentos - Limpeza de casas, pedras e meios-fios]], [[Passeio da muralha - Lajes, pedras e postes]] e [[Vila circular - Muralha de casas voltadas para o centro]].

## Duas alterações em código que já existia
1. Em `M.fileiraRua`, a linha `local rot = CFrame.Angles(0, k * math.pi / 2, 0)` passa a ser:
```lua
	local rot = cfg.base or CFrame.Angles(0, k * math.pi / 2, 0)
```
2. Em `sorteiaEstado`, a linha de decisão passa a ser (mais casas com luz fraca):
```lua
	if r < 0.12 - 0.05 * t then return "ligada" elseif r < 0.42 - 0.08 * t then return "piscando" end
```

## Ordem de uso
1. `removeCirculoCasas(vila)`, `limpaCruzamentos(vila)` e `completaMeioFio(vila)`.
2. `anelPiso(vila, kc, kd)` para kc de 0 a 3 e kd = (kc+1)%4 e (kc+3)%4.
3. `passeioMuro(vila, 9100)` e `postesMuro(vila.Lampioes, Random.new(9200))`.
4. `anelCasas(vila, kc, kd)` para as mesmas oito meias ruas.
5. `planoMuralha(9300)` e `muralhaCasas(vila, plano, i0, i1, 14000)` em quatro trechos (1-21, 22-42, 43-63, 64-84), seguido de `limpaPedras(vila.Pedras, vila.Casas, "Muralha")`.
6. `anelPedregulhos(vila, kc, kd)` para as oito meias ruas.
7. `fixaPivos2(vila)` e `fixaPivos(vila)` (ver [[Carregamento por distância - Pivôs dos Models novos]]).
8. Desligar as sombras dos postes novos (as funções de poste já o fazem para os criados aqui; os `PosteExt` e `PosteCirc` anteriores foram ajustados à parte).
- `limparAnel(vila)` apaga o que esta parte criou, exceto os adereços de calçada e os pedregulhos.
- Cada chamada de `execute_luau` deve clonar o módulo (`ConstrutorVilaGrande_run`) para contornar o cache de `require` (ver [[Roblox Studio - ModuleScript, require e cache]]).

## Código
```lua
-- =====================================================================
-- EXTENSÃO 6: vila circular.
-- Anel viário: de cada rua cardeal, no meio (ANEL = 200 do centro), sai uma rua para cada lado; as meias ruas
-- de ruas vizinhas se encontram numa curva, formando um quadrado de lado 400.
-- Muralha: casas voltadas para o centro num círculo cuja frente (andares superiores) fica em RF_MURO = 346;
-- o fundo das casas mais fundas chega a cerca de 372, o raio da vila.
-- Referencial de uma meia rua lateral: origem no cruzamento com a rua cardeal kc, +X ao longo da lateral (direção kd).
-- =====================================================================
M.ANEL = 200
M.RF_MURO = 346
local ANEL, RF_MURO = M.ANEL, M.RF_MURO

local function baseLateral(kc, kd)
	local rotC = CFrame.Angles(0, kc * math.pi / 2, 0)
	return CFrame.new(rotC:VectorToWorldSpace(Vector3.new(ANEL, 0, 0))) * CFrame.Angles(0, kd * math.pi / 2, 0)
end
M.baseLateral = baseLateral

-- lado da meia rua voltado para o centro da vila (sinal do z local)
local function ladoInterno(base)
	return (base:PointToObjectSpace(Vector3.zero).Z > 0) and 1 or -1
end

-- em cada curva, só a meia rua com kd = kc + 1 leva pista e calçadas até o canto, para não duplicar pedras
local function primeira(kc, kd)
	return kd == (kc + 1) % 4
end

local function marca(p)
	p:SetAttribute("Anel", true)
	return p
end

local function calcadaB(parent, base, lado, x0, x1, zi, zf)
	local n = math.max(1, math.floor((x1 - x0) / 12.2 + 0.5))
	local seg = (x1 - x0) / n
	for i = 0, n - 1 do
		marca(P(parent, "Calcada", Vector3.new(seg + 0.2, 1.0, zf - zi), base * CFrame.new(x0 + seg * (i + 0.5), 0, lado * (zi + zf) / 2), COR_PISO, Mat.Cobblestone))
	end
end

local function semSombras(m)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("PointLight") then d.Shadows = false end
	end
end

-- remove o que atrapalha o anel: casas da rua cardeal dentro do corredor da lateral, adereços, pedras, pedregulhos e meios-fios do cruzamento
function M.limpaCruzamentos(vila)
	local cont = { casas = 0, mobil = 0, pedras = 0, pedregulhos = 0, meiofio = 0, aparados = 0 }
	for kc = 0, 3 do
		local rotC = CFrame.Angles(0, kc * math.pi / 2, 0)
		local dir = NOMES_DIR[kc]
		for _, c in ipairs(vila.Casas:GetChildren()) do
			if c.Name:match("^Casa" .. dir .. "[AB]%d+$") then
				local f = c:FindFirstChild("Fundacao")
				local l = rotC:PointToObjectSpace(c:GetPivot().Position)
				local w = f and (f.Size.X - 0.8) or 24
				if l.X + w / 2 + 1.0 > ANEL - 24 then c:Destroy(); cont.casas += 1 end
			end
		end
		for _, m in ipairs(vila.Mobiliario:GetChildren()) do
			local p = m:GetPivot().Position
			local l = rotC:PointToObjectSpace(p)
			if p.Magnitude > 120 and l.X > 165 and l.X < 232 and math.abs(l.Z) < 50 then m:Destroy(); cont.mobil += 1 end
		end
	end
	for kc = 0, 3 do
		for _, kd in ipairs({ (kc + 1) % 4, (kc + 3) % 4 }) do
			local B = baseLateral(kc, kd)
			for _, mdl in ipairs(vila.Pedras:GetChildren()) do
				if mdl.Name:sub(1, 4) == "Calc" and not mdl.Name:find("Anel") then
					for _, p in ipairs(mdl:GetChildren()) do
						local l = B:PointToObjectSpace(p.Position)
						if l.X > 10.6 and l.X < 24.4 and math.abs(l.Z) < 10.6 then p:Destroy(); cont.pedras += 1 end
					end
				end
			end
			for _, mdl in ipairs(vila.Detalhes:GetChildren()) do
				if mdl.Name == "PedregulhosNovos" then
					for _, p in ipairs(mdl:GetChildren()) do
						local l = B:PointToObjectSpace(p.Position)
						if l.X > 10.0 and l.X < 25.0 and math.abs(l.Z) < 11.0 then p:Destroy(); cont.pedregulhos += 1 end
					end
				end
			end
			for _, p in ipairs(vila.Praca:GetChildren()) do
				if p.Name == "MeioFioRua" and not p:GetAttribute("Anel") then
					local l = B:PointToObjectSpace(p.Position)
					if math.abs(l.X - 10.5) < 0.9 and math.abs(l.Z) < 10.6 + 7 then
						local len = p.Size.X
						local lo, hi = l.Z - len / 2, l.Z + len / 2
						if lo >= -10.6 and hi <= 10.6 then
							p:Destroy(); cont.meiofio += 1
						elseif hi > -10.6 and lo < 10.6 then
							if lo < -10.6 then hi = -10.6 else lo = 10.6 end
							p.Size = Vector3.new(hi - lo, p.Size.Y, p.Size.Z)
							p.Position = B:PointToWorldSpace(Vector3.new(l.X, l.Y, (lo + hi) / 2))
							cont.aparados += 1
						end
					end
				end
			end
		end
	end
	return cont
end

-- as casas do círculo das praças deixam de existir: a muralha passa a fechar a vila
function M.removeCirculoCasas(vila)
	local n = 0
	for _, c in ipairs(vila.Casas:GetChildren()) do
		if c.Name:sub(1, 8) == "CasaCirc" then c:Destroy(); n += 1 end
	end
	return n
end

-- preenche o meio-fio que tinha ficado de fora junto das portas das antigas casas do círculo
function M.completaMeioFio(vila)
	local novos = 0
	for k = 0, 3 do
		local rot = CFrame.Angles(0, k * math.pi / 2, 0)
		local centro = rot:VectorToWorldSpace(Vector3.new(296, 0, 0))
		local m = vila.Pracas:FindFirstChild("Praca" .. NOMES_DIR[k])
		local rr = 46 + 0.8
		local n = math.floor(2 * math.pi * rr / 3.85 + 0.5)
		for i = 0, n - 1 do
			local ang = i * 2 * math.pi / n
			local lx, lz = math.cos(ang) * rr, -math.sin(ang) * rr
			local dPorta = math.abs(((math.deg(ang) + 15) % 30) - 15) * math.pi / 180 * rr
			local boca = (lx < 0 and math.abs(lz) < 11.6)
			if not boca and dPorta <= 5.6 then
				local pos = centro + rot:VectorToWorldSpace(Vector3.new(lx, 0.95, lz))
				P(m, "MeioFio", Vector3.new(4.0, 1.3, 1.7), CFrame.lookAt(pos, Vector3.new(centro.X, 0.95, centro.Z)), (i % 2 == 0) and C.stoneLight or C.stone, Mat.Cobblestone)
				novos += 1
			end
		end
	end
	return novos
end

-- uma meia rua lateral: pista, meios-fios (o interno termina antes da curva), calçadas e pedras
function M.ruaLateral(vila, kc, kd)
	local base = baseLateral(kc, kd)
	local sIn = ladoInterno(base)
	local prim = primeira(kc, kd)
	local nome = NOMES_DIR[kc] .. NOMES_DIR[kd]
	local rng = Random.new(6000 + kc * 10 + kd)
	local praca = vila.Praca
	local x0, x1 = 10.2, 210.0
	local n = math.floor((x1 - x0) / 12.2 + 0.5)
	local seg = (x1 - x0) / n
	for i = 0, n - 1 do
		marca(P(praca, "Rua", Vector3.new(seg + 0.2, 1.0, 20.4), base * CFrame.new(x0 + seg * (i + 0.5), 0, 0), COR_PISO, Mat.Cobblestone))
	end
	for _, s in ipairs({ -1, 1 }) do
		local xe = (s == sIn) and 189.4 or 210.6
		local cn = math.max(1, math.floor((xe - 24.4) / 12.2 + 0.5))
		local cl = (xe - 24.4) / cn
		for i = 0, cn - 1 do
			marca(P(praca, "MeioFioRua", Vector3.new(cl + 0.2, 1.0, 1.4), base * CFrame.new(24.4 + cl * (i + 0.5), 0.75, s * 10.5), (i % 2 == 0) and C.stoneLight or C.stone, Mat.Cobblestone))
		end
	end
	M.pedrasCampo(vila.Pedras, base, 10.6, prim and 209.6 or 189.6, -9.4, 9.45, rng, "RuaAnel" .. nome)
	for _, lado in ipairs({ 1, -1 }) do
		local xe
		if lado == sIn then xe = prim and 188.8 or 176.0 else xe = prim and 224.0 or 211.2 end
		calcadaB(praca, base, lado, 24.4, xe, 11.2, 24.0)
		local a, b = 11.7, 23.5
		if lado == -1 then a, b = -23.5, -11.7 end
		M.pedrasCampo(vila.Pedras, base, 24.8, xe - 0.5, a, b, rng, "CalcAnel" .. nome .. ((lado == 1) and "A" or "B"))
	end
end

-- postes de uma meia rua lateral (lados alternados, como nas ruas cardeais); sem sombras para poupar o renderizador
function M.postesBase(parent, base, xs, rng, prefixo, n0)
	for i, x in ipairs(xs) do
		local lado = (((n0 + i - 1) % 2) == 0) and 1 or -1
		local cf = base * CFrame.new(x, 0.5, lado * 12.2) * CFrame.Angles(0, (lado == 1) and math.pi / 2 or -math.pi / 2, 0)
		semSombras(poste2(parent, cf, estadoPoste(rng), prefixo .. i, prefixo .. i))
	end
end

-- piso, postes e curva de uma meia rua lateral
function M.anelPiso(vila, kc, kd)
	M.ruaLateral(vila, kc, kd)
	local nome = NOMES_DIR[kc] .. NOMES_DIR[kd]
	M.postesBase(vila.Lampioes, baseLateral(kc, kd), { 52, 96, 140, 184 }, Random.new(6500 + kc * 10 + kd), "PosteAnel" .. nome, kc)
end

-- casas das duas margens de uma meia rua lateral
function M.anelCasas(vila, kc, kd)
	local base = baseLateral(kc, kd)
	local sIn = ladoInterno(base)
	local nome = NOMES_DIR[kc] .. NOMES_DIR[kd]
	local rp = M.paramsPiso(vila)
	local cont = { [0] = 0, 0, 0, 0 }
	for _, lado in ipairs({ 1, -1 }) do
		local interno = (lado == sIn)
		local f = M.fileiraRua(vila.Casas, 0, lado, {
			base = base, x0 = interno and 50 or 27, x1 = interno and 150 or 176,
			rng = Random.new(7000 + kc * 100 + kd * 10 + ((lado == 1) and 1 or 2)),
			prefixo = "CasaAnel" .. nome .. ((lado == 1) and "A" or "B"),
			semente = 12000 + kc * 1000 + kd * 200 + ((lado == 1) and 0 or 100),
			tBase = 0.25, tSpan = 0.25, forcaRuina = 0, maxRuina = 1, mobiliario = vila.Mobiliario, rp = rp,
		})
		for _, c in ipairs(f) do cont[c.nivel] += 1 end
	end
	local removidas = 0
	for _, pre in ipairs({ "CalcAnel", "RuaAnel" }) do removidas += M.limpaPedras(vila.Pedras, vila.Casas, pre .. nome) end
	return cont, removidas
end

function M.anelPedregulhos(vila, kc, kd)
	local base = baseLateral(kc, kd)
	local regioes = {
		{ cf = base * CFrame.new(117, 0, 0), sx = 180, sz = 18 },
		{ cf = base * CFrame.new(100, 0, 17.6), sx = 150, sz = 11.8 },
		{ cf = base * CFrame.new(100, 0, -17.6), sx = 150, sz = 11.8 },
	}
	local _, n = M.pedregulhosNovos(vila.Detalhes, Random.new(8500 + kc * 10 + kd), 150, regioes, M.paramsPiso(vila), vila.Casas)
	return n
end

-- anéis de pedras com Models pequenos (36 pedras) e um filtro opcional para pular posições
function M.pedrasAneis2(root, centro, r0, r1, rng, nome, salta)
	semVariante(function()
		local idx = 0
		for r = r0, r1, 2.4 do
			idx += 1
			local n = math.floor(2 * math.pi * r / 2.35)
			local off = rng:NextNumber(0, 6.28)
			local mdl, gi = nil, 0
			for i = 0, n - 1 do
				local ang = off + i * 2 * math.pi / n
				local pos = centro + Vector3.new(math.cos(ang) * r, 0, math.sin(ang) * r)
				if not (salta and salta(pos)) then
					if not mdl or i % 36 == 0 then
						if mdl then mdl.Parent = root end
						gi += 1
						mdl = Instance.new("Model")
						mdl.Name = nome .. idx .. "_" .. gi
					end
					pedraNova(mdl, CFrame.lookAt(pos, centro) * CFrame.Angles(0, rng:NextNumber(-0.1, 0.1), 0), rng:NextNumber(1.9, 2.25) * 1.16, rng:NextNumber(1.9, 2.2) * 1.18, rng)
				end
			end
			if mdl then mdl.Parent = root end
			task.wait()
		end
	end)
end

local function centrosPracas()
	local lista = {}
	for k = 0, 3 do lista[#lista + 1] = CFrame.Angles(0, k * math.pi / 2, 0):VectorToWorldSpace(Vector3.new(296, 0, 0)) end
	return lista
end

-- passeio em anel diante da muralha: lajes-base e pedras de r = 325 a 346 (menos onde estão as praças)
function M.passeioMuro(vila, semente)
	local rng = Random.new(semente)
	local centros = centrosPracas()
	local function naPraca(x, z, folga)
		for _, c in ipairs(centros) do
			local dx, dz = x - c.X, z - c.Z
			if dx * dx + dz * dz < (46 + folga) ^ 2 then return true end
		end
		return false
	end
	local rm = 335.5
	local n = math.floor(2 * math.pi * rm / 12 + 0.5)
	for i = 0, n - 1 do
		local ang = i * 2 * math.pi / n
		local pos = Vector3.new(math.cos(ang) * rm, 0, math.sin(ang) * rm)
		if not naPraca(pos.X, pos.Z, -2) then
			marca(P(vila.Praca, "Calcada", Vector3.new(2 * math.pi * rm / n + 0.5, 1.0, 23.0), CFrame.lookAt(pos, Vector3.zero), COR_PISO, Mat.Cobblestone))
		end
	end
	M.pedrasAneis2(vila.Pedras, Vector3.zero, 325.2, 346.0, rng, "Muralha", function(pos) return naPraca(pos.X, pos.Z, 1.5) end)
end

-- 24 postes sobre o passeio da muralha (sem os que cairiam sobre as praças)
function M.postesMuro(parent, rng)
	local centros = centrosPracas()
	local feitos = 0
	for j = 0, 23 do
		local phi = math.rad(7.5 + 15 * j)
		local pos = Vector3.new(math.cos(phi) * 334, 0.5, math.sin(phi) * 334)
		local perto = false
		for _, c in ipairs(centros) do
			if (Vector3.new(pos.X, 0, pos.Z) - c).Magnitude < 50 then perto = true end
		end
		if not perto then
			local cf = CFrame.lookAt(pos, Vector3.new(0, 0.5, 0)) * CFrame.Angles(0, -math.pi / 2, 0)
			semSombras(poste2(parent, cf, estadoPoste(rng), "PosteMuro" .. (j + 1), "PosteMuro" .. (j + 1)))
			feitos += 1
		end
	end
	return feitos
end

-- plano das casas da muralha: larguras sorteadas até fechar a volta; a sobra é repartida entre as folgas
function M.planoMuralha(semente)
	local rng = Random.new(semente)
	local plano, acum = {}, 0
	while true do
		local w, d = rng:NextInteger(19, 25), rng:NextInteger(16, 24)
		local passo = (w + 0.6 + 2.2 + rng:NextNumber(0, 1.6)) / RF_MURO
		if acum + passo > 2 * math.pi then break end
		plano[#plano + 1] = { w = w, d = d, passo = passo }
		acum += passo
	end
	local extra = (2 * math.pi - acum) / #plano
	local ang = 0
	for _, c in ipairs(plano) do
		c.passo += extra
		c.phi = ang + c.passo / 2
		ang += c.passo
		c.t = rng:NextNumber(0.35, 0.8)
		c.nivel = sorteiaNivel(rng, c.t)
		c.estado = sorteiaEstado(rng, c.t)
		c.andares = ANDARES[rng:NextInteger(1, #ANDARES)]
		c.gable = rng:NextNumber() < 0.35
		c.plaster = M.plasters[rng:NextInteger(1, #M.plasters)]
		c.yaw = rng:NextNumber(-0.03, 0.03)
	end
	limitaRuina(plano, 8, rng)
	return plano
end

-- constrói as casas i0..i1 do plano da muralha, todas com a frente voltada para o centro da vila
function M.muralhaCasas(vila, plano, i0, i1, semente)
	local rng = Random.new(semente + i0)
	local rp = M.paramsPiso(vila)
	local cont = { [0] = 0, 0, 0, 0 }
	for i = i0, math.min(i1, #plano) do
		local c = plano[i]
		local rc = RF_MURO + c.d / 2 + JET
		local pos = Vector3.new(math.cos(c.phi) * rc, 0, math.sin(c.phi) * rc)
		local cf = CFrame.lookAt(pos, Vector3.zero) * CFrame.Angles(0, c.yaw, 0)
		local nome = "CasaMuro" .. i
		local o = {
			name = nome, grupo = nome, seed = semente + i,
			w = c.w, d = c.d, andares = c.andares, plaster = c.plaster, gableFront = c.gable,
			estado = c.estado, ruina = c.nivel, desbote = 0.04 * c.t,
		}
		local m = M.casaVelha(vila.Casas, cf, o)
		if c.nivel >= 2 then M.entulho(m, cf, o, (c.nivel == 2) and rng:NextInteger(10, 16) or rng:NextInteger(26, 40), rng, rp) end
		adornos(vila.Mobiliario, cf, o, rng)
		cont[c.nivel] += 1
		task.wait()
	end
	return cont
end

-- pivôs fixos nos Models novos desta extensão (ver fixaPivos)
function M.fixaPivos2(vila)
	local n = 0
	local function fixa(m)
		if m:IsA("Model") then m.WorldPivot = m:GetPivot(); n += 1 end
	end
	for _, c in ipairs(vila.Lampioes:GetChildren()) do
		if c.Name:find("Anel") or c.Name:find("Muro") then fixa(c) end
	end
	for _, c in ipairs(vila.Pedras:GetChildren()) do
		if c.Name:match("^RuaAnel") or c.Name:match("^CalcAnel") or c.Name:match("^Muralha") then fixa(c) end
	end
	for _, c in ipairs(vila.Mobiliario:GetChildren()) do
		if c:GetPivot().Position.Magnitude > 84 then fixa(c) end
	end
	for _, c in ipairs(vila.Detalhes:GetChildren()) do
		if c.Name == "PedregulhosNovos" then fixa(c) end
	end
	return n
end

-- apaga o que a extensão 6 criou (para refazer): casas, pedras, ruas laterais e postes
function M.limparAnel(vila)
	local cont = { casas = 0, pedras = 0, praca = 0, postes = 0 }
	for _, c in ipairs(vila.Casas:GetChildren()) do
		if c.Name:sub(1, 8) == "CasaAnel" or c.Name:sub(1, 8) == "CasaMuro" then c:Destroy(); cont.casas += 1 end
	end
	for _, c in ipairs(vila.Pedras:GetChildren()) do
		if c.Name:match("^RuaAnel") or c.Name:match("^CalcAnel") or c.Name:match("^Muralha") then c:Destroy(); cont.pedras += 1 end
	end
	for _, p in ipairs(vila.Praca:GetChildren()) do
		if p:GetAttribute("Anel") then p:Destroy(); cont.praca += 1 end
	end
	for _, c in ipairs(vila.Lampioes:GetChildren()) do
		if c.Name:find("PosteAnel") or c.Name:find("PosteMuro") then c:Destroy(); cont.postes += 1 end
	end
	return cont
end
```

## Observações
- `limparExtensao` (parte 9) apaga também as lajes `Calcada`, as peças `Rua` e `MeioFioRua` a mais de 216 do centro (inclusive as do anel viário) e as casas cujo nome contém um nome de direção (inclusive `CasaAnel...`); as casas `CasaMuro...` não casam com esse filtro e precisam de `limparAnel`.
- O `ANDARES`, `JET`, `COR_PISO`, `C`, `Mat`, `P` e `NOMES_DIR` são locais do módulo, definidos antes deste bloco.

## Relacionados
- [[Módulo ConstrutorVilaGrande - Visão geral e API]]
- [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]]
- [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]]
