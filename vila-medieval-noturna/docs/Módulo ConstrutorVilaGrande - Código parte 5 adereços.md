---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, aderecos]
---
# Módulo ConstrutorVilaGrande - Código parte 5 adereços
Índice: [[Jogos - Gerais]]

## Conceito
- Funções auxiliares `feno`, `carroca`, `cerca` e `barraca`, e a função pública `M.aderecos` que as combina ao longo das ruas e da praça. Segue a [[Módulo ConstrutorVilaGrande - Código parte 4 praça, pedras e detalhes]].

## Código
```lua
-- ===== adereços: carroça, feno, cercas e barracas de feira =====
local function feno(parent, pos, yaw)
	local b = P(parent, "Feno", Vector3.new(2.8, 2.6, 2.6), CFrame.new(pos + Vector3.new(0, 1.3, 0)) * CFrame.Angles(0, yaw, 0), Color3.fromRGB(148, 122, 66), Mat.Fabric)
	b.Shape = Enum.PartType.Cylinder
	return b
end

local function carroca(parent, cf)
	local m = Instance.new("Model")
	m.Name = "Carroca"
	P(m, "Estrado", Vector3.new(7, 0.5, 4), cf * CFrame.new(0, 2.4, 0), C.woodLight, Mat.WoodPlanks)
	for _, sz in ipairs({ -1.9, 1.9 }) do
		P(m, "LateralCarroca", Vector3.new(7, 1.3, 0.25), cf * CFrame.new(0, 3.2, sz), C.wood, Mat.WoodPlanks, false)
	end
	P(m, "FundoCarroca", Vector3.new(0.25, 1.3, 3.6), cf * CFrame.new(-3.4, 3.2, 0), C.wood, Mat.WoodPlanks, false)
	P(m, "Carga", Vector3.new(6, 1.4, 3.3), cf * CFrame.new(0, 3.5, 0), Color3.fromRGB(150, 126, 70), Mat.Fabric, false)
	for _, sz in ipairs({ -2.3, 2.3 }) do
		local w = P(m, "Roda", Vector3.new(0.4, 3.2, 3.2), cf * CFrame.new(0.4, 1.6, sz) * CFrame.Angles(0, math.pi / 2, 0), C.woodDark, Mat.Wood)
		w.Shape = Enum.PartType.Cylinder
	end
	P(m, "Eixo", Vector3.new(0.3, 0.3, 5), cf * CFrame.new(0.4, 1.6, 0), C.metal, Mat.Metal, false, false)
	for _, sz in ipairs({ -1.1, 1.1 }) do
		P(m, "Timao", Vector3.new(5.5, 0.3, 0.3), cf * CFrame.new(5.2, 1.7, sz) * CFrame.Angles(0, 0, -0.18), C.woodLight, Mat.Wood, false)
	end
	m.Parent = parent
	return m
end

local function cerca(parent, a, b)
	local d = (b - a)
	local len = d.Magnitude
	local n = math.max(1, math.floor(len / 4))
	for i = 0, n do
		local p = a + d * (i / n)
		P(parent, "MouraoCerca", Vector3.new(0.5, 3.8, 0.5), CFrame.new(p + Vector3.new(0, 1.9, 0)), C.woodLight, Mat.Wood, false)
	end
	for _, y in ipairs({ 1.4, 2.8 }) do
		local mid = (a + b) / 2 + Vector3.new(0, y, 0)
		P(parent, "TrilhoCerca", Vector3.new(0.3, 0.38, len), CFrame.lookAt(mid, mid + d), C.wood, Mat.Wood, false)
	end
end

local function barraca(parent, cf, grupo)
	local m = Instance.new("Model")
	m.Name = "Barraca"
	for _, px in ipairs({ -3.2, 3.2 }) do
		for _, pz in ipairs({ -2.2, 2.2 }) do
			P(m, "PostoBarraca", Vector3.new(0.5, 7.2, 0.5), cf * CFrame.new(px, 3.6, pz), C.wood, Mat.Wood, false)
		end
	end
	P(m, "Balcao", Vector3.new(6.6, 0.5, 3.4), cf * CFrame.new(0, 3.2, -0.4), C.woodLight, Mat.WoodPlanks)
	P(m, "FrenteBalcao", Vector3.new(6.6, 3, 0.3), cf * CFrame.new(0, 1.6, -2.1), C.wood, Mat.WoodPlanks, false)
	for i = 0, 5 do
		local col = (i % 2 == 0) and Color3.fromRGB(128, 44, 38) or Color3.fromRGB(196, 176, 138)
		P(m, "Toldo", Vector3.new(1.25, 0.25, 5.6), cf * CFrame.new(-3.1 + i * 1.24, 7.6, 0) * CFrame.Angles(0.16, 0, 0), col, Mat.Fabric, false)
	end
	local frutas = { Color3.fromRGB(150, 40, 34), Color3.fromRGB(176, 130, 36), Color3.fromRGB(86, 112, 44) }
	for i = 1, 9 do
		local f = P(m, "Fruta", Vector3.new(0.7, 0.7, 0.7), cf * CFrame.new(-2.6 + (i % 5) * 1.3, 3.8, -0.9 + math.floor(i / 5) * 1.2), frutas[(i % 3) + 1], Mat.SmoothPlastic, false, false)
		f.Shape = Enum.PartType.Ball
	end
	local lant = P(m, "LanternaBarraca", Vector3.new(0.9, 1.3, 0.9), cf * CFrame.new(0, 6.0, 2.0), C.dark, Mat.Glass, false, false)
	luzPonto(lant, 30, 1.2, false)
	tagLuz(lant, "ligada", grupo)
	aplicaLuz(lant, "ligada")
	m.Parent = parent
	return m
end

function M.aderecos(parent)
	local root = Instance.new("Folder")
	root.Name = "Aderecos"
	local rng = Random.new(2718)
	for k = 0, 3 do
		local rot = CFrame.Angles(0, k * math.pi / 2, 0)
		carroca(root, rot * CFrame.new(70 + rng:NextNumber(0, 6), 0.5, 14.5 * ((k % 2 == 0) and 1 or -1)) * CFrame.Angles(0, rng:NextNumber(-0.5, 0.5), 0))
		for i = 1, 3 do
			feno(root, (rot * CFrame.new(rng:NextNumber(66, 84), 0.5, ((k % 2 == 0) and -1 or 1) * rng:NextNumber(13.5, 17))).Position, rng:NextNumber(0, 3))
		end
		-- cercas de madeira junto às ruas
		for _, side in ipairs({ -1, 1 }) do
			for _, seg in ipairs({ { 88, 104 }, { 124, 140 }, { 160, 178 } }) do
				cerca(root, (rot * CFrame.new(seg[1], 0.5, side * 15.2)).Position, (rot * CFrame.new(seg[2], 0.5, side * 15.2)).Position)
			end
		end
	end
	for k = 0, 3 do
		local ang = math.rad(45 + k * 90)
		local pos = Vector3.new(math.cos(ang) * 47, 0.5, -math.sin(ang) * 47)
		barraca(root, CFrame.lookAt(pos, Vector3.new(0, 0.5, 0)) * CFrame.Angles(0, math.pi, 0), "barraca" .. k)
	end
	root.Parent = parent
	return root
end
```

## Relacionados
- [[Adereços - Carroças, feno, cercas e barracas]]
- [[Módulo ConstrutorVilaGrande - Código parte 6 fonte]]
