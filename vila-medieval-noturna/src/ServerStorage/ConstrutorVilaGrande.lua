-- ConstrutorVilaGrande: versão em grande escala da vila medieval (casas enxaimel detalhadas,
-- postes altos, fonte gigante com água de terreno, piso de pedras individuais, poças e pedregulhos).
-- Usado em modo Edit via require(); o resultado fica salvo como Parts no Workspace.
--
-- Versão consolidada do chat: as definições antigas de M.praca, M.pedras, M.detalhes e M.fonte,
-- que eram sobrescritas mais abaixo no próprio arquivo, foram removidas. O comportamento é o mesmo.

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

-- ===== casa =====
-- cf: centro da casa no nível do chão; frente = -Z local.
-- o: {w, d, andares, plaster, gableFront, estado, grupo, name, seed, placa}
function M.casa(parent, cf, o)
	local rng = Random.new(o.seed or 1)
	local w, d, andares = o.w, o.d, o.andares
	local m = Instance.new("Model")
	m.Name = o.name or "Casa"
	local hb, fh, jet = 9, 8.5, 2.4
	local plaster = o.plaster or M.plasters[1]
	local estado, grupo = o.estado or "apagada", o.grupo or m.Name
	local fz = -(d / 2)
	local venez = true

	-- base de pedra com soco, faixa e cantoneiras
	P(m, "Base", Vector3.new(w, hb + 1, d), cf * CFrame.new(0, (hb - 1) / 2, 0), C.stone, Mat.Cobblestone)
	P(m, "Soco", Vector3.new(w + 1.2, 1.6, d + 1.2), cf * CFrame.new(0, 0.8, 0), C.stoneDark, Mat.Cobblestone)
	P(m, "BaseFaixa", Vector3.new(w + 1.2, 0.9, d + 1.2), cf * CFrame.new(0, hb - 0.2, 0), C.stoneLight, Mat.Cobblestone)
	for _, sx in ipairs({ -1, 1 }) do
		for _, sz in ipairs({ -1, 1 }) do
			for i = 0, 4 do
				local y = 2.4 + i * 1.5
				if i % 2 == 0 then
					P(m, "Cantoneira", Vector3.new(2.8, 1.35, 0.7), cf * CFrame.new(sx * (w / 2 - 1.4), y, sz * (d / 2 + 0.3)), C.stoneLight, Mat.Cobblestone, false)
				else
					P(m, "Cantoneira", Vector3.new(0.7, 1.35, 2.8), cf * CFrame.new(sx * (w / 2 + 0.3), y, sz * (d / 2 - 1.4)), C.stoneLight, Mat.Cobblestone, false)
				end
			end
		end
	end

	-- porta grande com ferragens, batentes e degraus
	P(m, "BatenteE", Vector3.new(1.0, 8.6, 1.3), cf * CFrame.new(-3.6, 4.7, fz - 0.45), C.stoneLight, Mat.Cobblestone, false)
	P(m, "BatenteD", Vector3.new(1.0, 8.6, 1.3), cf * CFrame.new(3.6, 4.7, fz - 0.45), C.stoneLight, Mat.Cobblestone, false)
	P(m, "Verga", Vector3.new(8.2, 1.3, 1.5), cf * CFrame.new(0, 9.2, fz - 0.5), C.stoneLight, Mat.Cobblestone, false)
	P(m, "Fecho", Vector3.new(1.4, 1.9, 1.7), cf * CFrame.new(0, 9.1, fz - 0.55), C.stone, Mat.Cobblestone, false)
	for _, sx in ipairs({ -1, 1 }) do
		local lx = sx * 1.4
		P(m, "Porta", Vector3.new(2.75, 8.0, 0.5), cf * CFrame.new(lx, 4.5, fz - 0.15), Color3.fromRGB(46, 32, 22), Mat.WoodPlanks, false)
		for _, y in ipairs({ 1.6, 4.5, 7.2 }) do
			P(m, "Ferragem", Vector3.new(2.6, 0.4, 0.15), cf * CFrame.new(lx, y, fz - 0.45), C.metal, Mat.Metal, false, false)
		end
		Cyl(m, "Argola", 0.3, 0.12, (cf * CFrame.new(sx * 0.6, 4.3, fz - 0.55)).Position, C.metal, Mat.Metal, false, false)
	end
	for i = 0, 2 do
		P(m, "Degrau", Vector3.new(9.5 - i * 0.8, 0.55 * (3 - i) + 0.3, 2.2), cf * CFrame.new(0, (0.55 * (3 - i) + 0.3) / 2, fz - 1.1 - i * 2.0), C.stoneDark, Mat.Cobblestone)
	end
	-- lampiãozinho de parede ao lado da porta
	if estado ~= "apagada" then
		local lant = P(m, "LanternaPorta", Vector3.new(1.0, 1.5, 1.0), cf * CFrame.new(-6.6, 6.8, fz - 0.9), C.dark, Mat.Glass, false, false)
		luzPonto(lant, 22, 0.8, false)
		tagLuz(lant, estado, grupo)
		aplicaLuz(lant, estado)
		P(m, "SuporteLanterna", Vector3.new(0.3, 0.3, 1.2), cf * CFrame.new(-6.6, 7.8, fz - 0.5), C.metal, Mat.Metal, false, false)
	end
	-- janelas do térreo, com grades
	for k, x in ipairs({ -w * 0.3, w * 0.3 }) do
		local cw = cf * CFrame.new(x, 5.4, fz - 0.02) * CFrame.Angles(0, math.pi, 0)
		janela(m, cw, estado, grupo, 0.8, k == 1, rng, false)
		for b = -2, 2 do
			P(m, "Grade", Vector3.new(0.16, 3.9, 0.16), cw * CFrame.new(b * 0.55, 0, 0.55), C.metal, Mat.Metal, false, false)
		end
	end

	-- andares superiores com balanço na frente
	local ww, dd = w + 0.6, d + jet
	local yTop = hb
	for f = 1, andares do
		local y0 = hb + (f - 1) * fh
		local yc = y0 + fh / 2
		P(m, "Andar" .. f, Vector3.new(ww, fh, dd), cf * CFrame.new(0, yc, -jet / 2), plaster, Mat.SmoothPlastic)
		faceEnxaimel(m, cf * CFrame.new(0, yc, -(d / 2 + jet)) * CFrame.Angles(0, math.pi, 0), ww, fh, estado, grupo, 2, rng, plaster, venez, 99)
		faceEnxaimel(m, cf * CFrame.new(0, yc, d / 2), ww, fh, estado, grupo, nil, rng, plaster, false, 2)
		faceEnxaimel(m, cf * CFrame.new(ww / 2, yc, -jet / 2) * CFrame.Angles(0, math.pi / 2, 0), dd, fh, estado, grupo, nil, rng, plaster, false, 1)
		faceEnxaimel(m, cf * CFrame.new(-ww / 2, yc, -jet / 2) * CFrame.Angles(0, -math.pi / 2, 0), dd, fh, estado, grupo, nil, rng, plaster, false, 1)
		yTop = y0 + fh
	end
	-- mãos-francesas sob o balanço
	P(m, "ViguetaBalanco", Vector3.new(ww + 0.6, 0.9, jet + 0.4), cf * CFrame.new(0, hb + 0.45, -(d / 2 + jet / 2) + 0.1), C.woodDark, Mat.Wood, false)
	local nc = math.max(3, math.floor(ww / 4.2))
	for i = 0, nc do
		local x = -ww / 2 + 0.6 + i * ((ww - 1.2) / nc)
		P(m, "Mao", Vector3.new(0.8, 0.8, jet * 1.45), cf * CFrame.new(x, hb - 1.0, -(d / 2 + jet / 2)) * CFrame.Angles(math.pi / 4, 0, 0), C.wood, Mat.Wood, false)
	end

	-- ===== telhado =====
	local rot = o.gableFront and CFrame.Angles(0, math.pi / 2, 0) or CFrame.new()
	local roofCF = cf * CFrame.new(0, yTop, -jet / 2) * rot
	local RL = o.gableFront and dd or ww
	local SP = o.gableFront and ww or dd
	local half = SP / 2
	local rise = SP * 0.56
	local a = math.atan2(rise, half)
	local sinA, cosA = math.sin(a), math.cos(a)
	local Ls = math.sqrt(half * half + rise * rise)
	local over = 1.8
	local len = Ls + over
	local RW = RL + 3.6
	local ridge = Vector3.new(0, rise, 0)

	for _, s in ipairs({ -1, 1 }) do
		local dirDown = Vector3.new(0, -sinA, s * cosA)
		local n = Vector3.new(0, cosA, s * sinA)
		local function at(t, off) return ridge + dirDown * t + n * (off or 0) end

		P(m, "Subtelhado", Vector3.new(RW, 0.6, len), roofCF * CFrame.fromMatrix(at(len / 2, -0.3), Vector3.xAxis, n), C.woodDark, Mat.Wood)
		-- fiadas de telhas, alternadas para criar sombras entre elas
		local cd, step = 1.5, 1.15
		local c = 0
		while true do
			local t = len - cd / 2 - c * step
			if t < cd / 2 then break end
			local alt = c % 2
			local x = -RW / 2
			while x < RW / 2 - 0.3 do
				local sw = math.min(rng:NextNumber(4.5, 8.5), RW / 2 - x)
				local pos = at(t, 0.25 + alt * 0.2)
				pos = Vector3.new(x + sw / 2, pos.Y, pos.Z)
				P(m, "Telha", Vector3.new(sw - 0.1, 0.42, cd), roofCF * CFrame.fromMatrix(pos, Vector3.xAxis, n), slateColor(rng), Mat.Slate, false, true)
				x += sw
			end
			c += 1
		end
		-- beiral e caibros
		P(m, "Beiral", Vector3.new(RW, 0.9, 0.5), roofCF * CFrame.fromMatrix(at(len + 0.1, 0.1), Vector3.xAxis, n), C.woodDark, Mat.Wood, false)
		for x = -RL / 2 + 1.2, RL / 2 - 1.0, 2.8 do
			local pos = at(len - 0.6, -0.7)
			P(m, "Caibro", Vector3.new(0.5, 0.6, over + 0.8), roofCF * CFrame.fromMatrix(Vector3.new(x, pos.Y, pos.Z), Vector3.xAxis, n), C.wood, Mat.Wood, false, false)
		end
		-- tabeiras nas empenas
		for _, sx in ipairs({ -1, 1 }) do
			local pos = at(len / 2 + 0.1, 0.55)
			P(m, "Tabeira", Vector3.new(0.7, 1.2, len + 0.5), roofCF * CFrame.fromMatrix(Vector3.new(sx * (RW / 2 - 0.2), pos.Y, pos.Z), Vector3.xAxis, n), C.woodDark, Mat.Wood, false)
		end
		-- vigas diagonais na empena
		for _, sx in ipairs({ -1, 1 }) do
			P(m, "VigaEmpena", Vector3.new(0.7, 0.9, Ls * 0.82), roofCF * CFrame.new(sx * (RL / 2 + 0.3), rise / 2 - 1.5, s * half / 2) * CFrame.Angles(s * a, 0, 0), C.wood, Mat.Wood, false)
		end
	end
	-- cumeeira com telhas de remate
	P(m, "Cumeeira", Vector3.new(RW + 0.2, 1.0, 1.9), roofCF * CFrame.new(0, rise + 0.35, 0), Color3.fromRGB(34, 36, 42), Mat.Slate)
	for x = -RL / 2, RL / 2, 2.4 do
		P(m, "RemateCumeeira", Vector3.new(1.7, 1.5, 2.2), roofCF * CFrame.new(x, rise + 0.7, 0), Color3.fromRGB(30, 32, 38), Mat.Slate, false)
	end
	-- empenas (triângulos de parede com enxaimel)
	for _, sx in ipairs({ -1, 1 }) do
		local x = sx * (RL / 2 - 0.4)
		Wedge(m, "EmpenaE", Vector3.new(0.8, rise, half), roofCF * CFrame.new(x, rise / 2, -half / 2), plaster, Mat.SmoothPlastic)
		Wedge(m, "EmpenaD", Vector3.new(0.8, rise, half), roofCF * CFrame.new(x, rise / 2, half / 2) * CFrame.Angles(0, math.pi, 0), plaster, Mat.SmoothPlastic)
		P(m, "PosteEmpena", Vector3.new(0.8, rise, 0.9), roofCF * CFrame.new(sx * (RL / 2 + 0.1), rise / 2, 0), C.wood, Mat.Wood, false)
		P(m, "VigaBaseEmpena", Vector3.new(0.8, 0.9, SP), roofCF * CFrame.new(sx * (RL / 2 + 0.1), 0.45, 0), C.wood, Mat.Wood, false)
	end
	if o.gableFront then
		janela(m, roofCF * CFrame.new(RL / 2 + 0.5, rise * 0.34, 0) * CFrame.Angles(0, math.pi / 2, 0), estado, grupo, 0.9, true, rng, true)
	end

	-- trapeiras (janelas no telhado) na face da frente
	if not o.gableFront and RL > 28 then
		for _, dx in ipairs({ -RL * 0.22, RL * 0.22 }) do
			local t = Ls * 0.52
			local p0 = ridge + Vector3.new(0, -sinA, -cosA) * t
			local zf = p0.Z - 1.3
			local yb = p0.Y - 2.4
			P(m, "Trapeira", Vector3.new(5.6, 5.8, 4.8), roofCF * CFrame.new(dx, yb + 2.9, zf + 2.4), plaster, Mat.SmoothPlastic)
			P(m, "TrapeiraTeto", Vector3.new(6.6, 0.6, 6.0), roofCF * CFrame.new(dx, yb + 6.1, zf + 2.2), slateColor(rng), Mat.Slate)
			P(m, "TrapeiraViga", Vector3.new(6.0, 0.7, 0.7), roofCF * CFrame.new(dx, yb + 5.7, zf - 0.2), C.wood, Mat.Wood, false)
			janela(m, roofCF * CFrame.new(dx, yb + 2.9, zf) * CFrame.Angles(0, math.pi, 0), estado, grupo, 1, false, rng, true)
		end
	end

	-- chaminé de pedra
	local chx = -(RL / 2 - 2.6)
	local chH = rise + 7.5
	P(m, "Chamine", Vector3.new(3.6, chH, 3.6), roofCF * CFrame.new(chx, (rise + 3.5 - 4) / 2 + 0.5, 0), C.stoneDark, Mat.Cobblestone)
	for _, y in ipairs({ rise * 0.5, rise + 1.5 }) do
		P(m, "FaixaChamine", Vector3.new(4.2, 0.5, 4.2), roofCF * CFrame.new(chx, y, 0), C.stoneLight, Mat.Cobblestone, false)
	end
	local topY = rise + 3.5
	local cap = P(m, "TopoChamine", Vector3.new(4.6, 0.7, 4.6), roofCF * CFrame.new(chx, topY, 0), C.stone, Mat.Cobblestone, false)
	Cyl(m, "Cano", 0.8, 1.2, (roofCF * CFrame.new(chx - 0.8, topY + 0.9, 0)).Position, C.stoneDark, Mat.Cobblestone, false, false)
	Cyl(m, "Cano", 0.8, 1.2, (roofCF * CFrame.new(chx + 0.8, topY + 0.9, 0)).Position, C.stoneDark, Mat.Cobblestone, false, false)
	if estado ~= "apagada" then
		local e = Instance.new("ParticleEmitter")
		e.Name = "Fumaca"
		e.Texture = "rbxasset://textures/particles/smoke_main.dds"
		e.Rate = 4
		e.Lifetime = NumberRange.new(7, 11)
		e.Speed = NumberRange.new(3, 4)
		e.SpreadAngle = Vector2.new(10, 10)
		e.Acceleration = Vector3.new(1.4, 0.8, 0.5)
		e.Color = ColorSequence.new(Color3.fromRGB(112, 114, 126))
		e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.6), NumberSequenceKeypoint.new(1, 7) })
		e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 1) })
		e.LightInfluence = 0.4
		e.Parent = cap
	end

	-- placa pendurada (não usar)
	if o.placa then
		placa(m, cf * CFrame.new(w * 0.33, hb + 5.5, -(d / 2 + jet + 0.6)) * CFrame.Angles(0, math.pi / 2, 0) * CFrame.Angles(0, -math.pi / 2, 0), o.placa)
	end
	-- hera e musgo nas pedras e paredes (vila antiga)
	for _ = 1, 7 do
		local lado = rng:NextInteger(1, 4)
		local sx, sy = rng:NextNumber(2.4, 5.2), rng:NextNumber(3, 7)
		local col = Color3.fromRGB(rng:NextInteger(30, 46), rng:NextInteger(52, 74), rng:NextInteger(28, 42))
		local yMax = (lado >= 3) and (hb + fh * andares - 4) or (hb - 2)
		local y = rng:NextNumber(sy / 2 + 1.2, math.max(sy / 2 + 2, yMax))
		local fcf
		if lado == 1 then fcf = cf * CFrame.new(rng:NextNumber(-w / 2 + 3, w / 2 - 3), y, -(d / 2) - 0.12) * CFrame.Angles(0, math.pi, 0)
		elseif lado == 2 then fcf = cf * CFrame.new(rng:NextNumber(-w / 2 + 3, w / 2 - 3), y, d / 2 + 0.12)
		elseif lado == 3 then fcf = cf * CFrame.new(w / 2 + ((y > hb) and 0.85 or 0.12), y, rng:NextNumber(-d / 2 + 3, d / 2 - 3)) * CFrame.Angles(0, math.pi / 2, 0)
		else fcf = cf * CFrame.new(-w / 2 - ((y > hb) and 0.85 or 0.12), y, rng:NextNumber(-d / 2 + 3, d / 2 - 3)) * CFrame.Angles(0, -math.pi / 2, 0) end
		P(m, "Hera", Vector3.new(sx, sy, 0.12), fcf, col, Mat.Grass, false, false)
		P(m, "HeraFolha", Vector3.new(sx * 0.6, sy * 0.5, 0.2), fcf * CFrame.new(rng:NextNumber(-1, 1), rng:NextNumber(-1, 1), 0.06), col:Lerp(Color3.new(0, 0, 0), 0.25), Mat.Grass, false, false)
	end
	m.Parent = parent
	return m
end

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

-- banco: não deve mais ser usado (foi removido da cena por parecer "cadeira espalhada")
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

-- ===== praça compacta (raio 58), piso estilo cobblestone e adereços de vila antiga =====
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

-- ===== fonte gigante =====
local function emissor(part, nivel, taxa, vel, spread, vida, tam)
	local e = Instance.new("ParticleEmitter")
	e.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	e.Rate = taxa
	e.Lifetime = NumberRange.new(vida * 0.9, vida * 1.1)
	e.Speed = NumberRange.new(vel * 0.92, vel * 1.08)
	e.SpreadAngle = Vector2.new(spread, spread)
	e.Acceleration = Vector3.new(0, -30, 0)
	e.Color = ColorSequence.new(Color3.fromRGB(205, 228, 255))
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, tam), NumberSequenceKeypoint.new(1, tam * 0.6) })
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.8, 0.45), NumberSequenceKeypoint.new(1, 1) })
	e.LightEmission = 0.5
	e.LightInfluence = 0.2
	e:SetAttribute("Nivel", nivel)
	e.Parent = part
	return e
end

-- Script de falhas da fonte: copiado para src/Fonte/FonteFalha.lua
local FONTE_SCRIPT = [==[
local fonte = script.Parent
local niveis = {}
for _, d in ipairs(fonte:GetDescendants()) do
	if d:IsA("ParticleEmitter") then
		local n = d:GetAttribute("Nivel")
		if n then
			niveis[n] = niveis[n] or {}
			table.insert(niveis[n], { e = d, base = d.Rate })
		end
	end
end
local rng = Random.new()

local function pressao(list, f)
	for _, it in ipairs(list) do it.e.Rate = math.max(it.base * f, 0.5) end
end
local function liga(list, on)
	for _, it in ipairs(list) do it.e.Enabled = on end
end

-- cada nível (0 = jato central, 1..3 = bicas das bacias) falha por conta própria
local function ciclo(n, minOn, maxOn)
	local list = niveis[n]
	if not list then return end
	task.spawn(function()
		task.wait(rng:NextNumber(0, 6))
		while true do
			pressao(list, 1); liga(list, true)
			task.wait(rng:NextNumber(minOn, maxOn))
			local tipo = rng:NextInteger(1, 3)
			if tipo == 1 then
				for _ = 1, rng:NextInteger(4, 8) do
					pressao(list, rng:NextNumber(0.3, 1)); liga(list, true)
					task.wait(rng:NextNumber(0.08, 0.35))
					liga(list, false)
					task.wait(rng:NextNumber(0.1, 0.55))
				end
				task.wait(rng:NextNumber(2, 6))
			elseif tipo == 2 then
				for i = 10, 3, -1 do pressao(list, i / 10); task.wait(0.2) end
				task.wait(rng:NextNumber(3, 7))
			else
				for i = 10, 1, -1 do pressao(list, i / 10); task.wait(0.18) end
				liga(list, false)
				local pingo = list[rng:NextInteger(1, #list)]
				pingo.e.Rate = 4; pingo.e.Enabled = true
				task.wait(rng:NextNumber(3, 6))
				pingo.e.Enabled = false
			end
			liga(list, true)
			for i = 1, 10 do
				pressao(list, i / 10)
				if rng:NextNumber() < 0.2 then liga(list, false); task.wait(0.12); liga(list, true) end
				task.wait(0.12)
			end
		end
	end)
end
ciclo(0, 6, 14)
ciclo(3, 10, 22)
ciclo(2, 12, 26)
ciclo(1, 14, 30)
]==]

-- fonte final: pedestal central maciço, sem câmara habitável; pedra limpa e escura
function M.fonte(parent, pos)
	M.variant[Mat.Cobblestone] = nil  -- pedra lisa e limpa, sem as rachaduras do material gerado
	local PA, PB, PL, PD = Color3.fromRGB(66, 66, 70), Color3.fromRGB(57, 57, 61), Color3.fromRGB(80, 80, 86), Color3.fromRGB(46, 46, 50)
	local m = Instance.new("Model")
	m.Name = "Fonte"
	local b = pos.Y
	local x, z = pos.X, pos.Z
	local function at(y) return Vector3.new(x, y, z) end
	local T = workspace.Terrain

	local function anel(nome, n, raio, y, h, grossura, cor1, cor2, colide)
		local tang = 2 * math.pi * raio / n * 1.04
		for k = 0, n - 1 do
			local ang = k * 2 * math.pi / n
			local p = Vector3.new(x + math.cos(ang) * raio, y, z + math.sin(ang) * raio)
			P(m, nome, Vector3.new(tang, h, grossura), CFrame.lookAt(p, at(y)), (k % 2 == 0) and cor1 or cor2, Mat.Cobblestone, colide)
		end
	end
	local function agua(raio, y0, y1)
		T:FillCylinder(CFrame.new(x, (y0 + y1) / 2, z), y1 - y0, raio, Enum.Material.Water)
	end
	local function bicas(nivel, n, raio, y, vel, vida, taxa, tam, off)
		for k = 0, n - 1 do
			local ang = off + k * 2 * math.pi / n
			local dir = Vector3.new(math.cos(ang), 0, math.sin(ang))
			local p = at(y) + dir * raio
			P(m, "Gargula", Vector3.new(1.1, 1.1, 2.4), CFrame.lookAt(p + dir * 0.9, p + dir * 3), PD, Mat.Cobblestone, false)
			P(m, "Focinho", Vector3.new(0.8, 0.8, 0.5), CFrame.lookAt(p + dir * 2.2, p + dir * 4), PB, Mat.Cobblestone, false, false)
			local bica = P(m, "Bica", Vector3.new(0.3, 0.3, 0.3), CFrame.lookAt(p + dir * 2.6, p + dir * 5), PA, Mat.Plastic, false, false)
			bica.Transparency = 1
			local e = emissor(bica, nivel, taxa, vel, 3.5, vida, tam)
			e.EmissionDirection = Enum.NormalId.Front
		end
	end
	local function respingos(nivel, n, raio, y, taxa)
		for k = 0, n - 1 do
			local ang = k * 2 * math.pi / n
			local p = P(m, "Respingo", Vector3.new(0.3, 0.3, 0.3), CFrame.new(x + math.cos(ang) * raio, y, z + math.sin(ang) * raio), PA, Mat.Plastic, false, false)
			p.Transparency = 1
			local e = emissor(p, nivel, taxa, 5, 80, 0.55, 0.7)
			e.Acceleration = Vector3.new(0, -26, 0)
		end
	end

	-- bacia principal fechada (sem abertura), degrau externo e pilastras
	Cyl(m, "FundoBacia", 27.6, 0.6, at(b + 0.3), PD, Mat.Cobblestone)
	anel("ParedeBacia", 56, 26.2, b + 3, 6, 3.0, PA, PB, true)
	anel("CapaBacia", 56, 26.2, b + 6.4, 0.9, 4.3, PL, PL, false)
	anel("DegrauBacia", 64, 30.6, b + 0.8, 1.6, 2.8, PD, PB, true)
	for k = 0, 7 do
		local ang = k * math.pi / 4 + math.pi / 8
		local p = Vector3.new(x + math.cos(ang) * 27.6, b + 4.2, z + math.sin(ang) * 27.6)
		P(m, "Pilastra", Vector3.new(2.6, 8.4, 2.6), CFrame.lookAt(p, at(b + 4.2)), PL, Mat.Cobblestone)
		local orb = P(m, "PilastraTopo", Vector3.new(2.2, 2.2, 2.2), CFrame.new(p + Vector3.new(0, 5.2, 0)), PA, Mat.Cobblestone, false)
		orb.Shape = Enum.PartType.Ball
	end
	agua(24.8, b + 0.6, b + 4.2)

	-- pedestal central maciço (nada habitável dentro)
	Cyl(m, "PedestalCentral", 10.5, 16, at(b + 8), PA, Mat.Cobblestone)
	Cyl(m, "ColarPedestalBase", 11.5, 1.4, at(b + 1.1), PL, Mat.Cobblestone, false)
	Cyl(m, "ColarPedestalTopo", 11.3, 1.2, at(b + 15.4), PL, Mat.Cobblestone, false)
	anel("PilastraPedestal", 14, 10.9, b + 8.6, 14, 1.2, PB, PD, false)
	Cyl(m, "PratoMedio", 17, 1.2, at(b + 16.6), PA, Mat.Cobblestone)

	-- nível 1
	anel("BordaMedia", 40, 16.2, b + 18.7, 3, 1.7, PA, PL, false)
	agua(14.4, b + 17.2, b + 19.2)
	Cyl(m, "ColarColuna1", 6.2, 0.8, at(b + 17.6), PL, Mat.Cobblestone, false)
	Cyl(m, "Coluna1", 4.6, 11.8, at(b + 23.1), PL, Mat.Cobblestone)
	Cyl(m, "ColarColuna1b", 5.6, 0.8, at(b + 28.6), PL, Mat.Cobblestone, false)
	-- nível 2
	Cyl(m, "BaciaN2", 11, 1.2, at(b + 29.6), PA, Mat.Cobblestone)
	anel("BordaN2", 28, 10.6, b + 31.5, 2.6, 1.5, PA, PL, false)
	agua(9.5, b + 30.2, b + 31.8)
	Cyl(m, "Coluna2", 2.6, 9.8, at(b + 35.1), PL, Mat.Cobblestone)
	Cyl(m, "ColarColuna2", 3.6, 0.8, at(b + 39.6), PL, Mat.Cobblestone, false)
	-- nível 3
	Cyl(m, "BaciaN3", 6.5, 1.0, at(b + 40.5), PA, Mat.Cobblestone)
	anel("BordaN3", 20, 6.2, b + 42.1, 2.2, 1.1, PA, PL, false)
	agua(5.5, b + 41.0, b + 42.3)
	Cyl(m, "Coluna3", 1.3, 6, at(b + 44), PL, Mat.Cobblestone)
	Cyl(m, "Pinaculo", 0.9, 2, at(b + 47.8), PA, Mat.Cobblestone, false)
	local orb = P(m, "Esfera", Vector3.new(3.4, 3.4, 3.4), CFrame.new(at(b + 49.4)), PL, Mat.Cobblestone, false)
	orb.Shape = Enum.PartType.Ball

	-- jato central e bicas
	local jato = P(m, "Jato", Vector3.new(0.3, 0.3, 0.3), CFrame.new(at(b + 51.4)), PA, Mat.Plastic, false, false)
	jato.Transparency = 1
	emissor(jato, 0, 240, 30, 5, 2.3, 0.65)
	bicas(3, 4, 6.6, b + 42.9, 2.2, 0.9, 70, 0.5, math.pi / 4)
	bicas(2, 6, 11.0, b + 32.4, 2.6, 0.95, 80, 0.55, 0)
	bicas(1, 8, 16.5, b + 19.7, 4.8, 1.05, 110, 0.6, math.pi / 8)
	respingos(0, 3, 2.0, b + 42.4, 22)
	respingos(3, 4, 8.5, b + 31.9, 14)
	respingos(2, 6, 13.4, b + 19.3, 16)
	respingos(1, 12, 21.5, b + 4.4, 20)
	local nev = P(m, "Neblina", Vector3.new(0.3, 0.3, 0.3), CFrame.new(at(b + 5.5)), PA, Mat.Plastic, false, false)
	nev.Transparency = 1
	local ne = Instance.new("ParticleEmitter")
	ne.Texture = "rbxasset://textures/particles/smoke_main.dds"
	ne.Rate = 6
	ne.Lifetime = NumberRange.new(7, 10)
	ne.Speed = NumberRange.new(0.8, 1.6)
	ne.SpreadAngle = Vector2.new(180, 180)
	ne.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 12), NumberSequenceKeypoint.new(1, 26) })
	ne.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.94), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 1) })
	ne.Color = ColorSequence.new(Color3.fromRGB(150, 170, 210))
	ne.LightInfluence = 0.6
	ne:SetAttribute("Nivel", 1)
	ne.Parent = nev

	local s = Instance.new("Script")
	s.Name = "FonteFalha"
	s.Source = FONTE_SCRIPT
	s.Parent = m
	m.Parent = parent
	return m
end

return M
