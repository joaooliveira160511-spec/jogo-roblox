---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, praca, pedras]
---
# Módulo ConstrutorVilaGrande - Código parte 4 praça, pedras e detalhes
Índice: [[Jogos - Gerais]]

## Conceito
- Versões finais (compactas, raio 58) de `M.praca`, `M.pedras` e `M.detalhes`, redefinidas no fim do módulo e que substituem as versões antigas de raio 80. Aqui se encontram também a função `pedra2` e a constante `PR`.

## Código
```lua
-- =====================================================================
-- Versão compacta da praça (raio 58), piso estilo cobblestone e adereços de vila antiga.
-- Estas definições substituem as anteriores com o mesmo nome.
-- =====================================================================
local PR = 58

function M.praca(parent)
	local m = Instance.new("Folder")
	m.Name = "Praca"
	local base = Color3.fromRGB(22, 21, 22)
	Cyl(m, "Piso", PR, 1.0, Vector3.new(0, 0, 0), base, Mat.Cobblestone)
	Cyl(m, "PisoAnel1", 50, 1.02, Vector3.new(0, 0, 0), base, Mat.Cobblestone)
	Cyl(m, "PisoAnel2", 42, 1.04, Vector3.new(0, 0, 0), base, Mat.Cobblestone)
	Cyl(m, "PisoAnel3", 34, 1.06, Vector3.new(0, 0, 0), Color3.fromRGB(30, 30, 34), Mat.Slate)
	for k = 0, 95 do
		local ang = k * (math.pi * 2 / 96)
		local deg = math.deg(ang) % 90
		if math.min(deg, 90 - deg) > 10.8 then
			local pos = Vector3.new(math.cos(ang) * (PR + 0.8), 0.95, math.sin(ang) * (PR + 0.8))
			P(m, "MeioFio", Vector3.new(4.0, 1.3, 1.7), CFrame.lookAt(pos, Vector3.new(0, 0.95, 0)), (k % 2 == 0) and C.stoneLight or C.stone, Mat.Cobblestone)
		end
	end
	for k = 0, 3 do
		local rot = CFrame.Angles(0, k * math.pi / 2, 0)
		for i = 0, 12 do
			local x = PR - 1 + 6.1 + i * 12.2
			P(m, "Rua", Vector3.new(12.4, 1.0, 20.4), rot * CFrame.new(x, 0, 0), base, Mat.Cobblestone)
			for _, s in ipairs({ -1, 1 }) do
				P(m, "MeioFioRua", Vector3.new(12.4, 1.0, 1.4), rot * CFrame.new(x, 0.75, s * 10.5), (i % 2 == 0) and C.stoneLight or C.stone, Mat.Cobblestone)
			end
		end
	end
	m.Parent = parent
	return m
end

-- pedra estilo "cobblestone": blocos rudes de alturas diferentes, com juntas escuras entre eles
local function pedra2(parent, cf, sx, sz, rng)
	local h = rng:NextNumber(0.55, 0.95)
	local top = 0.53 + rng:NextNumber(0.12, 0.42)
	local v = rng:NextInteger(112, 172)
	local col
	local t = rng:NextNumber()
	if t < 0.14 then col = Color3.fromRGB(v - 38, v - 12, v - 38)
	elseif t < 0.30 then col = Color3.fromRGB(v - 12, v - 8, v + 6)
	elseif t < 0.40 then col = Color3.fromRGB(v - 6, v - 22, v - 30)
	else col = Color3.fromRGB(v, v - 3, v - 7) end
	P(parent, "Pedra", Vector3.new(sx, h, sz), cf * CFrame.new(0, top - h / 2, 0) * CFrame.Angles(rng:NextNumber(-0.05, 0.05), 0, rng:NextNumber(-0.05, 0.05)), col, Mat.Cobblestone, true, true)
end

function M.pedras(parent)
	local root = Instance.new("Folder")
	root.Name = "Pedras"
	local rng = Random.new(404)
	local ringIdx = 0
	for r = 33.8, PR - 0.8, 2.4 do
		ringIdx += 1
		local n = math.floor(2 * math.pi * r / 2.35)
		local off = rng:NextNumber(0, 6.28)
		local modelos = {}
		local per = math.ceil(n / 6)
		for i = 0, n - 1 do
			local ang = off + i * 2 * math.pi / n
			local gi = math.floor(i / per)
			local mdl = modelos[gi]
			if not mdl then mdl = Instance.new("Model"); mdl.Name = "Pedras" .. ringIdx .. "_" .. gi; modelos[gi] = mdl end
			local pos = Vector3.new(math.cos(ang) * r, 0, math.sin(ang) * r)
			local cf = CFrame.lookAt(pos, Vector3.zero) * CFrame.Angles(0, rng:NextNumber(-0.1, 0.1), 0)
			pedra2(mdl, cf, rng:NextNumber(1.9, 2.25), rng:NextNumber(1.9, 2.2), rng)
		end
		for _, mdl in pairs(modelos) do mdl.Parent = root end
		task.wait()
	end
	for k = 0, 3 do
		local rot = CFrame.Angles(0, k * math.pi / 2, 0)
		local mdl, row = nil, 0
		for x = PR + 0.6, 214, 2.4 do
			if not mdl or row % 6 == 0 then
				if mdl then mdl.Parent = root end
				mdl = Instance.new("Model"); mdl.Name = "PedrasRua" .. k .. "_" .. math.floor(x)
			end
			row += 1
			for z = -9.4, 9.45, 2.35 do
				local cf = rot * CFrame.new(x + rng:NextNumber(-0.15, 0.15), 0, z + rng:NextNumber(-0.12, 0.12)) * CFrame.Angles(0, rng:NextNumber(-0.12, 0.12), 0)
				pedra2(mdl, cf, rng:NextNumber(2.0, 2.3), rng:NextNumber(1.9, 2.2), rng)
			end
		end
		if mdl then mdl.Parent = root end
		task.wait()
	end
	root.Parent = parent
	return root
end

-- pedregulhos entre as pedras, musgo, rochas e poças; usa raycast para assentar nas pedras
function M.detalhes(parent)
	local root = Instance.new("Folder")
	root.Name = "Detalhes"
	local rng = Random.new(808)
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude
	rp.FilterDescendantsInstances = {}
	local function ponto()
		if rng:NextNumber() < 0.55 then
			local r = rng:NextNumber(34, PR - 1)
			local a = rng:NextNumber(0, 6.283)
			return Vector3.new(math.cos(a) * r, 0, math.sin(a) * r)
		else
			local k = rng:NextInteger(0, 3)
			return CFrame.Angles(0, k * math.pi / 2, 0) * Vector3.new(rng:NextNumber(PR + 1, 205), 0, rng:NextNumber(-9.4, 9.4))
		end
	end
	local function topo(p)
		local r = workspace:Raycast(Vector3.new(p.X, 4, p.Z), Vector3.new(0, -6, 0), rp)
		return r and r.Position.Y or 0.9
	end
	local pebbles = Instance.new("Model"); pebbles.Name = "Pedregulhos"
	for i = 1, 1500 do
		local p = ponto()
		local s = rng:NextNumber(0.2, 0.75)
		local v = rng:NextInteger(70, 140)
		P(pebbles, "Pedregulho", Vector3.new(s * rng:NextNumber(0.8, 1.6), s * rng:NextNumber(0.5, 1.0), s * rng:NextNumber(0.8, 1.4)), CFrame.new(p.X, topo(p) + s * 0.12, p.Z) * CFrame.Angles(rng:NextNumber(0, 6), rng:NextNumber(0, 6), rng:NextNumber(0, 6)), Color3.fromRGB(v, v - 2, v - 6), Mat.Rock, false, true)
		if i % 150 == 0 then task.wait() end
	end
	pebbles.Parent = root
	local rocks = Instance.new("Model"); rocks.Name = "Rochas"
	for i = 1, 70 do
		local k = rng:NextInteger(0, 3)
		local x = rng:NextNumber(PR + 4, 205)
		local z = (rng:NextInteger(0, 1) * 2 - 1) * rng:NextNumber(11.8, 15)
		local p = CFrame.Angles(0, k * math.pi / 2, 0) * Vector3.new(x, 0, z)
		local s = rng:NextNumber(1.5, 3.4)
		local v = rng:NextInteger(60, 100)
		P(rocks, "Rocha", Vector3.new(s * 1.3, s * 0.8, s), CFrame.new(p.X, s * 0.3, p.Z) * CFrame.Angles(rng:NextNumber(-0.3, 0.3), rng:NextNumber(0, 6), rng:NextNumber(-0.3, 0.3)), Color3.fromRGB(v, v - 2, v - 4), Mat.Rock, true, true)
	end
	rocks.Parent = root
	local musgo = Instance.new("Model"); musgo.Name = "Musgo"
	for i = 1, 220 do
		local p = ponto()
		local r = rng:NextNumber(0.7, 2.0)
		Cyl(musgo, "Musgo", r, 0.08, Vector3.new(p.X, topo(p) + 0.03, p.Z), Color3.fromRGB(rng:NextInteger(34, 52), rng:NextInteger(58, 80), rng:NextInteger(34, 48)), Mat.Grass, false, false)
		if i % 110 == 0 then task.wait() end
	end
	musgo.Parent = root
	local pocas = Instance.new("Model"); pocas.Name = "Pocas"
	for i = 1, 22 do
		local p = ponto()
		local r = rng:NextNumber(2.2, 5.5)
		local puddle = Cyl(pocas, "Poca", r, 0.05, Vector3.new(p.X, 0.86, p.Z), Color3.fromRGB(12, 18, 28), Mat.Glass, false, false)
		puddle.Reflectance = 0.5
		puddle.Transparency = 0.15
	end
	pocas.Parent = root
	root.Parent = parent
	return root
end
```

## Ajustes aplicados após a construção
- `M.praca` cria o piso com cor (22,21,22); depois o piso, os anéis 1 e 2 e as ruas receberam (46,45,46) e o anel 3 (44,44,48).
- `M.pedras` cria as pedras com tamanhos 1,9 a 2,25; depois X foi multiplicado por 1,16 e Z por 1,18, e as cores foram refeitas (ver [[Piso - Pedras individuais estilo cobblestone]] e [[Piso - Cores das pedras e ajuste de brilho]]); o material foi mantido Cobblestone e `MaterialVariant` foi zerado.
- `M.detalhes`: destruir os Models "Musgo" e "Pocas"; recolorir os pedregulhos com v de 46 a 96 (ver [[Piso - Poças e círculos pretos removidos]]).

## Relacionados
- [[Praça - Geometria e raios]]
- [[Piso - Pedregulhos, rochas e musgo]]
