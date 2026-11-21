---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo]
---
# Módulo ConstrutorVilaGrande - Código parte 1 base e luzes
Índice: [[Jogos - Gerais]]

## Conceito
- Início do ModuleScript: paleta, funções auxiliares de criação de peças, sistema de tags de luz, janela, moldura de enxaimel e placa (não usada). Continua em [[Módulo ConstrutorVilaGrande - Código parte 2 casa]].

## Código
```lua
-- ConstrutorVilaGrande: versão em grande escala da vila medieval (casas enxaimel detalhadas,
-- postes altos, fonte gigante com água de terreno, piso de pedras individuais, poças e pedregulhos).
-- Usado em modo Edit via require(); o resultado fica salvo como Parts no Workspace.

local CS = game:GetService("CollectionService")
local M = {}
local Mat = Enum.Material

local C = {
	stone = Color3.fromRGB(96, 92, 86),
	stoneDark = Color3.fromRGB(66, 64, 62),
	stoneLight = Color3.fromRGB(122, 116, 106),
	moss = Color3.fromRGB(44, 64, 42),
	wood = Color3.fromRGB(36, 30, 26),
	woodDark = Color3.fromRGB(26, 21, 18),
	woodLight = Color3.fromRGB(78, 62, 48),
	metal = Color3.fromRGB(28, 27, 26),
	warm = Color3.fromRGB(255, 142, 58),
	dark = Color3.fromRGB(16, 20, 28),
	water = Color3.fromRGB(70, 112, 140),
}
M.C = C

-- paredes de madeira lisa (tons de madeira envelhecida)
M.plasters = {
	Color3.fromRGB(116, 92, 68),
	Color3.fromRGB(98, 80, 62),
	Color3.fromRGB(86, 72, 58),
	Color3.fromRGB(128, 106, 80),
	Color3.fromRGB(80, 84, 68),
	Color3.fromRGB(104, 84, 72),
}

-- materiais PBR gerados (MaterialVariant em MaterialService); ignorados se não existirem
M.variant = {
	[Mat.Cobblestone] = "vila_paralelepipedo",
	[Mat.Slate] = "vila_telhas",
}

local function P(parent, name, size, cf, color, mat, collide, shadow)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = mat or Mat.Plastic
	local mv = M.variant[p.Material]
	if mv then p.MaterialVariant = mv end
	p.Anchored = true
	p.CanCollide = collide ~= false
	p.CanQuery = collide ~= false
	p.CanTouch = false
	local cs = shadow
	if cs == nil then cs = collide ~= false end
	p.CastShadow = cs
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function Cyl(parent, name, radius, height, pos, color, mat, collide, shadow)
	local p = P(parent, name, Vector3.new(height, radius * 2, radius * 2), CFrame.new(pos) * CFrame.Angles(0, 0, math.pi / 2), color, mat, collide, shadow)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function Wedge(parent, name, size, cf, color, mat)
	local w = Instance.new("WedgePart")
	w.Name = name
	w.Size = size
	w.CFrame = cf
	w.Color = color
	w.Material = mat or Mat.Plastic
	local mv = M.variant[w.Material]
	if mv then w.MaterialVariant = mv end
	w.Anchored = true
	w.CanTouch = false
	w.TopSurface = Enum.SurfaceType.Smooth
	w.BottomSurface = Enum.SurfaceType.Smooth
	w.Parent = parent
	return w
end

local function slateColor(rng)
	local v = rng:NextInteger(38, 66)
	local c = Color3.fromRGB(v, v + 2, v + 9)
	local r = rng:NextNumber()
	if r < 0.10 then c = Color3.fromRGB(46, 62, 50) elseif r < 0.16 then c = Color3.fromRGB(78, 52, 44) end
	return c
end

-- ===== luzes =====
local function tagLuz(inst, estado, grupo)
	CS:AddTag(inst, "Luz")
	inst:SetAttribute("Estado", estado)
	inst:SetAttribute("Grupo", grupo)
end

local function aplicaLuz(part, estado)
	local on = estado ~= "apagada"
	local vela = part:FindFirstChildOfClass("Decal")
	if vela then
		-- janela: vidro escuro com brilho de vela (degradê quente no centro, escuro nas bordas)
		vela.Transparency = on and 0.4 or 1
		part.Material = Mat.Glass
		part.Color = C.dark
	else
		part.Material = on and Mat.Neon or Mat.Glass
		part.Color = on and C.warm or C.dark
	end
	local l = part:FindFirstChildOfClass("PointLight")
	if l then l.Enabled = on end
end

local function luzPonto(parent, range, brilho, sombras)
	local l = Instance.new("PointLight")
	l.Color = C.warm
	l.Range = range
	l.Brightness = brilho
	l.Shadows = sombras == true
	l.Parent = parent
	return l
end

-- ===== janela (cf: centro da janela, +Z local para fora) =====
local function janela(parent, cf, estado, grupo, esc, luz, rng, venezianas)
	local s = esc or 1
	local W, H = 3.2 * s, 4.4 * s
	P(parent, "Moldura", Vector3.new(W + 1.1, H + 1.1, 0.5), cf * CFrame.new(0, 0, 0.1), C.woodDark, Mat.Wood, false)
	local pane = P(parent, "Vidro", Vector3.new(W, H, 0.2), cf * CFrame.new(0, 0, 0.32), C.dark, Mat.Glass, false, false)
	pane.Reflectance = 0.25
	local vela = Instance.new("Decal")
	vela.Name = "Vela"
	vela.Texture = "rbxassetid://124780722048553"
	vela.Face = Enum.NormalId.Back
	vela.Color3 = Color3.fromRGB(255, 255, 255)
	vela.Parent = pane
	P(parent, "TravessaV", Vector3.new(0.22, H, 0.2), cf * CFrame.new(0, 0, 0.45), C.woodDark, Mat.Wood, false, false)
	P(parent, "TravessaH", Vector3.new(W, 0.22, 0.2), cf * CFrame.new(0, 0.3 * s, 0.45), C.woodDark, Mat.Wood, false, false)
	P(parent, "Peitoril", Vector3.new(W + 1.8, 0.55, 1.2), cf * CFrame.new(0, -(H / 2 + 0.7), 0.55), C.stoneLight, Mat.Cobblestone, false)
	P(parent, "Verga", Vector3.new(W + 1.6, 0.7, 0.8), cf * CFrame.new(0, H / 2 + 0.75, 0.45), C.woodLight, Mat.Wood, false)
	if venezianas then
		for _, sx in ipairs({ -1, 1 }) do
			local fechada = rng:NextNumber() < 0.18
			local x = fechada and sx * (W / 4) or sx * (W / 2 + 0.2 + W / 4)
			local tilt = fechada and 0 or sx * rng:NextNumber(-0.15, 0.1)
			P(parent, "Veneziana", Vector3.new(W / 2, H + 0.4, 0.28), cf * CFrame.new(x, 0, 0.55) * CFrame.Angles(0, tilt, 0), Color3.fromRGB(52, 66, 56), Mat.WoodPlanks, false)
		end
	end
	if luz then luzPonto(pane, 13, 0.3, false) end
	tagLuz(pane, estado, grupo)
	aplicaLuz(pane, estado)
	return pane
end

-- ===== face com enxaimel (cf: centro da face, +Z local para fora) =====
local function faceEnxaimel(parent, cf, largura, altura, estado, grupo, luzIdx, rng, plaster, venez, janelasMax)
	local n = math.max(3, math.floor(largura / 4.6 + 0.5))
	local cel = largura / n
	P(parent, "VigaSup", Vector3.new(largura + 0.4, 1.0, 0.8), cf * CFrame.new(0, altura / 2 - 0.5, 0.3), C.wood, Mat.Wood, false)
	P(parent, "VigaInf", Vector3.new(largura + 0.4, 1.0, 0.8), cf * CFrame.new(0, -altura / 2 + 0.5, 0.3), C.wood, Mat.Wood, false)
	for i = 0, n do
		P(parent, "Poste", Vector3.new(0.9, altura, 0.7), cf * CFrame.new(-largura / 2 + i * cel, 0, 0.28), C.wood, Mat.Wood, false)
	end
	local janelas = 0
	for i = 1, n do
		local x = -largura / 2 + (i - 0.5) * cel
		local janelaAqui = (i % 2 == 1) and janelas < (janelasMax or 99)
		if janelaAqui then
			janelas += 1
			janela(parent, cf * CFrame.new(x, -0.2, 0), estado, grupo, 1, luzIdx and janelas == luzIdx, rng, venez)
		else
			local len = math.sqrt(cel * cel + altura * altura) * 0.9
			local ang = math.atan2(cel, altura) * ((i % 4 == 0) and 1 or -1)
			P(parent, "Escora", Vector3.new(0.7, len, 0.55), cf * CFrame.new(x, 0, 0.24) * CFrame.Angles(0, 0, ang), C.wood, Mat.Wood, false)
		end
	end
	-- manchas e envelhecimento do reboco (desativado: laço de zero iterações)
	for _ = 1, 0 do
		local px = (rng:NextNumber() - 0.5) * (largura - 4)
		local py = (rng:NextNumber() - 0.5) * (altura - 2)
		P(parent, "Mancha", Vector3.new(rng:NextNumber(2, 5), rng:NextNumber(1.5, 4), 0.1), cf * CFrame.new(px, py, 0.05), plaster:Lerp(Color3.new(0, 0, 0), rng:NextNumber(0.15, 0.35)), Mat.Plaster, false, false)
	end
end

-- placa pendurada (não usada na versão final: as placas foram removidas)
local function placa(parent, cf, texto)
	P(parent, "BracoPlaca", Vector3.new(0.5, 0.5, 5.2), cf * CFrame.new(0, 0, -2.6), C.metal, Mat.Metal, false)
	P(parent, "EscoraPlaca", Vector3.new(0.4, 0.4, 3.6), cf * CFrame.new(0, -1.3, -1.8) * CFrame.Angles(math.rad(-40), 0, 0), C.metal, Mat.Metal, false)
	for _, dx in ipairs({ -1.3, 1.3 }) do
		P(parent, "CorrentePlaca", Vector3.new(0.12, 1.2, 0.12), cf * CFrame.new(dx, -0.6, -4.6), C.metal, Mat.Metal, false, false)
	end
	local board = P(parent, "Placa", Vector3.new(3.8, 2.6, 0.35), cf * CFrame.new(0, -2.1, -4.6) * CFrame.Angles(0, math.pi / 2, 0), C.woodLight, Mat.WoodPlanks, false)
	for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local sg = Instance.new("SurfaceGui")
		sg.Face = face
		sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		sg.PixelsPerStud = 60
		sg.LightInfluence = 1
		sg.Parent = board
		local tl = Instance.new("TextLabel")
		tl.Size = UDim2.fromScale(1, 1)
		tl.BackgroundTransparency = 1
		tl.Text = texto
		tl.TextScaled = true
		tl.Font = Enum.Font.Antique
		tl.TextColor3 = Color3.fromRGB(214, 184, 120)
		tl.Parent = sg
	end
end
```

## Pontos de atenção
- `P` cria peças ancoradas, com `CanQuery` igual a `CanCollide` e `CastShadow` por padrão igual a `CanCollide`; detalhes pequenos passam `collide = false` e `shadow = false`.
- `Cyl` cria um cilindro com o eixo vertical (a peça é girada 90 graus em Z e o tamanho X é a altura).
- `faceEnxaimel` usa `+Z local` como normal para fora; todas as faces são convertidas para essa convenção por rotações em Y.

## Relacionados
- [[Módulo ConstrutorVilaGrande - Visão geral e API]]
- [[Casa - Andares, balanço e enxaimel]]
