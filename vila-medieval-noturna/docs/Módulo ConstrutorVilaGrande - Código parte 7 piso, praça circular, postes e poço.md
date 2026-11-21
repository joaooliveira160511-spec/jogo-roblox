---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, expansao, piso, poco]
---
# Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço
Índice: [[Jogos - Gerais]]

## Conceito
- Primeiro bloco da extensão, acrescentado ao módulo antes do `return M` final, depois do código de [[Módulo ConstrutorVilaGrande - Código parte 6 fonte]]. Reúne os utilitários de piso e as funções de rua longa, calçada, pedras, praça circular, postes, lenha, poço e pedregulhos novos. Usa os locais `P`, `Cyl`, `slateColor`, `tagLuz`, `aplicaLuz` e `luzPonto` do início do arquivo (ver [[Módulo ConstrutorVilaGrande - Código parte 1 base e luzes]]).

## Código
```lua
-- =====================================================================
-- EXTENSÃO 1: ruas longas, calçadas, pedras, praças circulares, postes e poço.
-- Usa os locais P, Cyl, slateColor, tagLuz, aplicaLuz e luzPonto definidos acima.
-- =====================================================================
local HB, FH, JET = 9, 8.5, 2.4 -- altura da base, altura de cada andar e balanço (iguais aos de M.casa)
local COR_PISO = Color3.fromRGB(46, 45, 46)

-- tons de parede mais gastos, para as casas afastadas
M.plastersVelhos = {
	Color3.fromRGB(88, 72, 58),
	Color3.fromRGB(76, 66, 56),
	Color3.fromRGB(68, 62, 54),
	Color3.fromRGB(92, 82, 66),
	Color3.fromRGB(64, 68, 58),
	Color3.fromRGB(80, 68, 60),
}

-- as pedras do piso não usam MaterialVariant; desliga durante a construção e restaura ao fim
local function semVariante(fn)
	local v = M.variant[Mat.Cobblestone]
	M.variant[Mat.Cobblestone] = nil
	local ok, err = pcall(fn)
	M.variant[Mat.Cobblestone] = v
	if not ok then error(err, 0) end
end

-- encosta a peça no topo da superfície que está abaixo dela (raycast só contra rp)
local function assenta(p, rp, afund)
	local cf = p.CFrame
	local s = p.Size
	local meio = 0.5 * (math.abs(cf.RightVector.Y) * s.X + math.abs(cf.UpVector.Y) * s.Y + math.abs(cf.LookVector.Y) * s.Z)
	local r = workspace:Raycast(Vector3.new(cf.Position.X, 6, cf.Position.Z), Vector3.new(0, -10, 0), rp)
	if not r then return false end
	p.CFrame = cf + Vector3.new(0, r.Position.Y + meio * (1 - (afund or 0.2)) - cf.Position.Y, 0)
	return true
end

-- parâmetros de raycast que enxergam só o piso (pedras, praça, praças circulares), nunca o terreno
function M.paramsPiso(vila)
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Include
	local lista = { vila.Pedras, vila.Praca }
	if vila:FindFirstChild("Pracas") then lista[#lista + 1] = vila.Pracas end
	rp.FilterDescendantsInstances = lista
	return rp
end

-- laje de pedra do piso final: topo entre 0,65 e 0,95, cor em cinza frio, musgosa ou azulada
local function pedraNova(parent, cf, sx, sz, rng)
	local h = rng:NextNumber(0.55, 0.95)
	local top = 0.53 + rng:NextNumber(0.12, 0.42)
	local g = rng:NextInteger(66, 118)
	local t = rng:NextNumber()
	local col
	if t < 0.12 then col = Color3.fromRGB(g - 22, g - 4, g - 20)
	elseif t < 0.30 then col = Color3.fromRGB(g - 14, g - 8, g + 10)
	else col = Color3.fromRGB(g - 8, g - 5, g + 2) end
	return P(parent, "Pedra", Vector3.new(sx, h, sz), cf * CFrame.new(0, top - h / 2, 0) * CFrame.Angles(rng:NextNumber(-0.05, 0.05), 0, rng:NextNumber(-0.05, 0.05)), col, Mat.Cobblestone, true, true)
end

-- continuação da rua (mesma cor, espessura e meio-fio das ruas originais); i0 mantém a alternância dos meios-fios
function M.ruaExtensao(parent, k, x0, x1, i0)
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	local n = math.max(1, math.floor((x1 - x0) / 12.2 + 0.5))
	local seg = (x1 - x0) / n
	for i = 0, n - 1 do
		local x = x0 + seg * (i + 0.5)
		P(parent, "Rua", Vector3.new(seg + 0.2, 1.0, 20.4), rot * CFrame.new(x, 0, 0), COR_PISO, Mat.Cobblestone)
		for _, s in ipairs({ -1, 1 }) do
			P(parent, "MeioFioRua", Vector3.new(seg + 0.2, 1.0, 1.4), rot * CFrame.new(x, 0.75, s * 10.5), ((i + i0) % 2 == 0) and C.stoneLight or C.stone, Mat.Cobblestone)
		end
	end
end

-- lajes-base da calçada (topo em 0,5, como a rua); lado = 1 ou -1, zi..zf = distância ao eixo da rua
function M.calcada(parent, k, lado, x0, x1, zi, zf)
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	local n = math.max(1, math.floor((x1 - x0) / 12.2 + 0.5))
	local seg = (x1 - x0) / n
	for i = 0, n - 1 do
		P(parent, "Calcada", Vector3.new(seg + 0.2, 1.0, zf - zi), rot * CFrame.new(x0 + seg * (i + 0.5), 0, lado * (zi + zf) / 2), COR_PISO, Mat.Cobblestone)
	end
end

-- campo retangular de pedras no referencial da rua (x ao longo, z lateral); Models de 6 fileiras
function M.pedrasCampo(root, rot, x0, x1, z0, z1, rng, nome)
	semVariante(function()
		local mdl, fil, idx = nil, 0, 0
		for x = x0, x1, 2.4 do
			if not mdl or fil % 6 == 0 then
				if mdl then mdl.Parent = root; task.wait() end
				idx += 1
				mdl = Instance.new("Model")
				mdl.Name = nome .. "_" .. idx
			end
			fil += 1
			for z = z0, z1, 2.35 do
				local cf = rot * CFrame.new(x + rng:NextNumber(-0.15, 0.15), 0, z + rng:NextNumber(-0.12, 0.12)) * CFrame.Angles(0, rng:NextNumber(-0.12, 0.12), 0)
				pedraNova(mdl, cf, rng:NextNumber(2.0, 2.3) * 1.16, rng:NextNumber(1.9, 2.2) * 1.18, rng)
			end
		end
		if mdl then mdl.Parent = root end
	end)
end

-- anéis concêntricos de pedras voltadas para o centro
function M.pedrasAneis(root, centro, r0, r1, rng, nome)
	semVariante(function()
		local idx = 0
		for r = r0, r1, 2.4 do
			idx += 1
			local n = math.floor(2 * math.pi * r / 2.35)
			local off = rng:NextNumber(0, 6.28)
			local per = math.ceil(n / 6)
			local modelos = {}
			for i = 0, n - 1 do
				local ang = off + i * 2 * math.pi / n
				local gi = math.floor(i / per)
				local mdl = modelos[gi]
				if not mdl then
					mdl = Instance.new("Model")
					mdl.Name = nome .. idx .. "_" .. gi
					modelos[gi] = mdl
				end
				local pos = centro + Vector3.new(math.cos(ang) * r, 0, math.sin(ang) * r)
				local cf = CFrame.lookAt(pos, centro) * CFrame.Angles(0, rng:NextNumber(-0.1, 0.1), 0)
				pedraNova(mdl, cf, rng:NextNumber(1.9, 2.25) * 1.16, rng:NextNumber(1.9, 2.2) * 1.18, rng)
			end
			for _, mdl in pairs(modelos) do mdl.Parent = root end
			task.wait()
		end
	end)
end

-- remove as pedras (de Models cujo nome começa por prefixo) que ficam sob peças das casas
function M.limpaPedras(root, casas, prefixo)
	local op = OverlapParams.new()
	op.FilterType = Enum.RaycastFilterType.Include
	op.FilterDescendantsInstances = { casas }
	local removidas, feitas = 0, 0
	for _, mdl in ipairs(root:GetChildren()) do
		if mdl.Name:sub(1, #prefixo) == prefixo then
			for _, p in ipairs(mdl:GetChildren()) do
				local pos = p.Position
				if #workspace:GetPartBoundsInBox(CFrame.new(pos.X, 1.2, pos.Z), Vector3.new(1.7, 1.4, 1.7), op) > 0 then
					p:Destroy()
					removidas += 1
				end
			end
			feitas += 1
			if feitas % 25 == 0 then task.wait() end
		end
	end
	return removidas
end

-- praça circular: discos de piso, anel central de ardósia e meio-fio com bocas
-- centro: Vector3 (y = 0); rot: CFrame de rotação cujo +X aponta para longe da vila (a entrada fica em -X local)
function M.pracaCirculo(parent, centro, R, rot, nome)
	local m = Instance.new("Model")
	m.Name = nome or "PracaCirculo"
	Cyl(m, "Piso", R, 1.0, centro, COR_PISO, Mat.Cobblestone)
	Cyl(m, "PisoAnel1", R - 8, 1.02, centro, COR_PISO, Mat.Cobblestone)
	Cyl(m, "PisoAnel2", R - 16, 1.04, centro, COR_PISO, Mat.Cobblestone)
	Cyl(m, "PisoAnel3", R - 32, 1.06, centro, Color3.fromRGB(44, 44, 48), Mat.Slate)
	local rr = R + 0.8
	local n = math.floor(2 * math.pi * rr / 3.85 + 0.5)
	for i = 0, n - 1 do
		local ang = i * 2 * math.pi / n
		local lx, lz = math.cos(ang) * rr, -math.sin(ang) * rr
		local deg = math.deg(ang)
		local dPorta = math.abs(((deg + 15) % 30) - 15) * math.pi / 180 * rr -- distância ao eixo da porta mais próxima
		local boca = (lx < 0 and math.abs(lz) < 11.6)
		if not boca and dPorta > 5.6 then
			local pos = centro + rot:VectorToWorldSpace(Vector3.new(lx, 0.95, lz))
			P(m, "MeioFio", Vector3.new(4.0, 1.3, 1.7), CFrame.lookAt(pos, Vector3.new(centro.X, 0.95, centro.Z)), (i % 2 == 0) and C.stoneLight or C.stone, Mat.Cobblestone)
		end
	end
	m.Parent = parent
	return m
end

-- poste da rua com a luz no ajuste final (alcance 44, brilho 1,25, cor 255,184,108)
local function poste2(parent, cf, estado, grupo, nome)
	local m = M.poste(parent, cf, estado, grupo, nome)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("PointLight") then
			d.Range = 44
			d.Brightness = 1.25
			d.Color = Color3.fromRGB(255, 184, 108)
		end
	end
	return m
end

local function estadoPoste(rng)
	local r = rng:NextNumber()
	if r < 0.45 then return "ligada" elseif r < 0.70 then return "piscando" end
	return "apagada"
end

-- continua a sequência de postes da rua (braço sobre a pista, lados alternados como nas ruas originais)
function M.postesRua(parent, k, xs, rng, prefixo, n0)
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	for i, x in ipairs(xs) do
		local lado = (((n0 + i - 1) % 2) == 0) and 1 or -1
		local cf = rot * CFrame.new(x, 0.5, lado * 12.2) * CFrame.Angles(0, (lado == 1) and math.pi / 2 or -math.pi / 2, 0)
		poste2(parent, cf, estadoPoste(rng), prefixo .. i, prefixo .. i)
	end
end

-- doze postes na borda da praça circular, entre as portas (a cada 30 graus, deslocados de 15)
function M.postesCirculo(parent, centro, rot, R, rng, prefixo)
	local rp = R - 3.5
	for j = 0, 11 do
		local phi = math.rad(15 + 30 * j)
		local pos = centro + rot:VectorToWorldSpace(Vector3.new(math.cos(phi) * rp, 0.5, -math.sin(phi) * rp))
		local cf = CFrame.lookAt(pos, Vector3.new(centro.X, 0.5, centro.Z)) * CFrame.Angles(0, -math.pi / 2, 0)
		poste2(parent, cf, estadoPoste(rng), prefixo .. (j + 1), prefixo .. (j + 1))
	end
end

-- pilha de lenha (3 fileiras de toras)
function M.lenha(parent, cf, rng)
	local m = Instance.new("Model")
	m.Name = "Lenha"
	for fila = 0, 2 do
		local n = 6 - fila
		for i = 1, n do
			local x = (i - (n + 1) / 2) * 0.72
			local v = rng:NextInteger(0, 14)
			local p = P(m, "Tora", Vector3.new(3.0, 0.7, 0.7), cf * CFrame.new(x, 0.42 + fila * 0.62, 0) * CFrame.Angles(0, math.pi / 2, 0), Color3.fromRGB(44 + v, 34 + v, 26 + v), Mat.Wood, fila == 0, false)
			p.Shape = Enum.PartType.Cylinder
		end
	end
	for _, sx in ipairs({ -1, 1 }) do
		P(m, "EstacaLenha", Vector3.new(0.3, 2.2, 0.3), cf * CFrame.new(sx * 2.3, 1.1, 0), C.woodDark, Mat.Wood, false, false)
	end
	m.Parent = parent
	return m
end

-- poço coberto no centro da praça circular; ruina = true tira uma água do telhado e solta o balde
function M.poco(parent, cf, estado, grupo, ruina)
	local m = Instance.new("Model")
	m.Name = "Poco"
	local function at(x, y, z) return (cf * CFrame.new(x, y, z)).Position end
	Cyl(m, "PocoSoleira", 4.8, 0.6, at(0, 0.8, 0), C.stoneDark, Mat.Cobblestone)
	Cyl(m, "PocoMuro", 3.5, 3.0, at(0, 2.6, 0), C.stone, Mat.Cobblestone)
	Cyl(m, "PocoBorda", 3.8, 0.45, at(0, 4.33, 0), C.stoneLight, Mat.Cobblestone)
	local agua = Cyl(m, "PocoAgua", 2.7, 0.08, at(0, 4.6, 0), Color3.fromRGB(8, 14, 22), Mat.Glass, false, false)
	agua.Reflectance = 0.3
	for _, sx in ipairs({ -1, 1 }) do
		P(m, "PocoPoste", Vector3.new(0.6, 7.6, 0.6), cf * CFrame.new(sx * 3.2, 8.3, 0), C.woodDark, Mat.Wood)
	end
	P(m, "PocoViga", Vector3.new(7.4, 0.6, 0.7), cf * CFrame.new(0, 12.3, 0), C.wood, Mat.Wood, false)
	local tel = Color3.fromRGB(40, 42, 50)
	for _, s in ipairs({ -1, 1 }) do
		if not (ruina and s == -1) then
			P(m, "PocoTelhado", Vector3.new(8.6, 0.4, 4.6), cf * CFrame.new(0, 12.9, s * 1.87) * CFrame.Angles(s * 0.62, 0, 0), tel, Mat.Slate)
		end
	end
	if not ruina then P(m, "PocoCumeeira", Vector3.new(8.8, 0.4, 0.6), cf * CFrame.new(0, 14.15, 0), Color3.fromRGB(34, 36, 42), Mat.Slate, false) end
	local rolo = P(m, "PocoRolo", Vector3.new(7.0, 0.55, 0.55), cf * CFrame.new(0, 10.2, 0), C.wood, Mat.Wood, false, false)
	rolo.Shape = Enum.PartType.Cylinder
	P(m, "PocoManivela", Vector3.new(0.3, 0.3, 1.6), cf * CFrame.new(3.9, 10.2, 0.6), C.metal, Mat.Metal, false, false)
	if ruina then
		Cyl(m, "PocoBalde", 0.7, 0.9, at(2.4, 0.95, -4.2), C.woodLight, Mat.Wood, false, false)
	else
		P(m, "PocoCorda", Vector3.new(0.12, 4.6, 0.12), cf * CFrame.new(0, 7.8, 0), Color3.fromRGB(80, 66, 44), Mat.Fabric, false, false)
		Cyl(m, "PocoBalde", 0.7, 0.9, at(0, 5.1, 0), C.woodLight, Mat.Wood, false, false)
		Cyl(m, "PocoAro", 0.74, 0.14, at(0, 5.3, 0), C.metal, Mat.Metal, false, false)
	end
	-- lampião pendurado num braço de ferro
	P(m, "PocoBraco", Vector3.new(0.35, 0.35, 2.6), cf * CFrame.new(3.2, 10.6, -1.3), C.metal, Mat.Metal, false, false)
	P(m, "PocoCorrente", Vector3.new(0.1, 1.2, 0.1), cf * CFrame.new(3.2, 9.9, -2.5), C.metal, Mat.Metal, false, false)
	local lx, ly, lz = 3.2, 8.7, -2.5
	P(m, "LanternaTopo", Vector3.new(1.1, 0.2, 1.1), cf * CFrame.new(lx, ly + 0.7, lz), C.metal, Mat.Metal, false, false)
	P(m, "LanternaBase", Vector3.new(0.9, 0.18, 0.9), cf * CFrame.new(lx, ly - 0.62, lz), C.metal, Mat.Metal, false, false)
	for _, dx in ipairs({ -0.4, 0.4 }) do
		for _, dz in ipairs({ -0.4, 0.4 }) do
			P(m, "LanternaQuina", Vector3.new(0.09, 1.25, 0.09), cf * CFrame.new(lx + dx, ly, lz + dz), C.metal, Mat.Metal, false, false)
		end
	end
	local glass = P(m, "Chama", Vector3.new(0.68, 1.0, 0.68), cf * CFrame.new(lx, ly, lz), C.dark, Mat.Glass, false, false)
	local l = luzPonto(glass, 40, 1.0, true)
	l.Color = Color3.fromRGB(255, 184, 108)
	tagLuz(glass, estado, grupo)
	aplicaLuz(glass, estado)
	m.Parent = parent
	return m
end

-- pedregulhos assentados sobre o piso; regioes = lista de {cf, sx, sz} (retângulos centrados em cf)
function M.pedregulhosNovos(parent, rng, n, regioes, rp, casas)
	local op = OverlapParams.new()
	op.FilterType = Enum.RaycastFilterType.Include
	op.FilterDescendantsInstances = { casas }
	local total = 0
	for _, r in ipairs(regioes) do total += r.sx * r.sz end
	local m = Instance.new("Model")
	m.Name = "PedregulhosNovos"
	local feitos = 0
	for i = 1, n do
		local alvo, acc = rng:NextNumber(0, total), 0
		local reg = regioes[#regioes]
		for _, r in ipairs(regioes) do
			acc += r.sx * r.sz
			if alvo <= acc then reg = r; break end
		end
		local pos = (reg.cf * CFrame.new(rng:NextNumber(-reg.sx / 2, reg.sx / 2), 0, rng:NextNumber(-reg.sz / 2, reg.sz / 2))).Position
		if #workspace:GetPartBoundsInRadius(Vector3.new(pos.X, 1, pos.Z), 0.6, op) == 0 then
			local s = rng:NextNumber(0.2, 0.75)
			local v = rng:NextInteger(46, 96)
			local p = P(m, "Pedregulho", Vector3.new(s * rng:NextNumber(0.8, 1.6), s * rng:NextNumber(0.5, 1.0), s * rng:NextNumber(0.8, 1.4)), CFrame.new(pos.X, 1, pos.Z) * CFrame.Angles(rng:NextNumber(0, 6), rng:NextNumber(0, 6), rng:NextNumber(0, 6)), Color3.fromRGB(v, v - 2, v - 4), Mat.Rock, false, true)
			if assenta(p, rp, 0.2) then feitos += 1 else p:Destroy() end
		end
		if i % 200 == 0 then task.wait() end
	end
	m.Parent = parent
	return m, feitos
end
```

## Pontos de atenção
- `semVariante` zera `M.variant[Cobblestone]` durante a criação das pedras e o restaura mesmo em caso de erro; sem isso, as pedras do piso nasceriam com o MaterialVariant do paralelepípedo, ao contrário das pedras originais (ver [[Piso - Pedras individuais estilo cobblestone]]).
- `assenta` é a regra de repouso de peças pequenas (ver [[Piso - Pedregulhos flutuando e reassentamento]]).
- A função `M.poste` do módulo ainda cria a luz com os valores antigos; `poste2` corrige para alcance 44 e brilho 1,25.

## Relacionados
- [[Módulo ConstrutorVilaGrande - Visão geral e API]]
- [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]]
- [[Ruas - Continuação e calçadas até as praças circulares]]
- [[Praça circular - Anel de casas voltadas para dentro]]
- [[Poço - Centro da praça circular]]
- [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]
