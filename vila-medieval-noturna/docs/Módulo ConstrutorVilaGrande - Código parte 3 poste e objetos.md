---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, poste]
---
# Módulo ConstrutorVilaGrande - Código parte 3 poste e objetos
Índice: [[Jogos - Gerais]]

## Conceito
- Funções `M.poste` (poste alto com lampião pequeno), `M.barril`, `M.caixa` e `M.banco` (este último não deve ser usado). Vem depois de [[Módulo ConstrutorVilaGrande - Código parte 2 casa]].

## Código
```lua
-- ===== poste alto com lampião pequeno (cf: base no chão; o braço aponta para +X local) =====
function M.poste(parent, cf, estado, grupo, nome)
	local m = Instance.new("Model")
	m.Name = nome or "Poste"
	P(m, "BasePoste", Vector3.new(2.4, 1.8, 2.4), cf * CFrame.new(0, 0.9, 0), C.stoneDark, Mat.Cobblestone)
	Cyl(m, "Pedestal", 1.0, 2.4, (cf * CFrame.new(0, 3.0, 0)).Position, C.stone, Mat.Cobblestone)
	Cyl(m, "Poste", 0.42, 12.4, (cf * CFrame.new(0, 10.4, 0)).Position, C.woodDark, Mat.Wood)
	for _, y in ipairs({ 5.4, 9.5, 14.6 }) do
		Cyl(m, "Aro", 0.62, 0.3, (cf * CFrame.new(0, y, 0)).Position, C.metal, Mat.Metal, false, false)
	end
	P(m, "Braco", Vector3.new(4.4, 0.4, 0.4), cf * CFrame.new(2.0, 15.2, 0), C.metal, Mat.Metal, false)
	P(m, "Escora", Vector3.new(0.35, 3.4, 0.35), cf * CFrame.new(1.1, 13.9, 0) * CFrame.Angles(0, 0, -math.rad(48)), C.metal, Mat.Metal, false, false)
	Cyl(m, "Volta", 0.9, 0.2, (cf * CFrame.new(1.9, 14.3, 0)).Position, C.metal, Mat.Metal, false, false).CFrame = cf * CFrame.new(1.9, 14.3, 0) * CFrame.Angles(math.pi / 2, 0, math.pi / 2)
	local lx = 3.9
	P(m, "Corrente", Vector3.new(0.1, 1.2, 0.1), cf * CFrame.new(lx, 14.5, 0), C.metal, Mat.Metal, false, false)
	local ly = 13.0
	P(m, "LanternaTopo", Vector3.new(1.1, 0.2, 1.1), cf * CFrame.new(lx, ly + 0.7, 0), C.metal, Mat.Metal, false, false)
	P(m, "LanternaPonta", Vector3.new(0.45, 0.3, 0.45), cf * CFrame.new(lx, ly + 0.95, 0), C.metal, Mat.Metal, false, false)
	P(m, "LanternaBase", Vector3.new(0.9, 0.18, 0.9), cf * CFrame.new(lx, ly - 0.62, 0), C.metal, Mat.Metal, false, false)
	for _, dx in ipairs({ -0.4, 0.4 }) do
		for _, dz in ipairs({ -0.4, 0.4 }) do
			P(m, "LanternaQuina", Vector3.new(0.09, 1.25, 0.09), cf * CFrame.new(lx + dx, ly, dz), C.metal, Mat.Metal, false, false)
		end
	end
	local glass = P(m, "Chama", Vector3.new(0.68, 1.0, 0.68), cf * CFrame.new(lx, ly, 0), C.dark, Mat.Glass, false, false)
	luzPonto(glass, 56, 2.8, true)
	tagLuz(glass, estado, grupo)
	aplicaLuz(glass, estado)
	m.Parent = parent
	return m
end

-- ===== objetos de cena =====
function M.barril(parent, pos)
	local m = Instance.new("Model")
	m.Name = "Barril"
	Cyl(m, "Corpo", 1.5, 3.2, pos + Vector3.new(0, 1.6, 0), Color3.fromRGB(84, 58, 38), Mat.Wood)
	for _, y in ipairs({ 0.7, 2.5 }) do
		Cyl(m, "Aro", 1.55, 0.22, pos + Vector3.new(0, y, 0), C.metal, Mat.Metal, false, false)
	end
	m.Parent = parent
	return m
end

function M.caixa(parent, cf)
	local m = Instance.new("Model")
	m.Name = "Caixa"
	P(m, "Corpo", Vector3.new(3, 2.6, 3), cf * CFrame.new(0, 1.3, 0), C.woodLight, Mat.WoodPlanks)
	for _, dx in ipairs({ -1.3, 1.3 }) do
		P(m, "Cinta", Vector3.new(0.3, 2.7, 3.1), cf * CFrame.new(dx, 1.3, 0), C.woodDark, Mat.Wood, false)
	end
	m.Parent = parent
	return m
end

function M.banco(parent, cf)
	local m = Instance.new("Model")
	m.Name = "Banco"
	P(m, "Assento", Vector3.new(6.4, 0.5, 1.8), cf * CFrame.new(0, 2.0, 0), C.woodLight, Mat.WoodPlanks)
	P(m, "Encosto", Vector3.new(6.4, 1.4, 0.3), cf * CFrame.new(0, 3.2, 0.8), C.wood, Mat.WoodPlanks, false)
	P(m, "PernaE", Vector3.new(0.7, 1.8, 1.8), cf * CFrame.new(-2.7, 0.9, 0), C.stoneDark, Mat.Cobblestone)
	P(m, "PernaD", Vector3.new(0.7, 1.8, 1.8), cf * CFrame.new(2.7, 0.9, 0), C.stoneDark, Mat.Cobblestone)
	m.Parent = parent
	return m
end
```

## Chamadas usadas na construção
```lua
local lamps = Instance.new("Folder"); lamps.Name = "Lampioes"; lamps.Parent = workspace.Vila
local rng = Random.new(777)
local function estado()
	local r = rng:NextNumber()
	if r < 0.55 then return "ligada" elseif r < 0.8 then return "piscando" else return "apagada" end
end
local n = 0
-- postes na borda da praça, à frente das casas, braço para o centro
for q = 0, 3 do
	for _, base in ipairs({ 22.7, 45, 67.3 }) do
		n += 1
		local ang = math.rad(base + q * 90)
		local pos = Vector3.new(math.cos(ang) * 54.5, 0.5, -math.sin(ang) * 54.5)
		local cf = CFrame.lookAt(pos, Vector3.new(0, 0.5, 0)) * CFrame.Angles(0, -math.pi / 2, 0)
		V.poste(lamps, cf, estado(), "poste" .. n, "Poste" .. n)
	end
end
-- postes ao longo das ruas
for k = 0, 3 do
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	for i, x in ipairs({ 76, 112, 148, 184 }) do
		n += 1
		local lado = (i % 2 == 1) and 1 or -1
		local cf = rot * CFrame.new(x, 0.5, lado * 12.2) * CFrame.Angles(0, (lado == 1) and math.pi / 2 or -math.pi / 2, 0)
		V.poste(lamps, cf, estado(), "poste" .. n, "Poste" .. n)
	end
end
```
- Depois da construção, as luzes dos postes foram ajustadas para Range 44, Brightness 1,25 e cor (255,184,108) (o módulo ainda cria com Range 56 e Brightness 2,8).

## Relacionados
- [[Postes e lampiões - Geometria e luz]]
- [[Mobiliário - Barris, caixas e bancos removidos]]
