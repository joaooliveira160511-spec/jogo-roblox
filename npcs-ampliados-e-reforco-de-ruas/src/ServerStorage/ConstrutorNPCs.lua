-- ConstrutorNPCs: cria os NPCs da vila a partir do rig R15 oficial do Roblox
-- (CreateHumanoidModelFromDescription), convertido para Motor6D, com cores por peca,
-- rosto desenhado, sujeira em Decals, cabelo, roupas e adercos feitos de pecas soldadas.
-- O comportamento (poses, patrulha, dialogo) fica no cliente: ver StarterPlayerScripts.NPCsVila.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.NPCVila.Assets)

local Mat = Enum.Material
local M = {}

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local function ang(x, y, z) return CFrame.Angles(math.rad(x or 0), math.rad(y or 0), math.rad(z or 0)) end
local CF = CFrame.new
local V3 = Vector3.new

local MADEIRA = rgb(86, 64, 44)
local MADEIRA_ESC = rgb(58, 44, 32)
local FERRO = rgb(52, 52, 56)
local PALHA = rgb(150, 124, 72)
local CORDA = rgb(150, 126, 86)
local COURO = rgb(84, 62, 44)

-- cria uma peca soldada a uma ancora, com o deslocamento cf no espaco da ancora
local function peca(m, ancora, nome, tam, cf, cor, mat, classe, forma)
	local p = Instance.new(classe or "Part")
	p.Name = nome
	p.Size = tam
	p.Color = cor
	p.Material = mat or Mat.Fabric
	if forma then p.Shape = forma end
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Massless = true
	p.CastShadow = false
	p.Anchored = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = m
	local w = Instance.new("Weld")
	w.Part0 = ancora
	w.Part1 = p
	w.C0 = cf
	w.Parent = p
	return p
end

-- cilindro com eixo vertical (Y da ancora)
local function cil(m, ancora, nome, alt, diam, cf, cor, mat)
	return peca(m, ancora, nome, V3(alt, diam, diam), cf * ang(0, 0, 90), cor, mat, "Part", Enum.PartType.Cylinder)
end

-- cilindro com eixo em X ou Z (eixo = "x" ou "z")
local function cilH(m, ancora, nome, comp, diam, eixo, cf, cor, mat)
	local r = eixo == "z" and ang(0, 90, 0) or CFrame.new()
	return peca(m, ancora, nome, V3(comp, diam, diam), cf * r, cor, mat, "Part", Enum.PartType.Cylinder)
end

local function bola(m, ancora, nome, tam, cf, cor, mat)
	return peca(m, ancora, nome, tam, cf, cor, mat, "Part", Enum.PartType.Ball)
end

local function decal(p, tex, face, transp)
	local d = Instance.new("Decal")
	d.Name = "Sujo"
	d.Texture = tex
	d.Face = face
	d.Transparency = transp or 0
	d.Parent = p
end

local CollectionService = game:GetService("CollectionService")
local CHAMA_COR = rgb(255, 112, 28)

-- chama acesa (bola neon). Com alcance, ganha PointLight e entra no sistema de luzes da vila (tag Luz,
-- animada no cliente por LuzesCliente); sem alcance e so um brilho decorativo.
local function chama(m, ancora, nome, cf, tam, alcance, brilho)
	local f = peca(m, ancora, nome, tam, cf, CHAMA_COR, Mat.Neon, "Part", Enum.PartType.Ball)
	if alcance then
		local l = Instance.new("PointLight")
		l.Color = rgb(255, 184, 108)
		l.Range = alcance
		l.Brightness = brilho
		l.Shadows = false
		l.Parent = f
		f:SetAttribute("Estado", "ligada")
		f:SetAttribute("Grupo", "npc_" .. m.Name .. "_" .. nome)
		CollectionService:AddTag(f, "Luz")
	end
	return f
end

-- ===================== rig =====================
local function criarRig(esc)
	local d = Instance.new("HumanoidDescription")
	d.HeightScale = esc.h or 1
	d.WidthScale = esc.w or 1
	d.DepthScale = esc.p or esc.w or 1
	d.HeadScale = esc.cab or 1
	d.BodyTypeScale = esc.tipo or 0
	d.ProportionScale = 0
	local m = Players:CreateHumanoidModelFromDescription(d, Enum.HumanoidRigType.R15)
	d:Destroy()

	-- AnimationConstraint -> Motor6D (rig classico, estavel com a raiz ancorada)
	for _, c in ipairs(m:GetDescendants()) do
		if c:IsA("AnimationConstraint") then
			local mo = Instance.new("Motor6D")
			mo.Name = c.Name
			mo.Part0, mo.Part1 = c.Part0, c.Part1
			mo.C0, mo.C1 = c.Attachment0.CFrame, c.Attachment1.CFrame
			local pai = c.Parent
			c:Destroy()
			mo.Parent = pai
		end
	end
	for _, c in ipairs(m:GetDescendants()) do
		if c:IsA("BallSocketConstraint") or c:IsA("NoCollisionConstraint") or c:IsA("FaceControls") then c:Destroy() end
	end
	for _, nome in ipairs({ "Animate", "Humanoid", "Body Colors" }) do
		local x = m:FindFirstChild(nome)
		if x then x:Destroy() end
	end
	m.PrimaryPart = m.HumanoidRootPart
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.Anchored = false
			if p:IsA("MeshPart") then p.TextureID = "" end
		end
	end
	m.HumanoidRootPart.Anchored = true
	m.HumanoidRootPart.Transparency = 1
	return m
end

local function pinta(m, nomes, cor, mat)
	for _, n in ipairs(nomes) do
		local p = m[n]
		p.Color = cor
		p.Material = mat or Mat.Fabric
		p.Reflectance = 0
	end
end

-- ===================== cabelo e chapeus =====================
local function cabelo(m, estilo, cor)
	local H = m.Head
	local s = H.Size
	local escuro = cor:Lerp(rgb(24, 18, 16), 0.22)
	local function h(nome, tam, cf, c, mat)
		return peca(m, H, nome, tam, cf, c or cor, mat or Mat.SmoothPlastic)
	end
	local function base()
		-- coroa redonda (cilindro), nuca, costeletas curtas e franja: sem o aspecto de capacete quadrado
		cil(m, H, "Topo", s.Y * 0.34, s.X * 1.1, CF(0, s.Y * 0.40, 0.02 * s.Z), cor, Mat.SmoothPlastic)
		h("Nuca", V3(s.X * 1.04, s.Y * 0.58, s.Z * 0.2), CF(0, s.Y * 0.14, s.Z * 0.5), escuro)
		for _, l in ipairs({ -1, 1 }) do
			h("Lado", V3(s.X * 0.12, s.Y * 0.42, s.Z * 0.6), CF(l * s.X * 0.45, s.Y * 0.26, s.Z * 0.2), escuro)
		end
		h("Franja1", V3(s.X * 0.3, s.Y * 0.1, s.Z * 0.1), CF(-s.X * 0.3, s.Y * 0.345, -s.Z * 0.5))
		h("Franja2", V3(s.X * 0.34, s.Y * 0.15, s.Z * 0.1), CF(0, s.Y * 0.33, -s.Z * 0.5))
		h("Franja3", V3(s.X * 0.3, s.Y * 0.09, s.Z * 0.1), CF(s.X * 0.3, s.Y * 0.355, -s.Z * 0.5))
	end
	if estilo == "curto" then
		base()
	elseif estilo == "longo" then
		base()
		h("Costas", V3(s.X * 1.0, s.Y * 1.5, s.Z * 0.22), CF(0, -s.Y * 0.25, s.Z * 0.56), escuro)
		for _, l in ipairs({ -1, 1 }) do
			h("Mecha", V3(s.X * 0.12, s.Y * 1.0, s.Z * 0.36), CF(l * s.X * 0.54, -s.Y * 0.1, s.Z * 0.16), escuro)
		end
	elseif estilo == "tranca" then
		base()
		for i = 1, 5 do
			h("Tranca" .. i, V3(s.X * 0.26, s.Y * 0.34, s.Z * 0.26), CF(s.X * 0.06 * ((i % 2 == 0) and 1 or -1), -s.Y * (0.15 + 0.3 * i), s.Z * 0.62), escuro)
		end
		h("Laco", V3(s.X * 0.34, s.Y * 0.14, s.Z * 0.3), CF(0, -s.Y * 1.7, s.Z * 0.62), rgb(110, 60, 48), Mat.Fabric)
	elseif estilo == "coque" then
		base()
		bola(m, H, "Coque", V3(s.X * 0.5, s.X * 0.5, s.X * 0.5), CF(0, s.Y * 0.62, s.Z * 0.26), cor, Mat.SmoothPlastic)
	elseif estilo == "calvo" then
		for _, l in ipairs({ -1, 1 }) do
			h("Lado", V3(s.X * 0.12, s.Y * 0.3, s.Z * 0.58), CF(l * s.X * 0.45, s.Y * 0.06, s.Z * 0.2), escuro)
		end
		h("Nuca", V3(s.X * 1.0, s.Y * 0.3, s.Z * 0.2), CF(0, s.Y * 0.04, s.Z * 0.5), escuro)
		h("Tufo", V3(s.X * 0.4, s.Y * 0.08, s.Z * 0.3), CF(0, s.Y * 0.52, -s.Z * 0.1))
	elseif estilo == "rebelde" then
		base()
		local rnd = Random.new(7)
		for i = 1, 5 do
			h("Tufo" .. i, V3(s.X * 0.2, s.Y * 0.28, s.Z * 0.2), CF(rnd:NextNumber(-0.4, 0.4) * s.X, s.Y * 0.6, rnd:NextNumber(-0.3, 0.4) * s.Z) * ang(rnd:NextNumber(-25, 25), rnd:NextNumber(0, 90), rnd:NextNumber(-25, 25)))
		end
	end
end

local function cobertura(m, tipo, cor)
	local H = m.Head
	local s = H.Size
	local function h(nome, tam, cf, c, mat)
		return peca(m, H, nome, tam, cf, c or cor, mat or Mat.Fabric)
	end
	if tipo == "lenco" then
		cil(m, H, "LencoTopo", s.Y * 0.38, s.X * 1.16, CF(0, s.Y * 0.40, 0.03 * s.Z), cor, Mat.Fabric)
		h("LencoCostas", V3(s.X * 1.1, s.Y * 0.85, s.Z * 0.24), CF(0, s.Y * 0.02, s.Z * 0.52))
		for _, l in ipairs({ -1, 1 }) do
			h("LencoLado", V3(s.X * 0.14, s.Y * 0.6, s.Z * 0.54), CF(l * s.X * 0.54, s.Y * 0.14, s.Z * 0.22))
		end
		h("LencoFaixa", V3(s.X * 1.1, s.Y * 0.1, s.Z * 0.1), CF(0, s.Y * 0.36, -s.Z * 0.54), cor:Lerp(rgb(20, 16, 14), 0.15))
		bola(m, H, "LencoNo", V3(s.X * 0.32, s.X * 0.32, s.X * 0.32), CF(0, s.Y * 0.28, s.Z * 0.68), cor, Mat.Fabric)
	elseif tipo == "capuz" then
		cil(m, H, "CapuzTopo", s.Y * 0.36, s.X * 1.24, CF(0, s.Y * 0.42, 0.03 * s.Z), cor, Mat.Fabric)
		h("CapuzCostas", V3(s.X * 1.2, s.Y * 1.25, s.Z * 0.26), CF(0, -s.Y * 0.18, s.Z * 0.56))
		for _, l in ipairs({ -1, 1 }) do
			h("CapuzLado", V3(s.X * 0.16, s.Y * 0.9, s.Z * 0.72), CF(l * s.X * 0.57, s.Y * 0.02, s.Z * 0.14))
		end
		h("CapuzAba", V3(s.X * 1.2, s.Y * 0.13, s.Z * 0.2), CF(0, s.Y * 0.4, -s.Z * 0.57))
	elseif tipo == "palha" then
		cil(m, H, "ChapeuAba", s.Y * 0.07, s.X * 2.05, CF(0, s.Y * 0.44, 0), cor, Mat.Fabric)
		cil(m, H, "ChapeuCopa", s.Y * 0.32, s.X * 1.15, CF(0, s.Y * 0.58, 0), cor:Lerp(rgb(60, 44, 28), 0.15), Mat.Fabric)
		cil(m, H, "ChapeuFita", s.Y * 0.08, s.X * 1.18, CF(0, s.Y * 0.50, 0), rgb(70, 50, 36), Mat.Fabric)
	elseif tipo == "boina" then
		cil(m, H, "Boina", s.Y * 0.2, s.X * 1.34, CF(s.X * 0.06, s.Y * 0.52, 0) * ang(0, 0, 6), cor, Mat.Fabric)
	elseif tipo == "gorro" then
		cil(m, H, "GorroTopo", s.Y * 0.42, s.X * 1.14, CF(0, s.Y * 0.46, 0), cor, Mat.Fabric)
		cil(m, H, "GorroBorda", s.Y * 0.14, s.X * 1.2, CF(0, s.Y * 0.30, 0), cor:Lerp(rgb(30, 26, 24), 0.25), Mat.Fabric)
	elseif tipo == "touca" then
		cil(m, H, "ToucaBase", s.Y * 0.16, s.X * 1.2, CF(0, s.Y * 0.4, 0), cor, Mat.Fabric)
		cil(m, H, "ToucaCopa", s.Y * 0.5, s.X * 1.04, CF(0, s.Y * 0.68, 0), cor, Mat.Fabric)
		cil(m, H, "ToucaTopo", s.Y * 0.1, s.X * 1.14, CF(0, s.Y * 0.95, 0), cor:Lerp(rgb(120, 112, 100), 0.35), Mat.Fabric)
	elseif tipo == "feltro" then
		cil(m, H, "FeltroAba", s.Y * 0.07, s.X * 2.1, CF(0, s.Y * 0.44, 0) * ang(0, 0, 3), cor, Mat.Fabric)
		cil(m, H, "FeltroCopa", s.Y * 0.42, s.X * 1.1, CF(0, s.Y * 0.66, 0), cor, Mat.Fabric)
		cil(m, H, "FeltroFita", s.Y * 0.09, s.X * 1.14, CF(0, s.Y * 0.52, 0), rgb(58, 40, 34), Mat.Fabric)
		h("FeltroPena", V3(s.X * 0.08, s.Y * 0.8, s.X * 0.26), CF(s.X * 0.52, s.Y * 0.86, s.Z * 0.05) * ang(0, 0, -34), rgb(150, 62, 48))
	elseif tipo == "viajante" then
		cil(m, H, "ViajanteAba", s.Y * 0.07, s.X * 2.3, CF(0, s.Y * 0.44, 0), cor, Mat.Fabric)
		cil(m, H, "ViajanteCopa", s.Y * 0.5, s.X * 1.12, CF(0, s.Y * 0.7, 0), cor, Mat.Fabric)
		cil(m, H, "ViajanteFita", s.Y * 0.08, s.X * 1.16, CF(0, s.Y * 0.5, 0), cor:Lerp(rgb(20, 16, 14), 0.4), Mat.Fabric)
	elseif tipo == "barrete" then
		cil(m, H, "BarreteBase", s.Y * 0.24, s.X * 1.22, CF(0, s.Y * 0.42, 0), cor, Mat.Fabric)
		h("BarreteTopo", V3(s.X * 0.6, s.Y * 0.3, s.Z * 0.6), CF(s.X * 0.18, s.Y * 0.68, 0) * ang(0, 0, -18))
		h("BarretePonta", V3(s.X * 0.36, s.Y * 0.26, s.Z * 0.36), CF(s.X * 0.44, s.Y * 0.84, 0) * ang(0, 0, -50))
	elseif tipo == "elmo" then
		cil(m, H, "ElmoCopa", s.Y * 0.56, s.X * 1.16, CF(0, s.Y * 0.5, 0), cor, Mat.Metal)
		cil(m, H, "ElmoTopo", s.Y * 0.12, s.X * 0.9, CF(0, s.Y * 0.82, 0), cor:Lerp(rgb(30, 30, 34), 0.2), Mat.Metal)
		cil(m, H, "ElmoAro", s.Y * 0.1, s.X * 1.24, CF(0, s.Y * 0.28, 0), cor:Lerp(rgb(20, 20, 24), 0.35), Mat.Metal)
		h("ElmoNariz", V3(s.X * 0.1, s.Y * 0.5, s.Z * 0.08), CF(0, s.Y * 0.06, -s.Z * 0.54), cor, Mat.Metal)
		for _, l in ipairs({ -1, 1 }) do
			h("ElmoFace", V3(s.X * 0.1, s.Y * 0.62, s.Z * 0.5), CF(l * s.X * 0.56, 0, s.Z * 0.1), cor, Mat.Metal)
		end
	elseif tipo == "peste" then
		-- chapeu preto de aba larga e mascara de bico: o rosto fica coberto
		cil(m, H, "PesteAba", s.Y * 0.07, s.X * 2.2, CF(0, s.Y * 0.44, 0), rgb(34, 30, 32), Mat.Fabric)
		cil(m, H, "PesteCopa", s.Y * 0.4, s.X * 1.1, CF(0, s.Y * 0.64, 0), rgb(34, 30, 32), Mat.Fabric)
		h("PesteMascara", V3(s.X * 1.0, s.Y * 0.85, s.Z * 0.14), CF(0, -s.Y * 0.02, -s.Z * 0.54), cor, Mat.Leather)
		h("PesteBico1", V3(s.X * 0.36, s.Y * 0.4, s.Z * 0.6), CF(0, -s.Y * 0.1, -s.Z * 0.9), cor, Mat.Leather)
		h("PesteBico2", V3(s.X * 0.24, s.Y * 0.28, s.Z * 0.55), CF(0, -s.Y * 0.2, -s.Z * 1.35), cor, Mat.Leather)
		h("PesteBico3", V3(s.X * 0.14, s.Y * 0.16, s.Z * 0.45), CF(0, -s.Y * 0.3, -s.Z * 1.75), cor, Mat.Leather)
		for _, l in ipairs({ -1, 1 }) do
			bola(m, H, "PesteLente", V3(s.X * 0.26, s.X * 0.26, s.X * 0.12), CF(l * s.X * 0.24, s.Y * 0.12, -s.Z * 0.62), rgb(120, 78, 44), Mat.Glass)
		end
		h("PesteCapuz", V3(s.X * 1.1, s.Y * 1.0, s.Z * 0.2), CF(0, -s.Y * 0.1, s.Z * 0.54), rgb(34, 30, 32))
	end
end

-- ===================== roupas =====================
local function vestir(m, spec, hipY)
	local R = spec.roupa
	local pele = spec.pele
	local suja = pele:Lerp(rgb(62, 46, 34), 0.32)
	local UT, LT = m.UpperTorso, m.LowerTorso
	local ut, lt = UT.Size, LT.Size

	m.Head.Color = pele
	m.Head.Material = Mat.SmoothPlastic

	pinta(m, { "UpperTorso", "LowerTorso" }, R.camisa)
	pinta(m, { "LeftUpperArm", "RightUpperArm" }, R.manga or R.camisa)
	if R.mangaCurta then
		pinta(m, { "LeftLowerArm", "RightLowerArm" }, pele:Lerp(rgb(70, 52, 38), 0.16), Mat.SmoothPlastic)
	else
		pinta(m, { "LeftLowerArm", "RightLowerArm" }, R.manga or R.camisa)
	end
	pinta(m, { "LeftHand", "RightHand" }, suja, Mat.SmoothPlastic)
	if R.vestido or R.habito then
		pinta(m, { "LeftUpperLeg", "RightUpperLeg" }, R.vestido or R.camisa)
		pinta(m, { "LeftLowerLeg", "RightLowerLeg" }, pele:Lerp(rgb(70, 52, 38), 0.22), Mat.SmoothPlastic)
	else
		pinta(m, { "LeftUpperLeg", "RightUpperLeg" }, R.calca)
		pinta(m, { "LeftLowerLeg", "RightLowerLeg" }, R.calcaBaixa or R.calca)
	end
	if R.botas then
		pinta(m, { "LeftFoot", "RightFoot" }, R.botas, Mat.Leather)
	else
		pinta(m, { "LeftFoot", "RightFoot" }, suja:Lerp(rgb(50, 38, 28), 0.3), Mat.SmoothPlastic)
	end

	-- rosto
	local f = Instance.new("Decal")
	f.Name = "face"
	f.Texture = Assets.Faces[spec.face]
	f.Face = Enum.NormalId.Front
	f.Parent = m.Head

	-- sujeira em decals
	local tex = Assets.Sujo[R.sujo or "torso1"]
	decal(UT, tex, Enum.NormalId.Front)
	decal(UT, Assets.Sujo[(R.sujo == "torso2") and "torso1" or "torso2"], Enum.NormalId.Back)
	decal(LT, Assets.Sujo.perna, Enum.NormalId.Front)
	decal(LT, Assets.Sujo.perna, Enum.NormalId.Back)
	for _, n in ipairs({ "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm" }) do
		for _, fc in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right }) do
			if not (R.mangaCurta and n:find("LowerArm")) then decal(m[n], Assets.Sujo.braco, fc) end
		end
	end
	for _, n in ipairs({ "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg" }) do
		if not ((R.vestido or R.habito) and n:find("UpperLeg")) then
			for _, fc in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right }) do
				decal(m[n], Assets.Sujo.perna, fc)
			end
		end
	end

	-- tunica longa (homens e criancas) ou vestido (mulheres)
	local C = R.vestido or R.camisa
	local suj = C:Lerp(rgb(52, 40, 30), 0.45)
	if R.vestido or R.habito then
		local L = hipY * (R.habito and 0.95 or 0.76)
		local tiers = 6
		local dmax = lt.X * 1.72
		for i = 1, tiers do
			local alt = L / tiers
			local t = i / tiers
			local diam = lt.X * 1.08 + (dmax - lt.X * 1.08) * (t ^ 1.15)
			cil(m, LT, "Saia" .. i, alt + 0.02, diam, CF(0, lt.Y * 0.1 - alt * (i - 0.5), 0), C, Mat.Fabric)
		end
		cil(m, LT, "Barra", 0.28 * (lt.X / 2), dmax + 0.06, CF(0, lt.Y * 0.1 - L + 0.14 * (lt.X / 2), 0), suj, Mat.Fabric)
		if R.habito then
			cil(m, LT, "BarraSuja", 0.4 * (lt.X / 2), dmax + 0.1, CF(0, lt.Y * 0.1 - L + 0.2 * (lt.X / 2), 0), suj:Lerp(rgb(30, 24, 18), 0.4), Mat.Fabric)
		end
	else
		local tl = hipY * 0.30
		peca(m, LT, "Tunica", V3(lt.X * 1.16, tl, lt.Z * 1.24), CF(0, -lt.Y * 0.5 - tl / 2 + 0.05, 0), C, Mat.Fabric)
		peca(m, LT, "TunicaBarra", V3(lt.X * 1.18, tl * 0.22, lt.Z * 1.26), CF(0, -lt.Y * 0.5 - tl + 0.05 + tl * 0.11, 0), suj, Mat.Fabric)
	end

	-- cinto de corda
	if R.cinto ~= false then
		peca(m, LT, "Cinto", V3(lt.X * 1.1, 0.3 * (ut.Y / 1.6), lt.Z * 1.14), CF(0, lt.Y * 0.5, 0), R.cintoCor or CORDA, Mat.Fabric)
		peca(m, LT, "CintoPonta", V3(0.14 * (lt.X / 2), 0.8 * (ut.Y / 1.6), 0.1), CF(lt.X * 0.28, -0.1, -lt.Z * 0.62), R.cintoCor or CORDA, Mat.Fabric)
	end

	-- avental (so com calca)
	if R.avental then
		local H = ut.Y * 0.55 + hipY * 0.42
		peca(m, LT, "Avental", V3(lt.X * 0.92, H, 0.1), CF(0, ut.Y * 0.25 - H / 2 + lt.Y * 0.5, -(lt.Z * 0.62 + 0.04)), R.avental, Mat.Fabric)
		peca(m, LT, "AventalBolso", V3(lt.X * 0.5, H * 0.26, 0.12), CF(0, -H * 0.1, -(lt.Z * 0.62 + 0.09)), R.avental:Lerp(rgb(40, 30, 24), 0.25), Mat.Fabric)
		peca(m, UT, "AventalAlca", V3(ut.X * 0.22, 0.1, 0.1), CF(0, ut.Y * 0.46, -ut.Z * 0.52), R.avental, Mat.Fabric)
	end

	-- xale
	if R.xale then
		local c = R.xale
		peca(m, UT, "XaleOmbros", V3(ut.X * 1.32, ut.Y * 0.3, ut.Z * 1.4), CF(0, ut.Y * 0.36, 0), c, Mat.Fabric)
		for _, l in ipairs({ -1, 1 }) do
			peca(m, UT, "XaleFrente", V3(ut.X * 0.3, ut.Y * 0.56, 0.08), CF(l * ut.X * 0.2, ut.Y * 0.02, -ut.Z * 0.555) * ang(0, 0, -l * 22), c:Lerp(rgb(30, 24, 20), 0.12), Mat.Fabric)
		end
		peca(m, UT, "XaleCostas", V3(ut.X * 1.15, ut.Y * 0.95, 0.1), CF(0, -ut.Y * 0.05, ut.Z * 0.56), c, Mat.Fabric)
	end

	-- colete de couro
	if R.colete then
		for _, l in ipairs({ -1, 1 }) do
			peca(m, UT, "ColeteFrente", V3(ut.X * 0.34, ut.Y * 0.92, 0.1), CF(l * ut.X * 0.31, 0, -ut.Z * 0.53), R.colete, Mat.Leather)
		end
		peca(m, UT, "ColeteCostas", V3(ut.X * 0.96, ut.Y * 0.92, 0.1), CF(0, 0, ut.Z * 0.53), R.colete, Mat.Leather)
	end

	-- capa
	if R.capa then
		local comp = ut.Y + hipY * 0.7
		peca(m, UT, "CapaOmbros", V3(ut.X * 1.36, ut.Y * 0.24, ut.Z * 1.42), CF(0, ut.Y * 0.4, 0), R.capa, Mat.Fabric)
		peca(m, UT, "CapaCostas", V3(ut.X * 1.3, comp, 0.14), CF(0, ut.Y * 0.4 - comp / 2, ut.Z * 0.66), R.capa, Mat.Fabric)
	end

	-- armadura (peitoral, ombreiras e escamas)
	if R.armadura then
		local a = R.armadura
		peca(m, UT, "Peitoral", V3(ut.X * 1.1, ut.Y * 0.8, ut.Z * 1.16), CF(0, ut.Y * 0.04, 0), a, Mat.Metal)
		peca(m, UT, "PeitoralBorda", V3(ut.X * 1.14, ut.Y * 0.1, ut.Z * 1.2), CF(0, -ut.Y * 0.4, 0), a:Lerp(rgb(30, 30, 34), 0.3), Mat.Metal)
		for _, l in ipairs({ -1, 1 }) do
			peca(m, UT, "Ombreira", V3(ut.X * 0.52, 0.2, ut.Z * 1.3), CF(l * ut.X * 0.74, ut.Y * 0.48, 0) * ang(0, 0, -l * 14), a, Mat.Metal)
		end
		peca(m, LT, "Escamas", V3(lt.X * 1.2, hipY * 0.22, lt.Z * 1.3), CF(0, -lt.Y * 0.5 - 0.05, 0), a:Lerp(rgb(30, 30, 34), 0.25), Mat.Metal)
	end

end

-- ===================== adercos de mao =====================
local ITENS = {}

function ITENS.enxada(m, mao, sc)
	peca(m, mao, "Cabo", V3(0.2 * sc, 0.2 * sc, 4.8 * sc), CF(0, -0.1 * sc, -1.2 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "Lamina", V3(0.9 * sc, 0.95 * sc, 0.12 * sc), CF(0, -0.45 * sc, -3.55 * sc), FERRO, Mat.Metal)
	peca(m, mao, "Encaixe", V3(0.26 * sc, 0.3 * sc, 0.4 * sc), CF(0, -0.1 * sc, -3.5 * sc), FERRO, Mat.Metal)
end

function ITENS.pa(m, mao, sc)
	peca(m, mao, "Cabo", V3(0.2 * sc, 0.2 * sc, 4.6 * sc), CF(0, -0.1 * sc, -1.1 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "Cabeca", V3(0.3 * sc, 0.2 * sc, 0.3 * sc), CF(0, -0.1 * sc, 1.2 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "Lamina", V3(0.85 * sc, 0.12 * sc, 1.2 * sc), CF(0, -0.05 * sc, -3.9 * sc), FERRO, Mat.Metal)
end

function ITENS.machado(m, mao, sc)
	peca(m, mao, "Cabo", V3(0.18 * sc, 0.18 * sc, 3.4 * sc), CF(0, -0.1 * sc, -0.8 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "Cabeca", V3(0.14 * sc, 0.8 * sc, 0.7 * sc), CF(0, -0.25 * sc, -2.35 * sc), FERRO, Mat.Metal)
	peca(m, mao, "Costas", V3(0.16 * sc, 0.34 * sc, 0.3 * sc), CF(0, 0.2 * sc, -2.0 * sc), FERRO, Mat.Metal)
end

function ITENS.vassoura(m, mao, sc)
	peca(m, mao, "Cabo", V3(0.16 * sc, 0.16 * sc, 4.2 * sc), CF(0, -0.1 * sc, -1.0 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "Palha", V3(0.85 * sc, 0.5 * sc, 1.2 * sc), CF(0, -0.15 * sc, -3.9 * sc), PALHA, Mat.Fabric)
	peca(m, mao, "Amarra", V3(0.9 * sc, 0.56 * sc, 0.16 * sc), CF(0, -0.15 * sc, -3.3 * sc), CORDA, Mat.Fabric)
end

function ITENS.cajado(m, mao, sc)
	peca(m, mao, "Cajado", V3(0.2 * sc, 4.6 * sc, 0.2 * sc), CF(0, -1.5 * sc, -0.15 * sc), MADEIRA, Mat.Wood)
	bola(m, mao, "Punho", V3(0.34 * sc, 0.34 * sc, 0.34 * sc), CF(0, 0.85 * sc, -0.15 * sc), MADEIRA_ESC, Mat.Wood)
end

function ITENS.lanca(m, mao, sc)
	peca(m, mao, "Haste", V3(0.18 * sc, 6.4 * sc, 0.18 * sc), CF(0, -1.6 * sc, -0.2 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "Ponta", V3(0.12 * sc, 0.9 * sc, 0.36 * sc), CF(0, 1.9 * sc, -0.2 * sc), FERRO, Mat.Metal)
	peca(m, mao, "PontaBase", V3(0.26 * sc, 0.2 * sc, 0.26 * sc), CF(0, 1.4 * sc, -0.2 * sc), FERRO, Mat.Metal)
end

function ITENS.balde(m, mao, sc)
	cil(m, mao, "Balde", 1.0 * sc, 1.0 * sc, CF(0, -1.65 * sc, -0.1 * sc), MADEIRA, Mat.WoodPlanks)
	cil(m, mao, "BaldeAro1", 0.12 * sc, 1.06 * sc, CF(0, -1.35 * sc, -0.1 * sc), FERRO, Mat.Metal)
	cil(m, mao, "BaldeAro2", 0.12 * sc, 1.02 * sc, CF(0, -1.95 * sc, -0.1 * sc), FERRO, Mat.Metal)
	peca(m, mao, "BaldeAlca", V3(0.07 * sc, 1.1 * sc, 0.07 * sc), CF(0, -0.85 * sc, -0.1 * sc), FERRO, Mat.Metal)
end

function ITENS.cesto(m, mao, sc, lado)
	cil(m, mao, "Cesto", 0.9 * sc, 1.5 * sc, CF(lado * 0.7 * sc, -1.0 * sc, -0.3 * sc), rgb(128, 98, 58), Mat.Fabric)
	cil(m, mao, "CestoBorda", 0.12 * sc, 1.6 * sc, CF(lado * 0.7 * sc, -0.55 * sc, -0.3 * sc), rgb(98, 74, 42), Mat.Wood)
	peca(m, mao, "CestoCarga", V3(1.1 * sc, 0.25 * sc, 1.1 * sc), CF(lado * 0.7 * sc, -0.55 * sc, -0.3 * sc), rgb(86, 78, 52), Mat.Fabric)
end

function ITENS.jarro(m, mao, sc, lado)
	cil(m, mao, "Jarro", 1.0 * sc, 0.85 * sc, CF(lado * 0.55 * sc, -1.0 * sc, -0.25 * sc), rgb(132, 86, 58), Mat.Slate)
	cil(m, mao, "JarroPescoco", 0.4 * sc, 0.42 * sc, CF(lado * 0.55 * sc, -0.3 * sc, -0.25 * sc), rgb(120, 78, 52), Mat.Slate)
end

function ITENS.tigela(m, mao, sc)
	cil(m, mao, "Tigela", 0.28 * sc, 0.95 * sc, CF(0, -0.1 * sc, -0.55 * sc), MADEIRA, Mat.Wood)
	cil(m, mao, "TigelaFundo", 0.06 * sc, 0.72 * sc, CF(0, 0.02 * sc, -0.55 * sc), MADEIRA_ESC, Mat.Wood)
end

function ITENS.graveto(m, mao, sc)
	peca(m, mao, "Graveto", V3(0.09 * sc, 0.09 * sc, 1.7 * sc), CF(0, -0.05 * sc, -0.5 * sc), MADEIRA, Mat.Wood)
end

function ITENS.pano(m, mao, sc)
	peca(m, mao, "Pano", V3(0.7 * sc, 0.08 * sc, 0.9 * sc), CF(0, -0.15 * sc, -0.4 * sc), rgb(150, 142, 118), Mat.Fabric)
end

function ITENS.agulha(m, mao, sc)
	peca(m, mao, "Agulha", V3(0.04 * sc, 0.04 * sc, 0.5 * sc), CF(0, -0.1 * sc, -0.4 * sc), rgb(170, 170, 176), Mat.Metal)
end

function ITENS.lanterna(m, mao, sc)
	local c = CF(0, 0, -0.15 * sc)
	peca(m, mao, "LanternaAlca", V3(0.07 * sc, 0.8 * sc, 0.07 * sc), c * CF(0, -0.4 * sc, 0), FERRO, Mat.Metal)
	peca(m, mao, "LanternaTopo", V3(0.6 * sc, 0.1 * sc, 0.6 * sc), c * CF(0, -0.85 * sc, 0), FERRO, Mat.Metal)
	peca(m, mao, "LanternaBase", V3(0.6 * sc, 0.1 * sc, 0.6 * sc), c * CF(0, -1.55 * sc, 0), FERRO, Mat.Metal)
	for _, x in ipairs({ -1, 1 }) do
		for _, z in ipairs({ -1, 1 }) do
			peca(m, mao, "LanternaPoste", V3(0.06 * sc, 0.7 * sc, 0.06 * sc), c * CF(x * 0.27 * sc, -1.2 * sc, z * 0.27 * sc), FERRO, Mat.Metal)
		end
	end
	chama(m, mao, "LanternaChama", c * CF(0, -1.2 * sc, 0), V3(0.34 * sc, 0.46 * sc, 0.34 * sc), 16, 1.0)
end

function ITENS.tocha(m, mao, sc)
	peca(m, mao, "TochaCabo", V3(0.17 * sc, 3.6 * sc, 0.17 * sc), CF(0, -0.4 * sc, -0.2 * sc), MADEIRA, Mat.Wood)
	cil(m, mao, "TochaPano", 0.7 * sc, 0.38 * sc, CF(0, 1.55 * sc, -0.2 * sc), rgb(60, 48, 38), Mat.Fabric)
	chama(m, mao, "TochaChama", CF(0, 2.1 * sc, -0.2 * sc), V3(0.55 * sc, 0.8 * sc, 0.55 * sc), 24, 1.25)
end

function ITENS.vara_acendedor(m, mao, sc)
	peca(m, mao, "VaraHaste", V3(0.15 * sc, 8.6 * sc, 0.15 * sc), CF(0, -2.3 * sc, -0.2 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "VaraGancho", V3(0.5 * sc, 0.1 * sc, 0.1 * sc), CF(0.22 * sc, 2.02 * sc, -0.2 * sc), FERRO, Mat.Metal)
	peca(m, mao, "VaraMecha", V3(0.1 * sc, 0.3 * sc, 0.1 * sc), CF(0.46 * sc, 2.18 * sc, -0.2 * sc), rgb(60, 48, 38), Mat.Fabric)
	chama(m, mao, "VaraChama", CF(0.46 * sc, 2.42 * sc, -0.2 * sc), V3(0.22 * sc, 0.34 * sc, 0.22 * sc), 14, 0.9)
end

function ITENS.martelo(m, mao, sc)
	peca(m, mao, "Cabo", V3(0.18 * sc, 0.18 * sc, 2.8 * sc), CF(0, -0.1 * sc, -0.6 * sc), MADEIRA, Mat.Wood)
	peca(m, mao, "Cabeca", V3(0.42 * sc, 0.46 * sc, 0.9 * sc), CF(0, -0.2 * sc, -2.0 * sc), FERRO, Mat.Metal)
end

function ITENS.vela(m, mao, sc)
	cil(m, mao, "VelaPires", 0.07 * sc, 0.8 * sc, CF(0, -0.05 * sc, -0.4 * sc), rgb(120, 116, 106), Mat.Metal)
	cil(m, mao, "Vela", 0.6 * sc, 0.17 * sc, CF(0, 0.3 * sc, -0.4 * sc), rgb(214, 204, 176), Mat.SmoothPlastic)
	chama(m, mao, "VelaChama", CF(0, 0.7 * sc, -0.4 * sc), V3(0.11 * sc, 0.2 * sc, 0.11 * sc), 11, 0.9)
end

function ITENS.garrafa(m, mao, sc)
	cil(m, mao, "Garrafa", 0.9 * sc, 0.4 * sc, CF(0, -0.45 * sc, -0.15 * sc), rgb(74, 92, 62), Mat.Glass)
	cil(m, mao, "GarrafaPescoco", 0.45 * sc, 0.17 * sc, CF(0, 0.2 * sc, -0.15 * sc), rgb(74, 92, 62), Mat.Glass)
	cil(m, mao, "GarrafaRolha", 0.1 * sc, 0.14 * sc, CF(0, 0.47 * sc, -0.15 * sc), rgb(150, 120, 80), Mat.Wood)
end

function ITENS.rolo(m, mao, sc)
	cil(m, mao, "Rolo", 0.95 * sc, 0.26 * sc, CF(0, -0.15 * sc, -0.3 * sc), rgb(190, 176, 140), Mat.Fabric)
	cil(m, mao, "RoloFita", 0.12 * sc, 0.3 * sc, CF(0, -0.15 * sc, -0.3 * sc), rgb(120, 40, 34), Mat.Fabric)
end

function ITENS.escudo(m, mao, sc, lado)
	cilH(m, mao, "Escudo", 0.14 * sc, 2.2 * sc, "z", CF(lado * 0.55 * sc, -0.2 * sc, -0.5 * sc), rgb(96, 78, 56), Mat.WoodPlanks)
	cilH(m, mao, "EscudoAro", 0.1 * sc, 2.34 * sc, "z", CF(lado * 0.55 * sc, -0.2 * sc, -0.45 * sc), FERRO, Mat.Metal)
	cilH(m, mao, "EscudoCentro", 0.3 * sc, 0.6 * sc, "z", CF(lado * 0.55 * sc, -0.2 * sc, -0.62 * sc), FERRO, Mat.Metal)
	peca(m, mao, "EscudoFaixa", V3(0.22 * sc, 2.0 * sc, 0.05 * sc), CF(lado * 0.55 * sc, -0.2 * sc, -0.6 * sc), rgb(112, 40, 36), Mat.Fabric)
end

function ITENS.pao(m, mao, sc)
	bola(m, mao, "Pao", V3(0.95 * sc, 0.55 * sc, 0.6 * sc), CF(0, -0.35 * sc, -0.2 * sc), rgb(176, 134, 84), Mat.Fabric)
	peca(m, mao, "PaoCorte", V3(0.5 * sc, 0.04 * sc, 0.14 * sc), CF(0, -0.1 * sc, -0.2 * sc), rgb(120, 84, 48), Mat.Fabric)
end

function ITENS.arco(m, mao, sc)
	peca(m, mao, "ArcoPunho", V3(0.12 * sc, 0.6 * sc, 0.12 * sc), CF(0, 0, -0.3 * sc), COURO, Mat.Leather)
	peca(m, mao, "ArcoBracoCima", V3(0.1 * sc, 1.5 * sc, 0.1 * sc), CF(0, 0.93 * sc, 0) * ang(25, 0, 0), MADEIRA, Mat.Wood)
	peca(m, mao, "ArcoBracoBaixo", V3(0.1 * sc, 1.5 * sc, 0.1 * sc), CF(0, -0.93 * sc, 0) * ang(-25, 0, 0), MADEIRA, Mat.Wood)
	peca(m, mao, "ArcoCorda", V3(0.02 * sc, 2.5 * sc, 0.02 * sc), CF(0, 0, 0.32 * sc), rgb(200, 190, 160), Mat.Fabric)
end

-- ===================== adercos de corpo / cenario do NPC =====================
local CORPO = {}

function CORPO.saco_ombro(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	peca(m, UT, "Saco", V3(1.25 * sc, 1.7 * sc, 1.0 * sc), CF(-0.95 * sc, 0.75 * sc, 0.25 * sc) * ang(0, 0, -20), rgb(150, 134, 98), Mat.Fabric)
	peca(m, UT, "SacoNo", V3(0.5 * sc, 0.34 * sc, 0.5 * sc), CF(-1.35 * sc, 1.55 * sc, 0.25 * sc) * ang(0, 0, -20), rgb(120, 104, 76), Mat.Fabric)
end

function CORPO.caixote(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	peca(m, UT, "Caixote", V3(1.8 * sc, 1.15 * sc, 1.5 * sc), CF(0, -0.55 * sc, -1.35 * sc), rgb(98, 76, 52), Mat.WoodPlanks)
	peca(m, UT, "CaixoteRipa", V3(1.86 * sc, 0.16 * sc, 1.56 * sc), CF(0, -0.2 * sc, -1.35 * sc), MADEIRA_ESC, Mat.Wood)
	peca(m, UT, "CaixoteCarga", V3(1.4 * sc, 0.4 * sc, 1.1 * sc), CF(0, 0.15 * sc, -1.35 * sc), rgb(96, 82, 52), Mat.Fabric)
end

function CORPO.feixe_costas(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	local rnd = Random.new(11)
	for i = 1, 7 do
		local x = ((i - 1) % 4 - 1.5) * 0.36 * sc
		local z = (0.95 + (i > 4 and 0.34 or 0)) * sc
		cil(m, UT, "Lenha" .. i, (2.6 + rnd:NextNumber(-0.4, 0.5)) * sc, 0.32 * sc, CF(x, 0.15 * sc + rnd:NextNumber(-0.1, 0.2), z) * ang(rnd:NextNumber(-8, 8), 0, rnd:NextNumber(-10, 10)), MADEIRA:Lerp(rgb(130, 100, 70), rnd:NextNumber(0, 0.5)), Mat.Wood)
	end
	cil(m, UT, "LenhaAmarra1", 0.14 * sc, 1.9 * sc, CF(0, 0.8 * sc, 1.12 * sc) * ang(0, 0, 0), CORDA, Mat.Fabric)
	cil(m, UT, "LenhaAmarra2", 0.14 * sc, 1.9 * sc, CF(0, -0.4 * sc, 1.12 * sc), CORDA, Mat.Fabric)
end

function CORPO.lenha_frente(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	local rnd = Random.new(5)
	for i = 1, 6 do
		cilH(m, UT, "Lenha" .. i, (2.2 + rnd:NextNumber(-0.3, 0.4)) * sc, 0.34 * sc, "x", CF(rnd:NextNumber(-0.1, 0.1), (-0.15 + ((i - 1) % 3) * 0.3 - 0.3) * sc, (-0.95 - math.floor((i - 1) / 3) * 0.34) * sc) * ang(0, rnd:NextNumber(-6, 6), 0), MADEIRA:Lerp(rgb(130, 100, 70), rnd:NextNumber(0, 0.5)), Mat.Wood)
	end
end

function CORPO.boneca(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	peca(m, UT, "BonecaCorpo", V3(0.42 * sc, 0.8 * sc, 0.26 * sc), CF(0.15 * sc, -0.45 * sc, -0.8 * sc) * ang(0, 0, 8), rgb(128, 110, 86), Mat.Fabric)
	bola(m, UT, "BonecaCabeca", V3(0.34 * sc, 0.34 * sc, 0.34 * sc), CF(0.17 * sc, 0.12 * sc, -0.8 * sc), rgb(190, 160, 128), Mat.Fabric)
	peca(m, UT, "BonecaCabelo", V3(0.36 * sc, 0.14 * sc, 0.36 * sc), CF(0.17 * sc, 0.26 * sc, -0.78 * sc), rgb(76, 54, 36), Mat.Fabric)
	peca(m, UT, "BonecaBracos", V3(0.8 * sc, 0.14 * sc, 0.14 * sc), CF(0.14 * sc, -0.2 * sc, -0.8 * sc), rgb(128, 110, 86), Mat.Fabric)
end

function CORPO.carrinho(m, ctx)
	local R, sc, ar = m.HumanoidRootPart, ctx.sc, ctx.ar
	peca(m, R, "CarrinhoCaixa", V3(2.5 * sc, 0.9 * sc, 3.0 * sc), CF(0, -ar + 1.9 * sc, -4.0 * sc), rgb(80, 60, 42), Mat.WoodPlanks)
	for _, l in ipairs({ -1, 1 }) do
		peca(m, R, "CarrinhoLado", V3(0.14 * sc, 0.8 * sc, 3.0 * sc), CF(l * 1.25 * sc, -ar + 2.6 * sc, -4.0 * sc), rgb(70, 52, 36), Mat.WoodPlanks)
	end
	peca(m, R, "CarrinhoFrente", V3(2.5 * sc, 0.8 * sc, 0.14 * sc), CF(0, -ar + 2.6 * sc, -5.5 * sc), rgb(70, 52, 36), Mat.WoodPlanks)
	peca(m, R, "CarrinhoTras", V3(2.5 * sc, 0.8 * sc, 0.14 * sc), CF(0, -ar + 2.6 * sc, -2.5 * sc), rgb(70, 52, 36), Mat.WoodPlanks)
	cilH(m, R, "CarrinhoRoda", 0.4 * sc, 2.0 * sc, "x", CF(0, -ar + 1.0 * sc, -5.7 * sc), MADEIRA_ESC, Mat.Wood)
	cilH(m, R, "CarrinhoEixo", 2.9 * sc, 0.2 * sc, "x", CF(0, -ar + 1.0 * sc, -5.7 * sc), FERRO, Mat.Metal)
	for _, l in ipairs({ -1, 1 }) do
		peca(m, R, "CarrinhoAlca", V3(0.16 * sc, 0.16 * sc, 3.2 * sc), CF(l * 0.95 * sc, -0.4 * sc, -1.2 * sc) * ang(-6, 0, 0), MADEIRA, Mat.Wood)
		peca(m, R, "CarrinhoPe", V3(0.18 * sc, 0.18 * sc, 0.18 * sc), CF(l * 1.1 * sc, -ar + 0.6 * sc, -2.5 * sc), MADEIRA_ESC, Mat.Wood)
	end
	for i = 1, 3 do
		peca(m, R, "CarrinhoSaco" .. i, V3(1.0 * sc, 0.9 * sc, 1.2 * sc), CF((i - 2) * 0.75 * sc, -ar + 2.9 * sc, -4.0 * sc + (i == 2 and 0.3 or -0.1) * sc) * ang(0, (i - 2) * 14, (i - 2) * 6), rgb(146, 130, 96):Lerp(rgb(70, 60, 44), i * 0.1), Mat.Fabric)
	end
end

function CORPO.bacia(m, ctx)
	local R, sc, ar = m.HumanoidRootPart, ctx.sc, ctx.ar
	cil(m, R, "Bacia", 0.9 * sc, 2.7 * sc, CF(0, -ar + 0.45 * sc, -2.1 * sc), MADEIRA, Mat.WoodPlanks)
	cil(m, R, "BaciaAro", 0.14 * sc, 2.78 * sc, CF(0, -ar + 0.8 * sc, -2.1 * sc), FERRO, Mat.Metal)
	local agua = cil(m, R, "BaciaAgua", 0.06 * sc, 2.3 * sc, CF(0, -ar + 0.78 * sc, -2.1 * sc), rgb(52, 62, 60), Mat.SmoothPlastic)
	agua.Reflectance = 0.15
end

function CORPO.toco(m, ctx)
	local R, sc, ar = m.HumanoidRootPart, ctx.sc, ctx.ar
	cil(m, R, "Toco", 1.3 * sc, 1.9 * sc, CF(0, -ar + 0.65 * sc, -3.1 * sc), MADEIRA, Mat.Wood)
	cil(m, R, "TocoTopo", 0.05 * sc, 1.7 * sc, CF(0, -ar + 1.32 * sc, -3.1 * sc), rgb(140, 112, 76), Mat.Wood)
	cilH(m, R, "Tora", 2.4 * sc, 0.7 * sc, "x", CF(0.1, -ar + 1.7 * sc, -3.1 * sc), rgb(78, 58, 40), Mat.Wood)
	local rnd = Random.new(3)
	for i = 1, 7 do
		peca(m, R, "Lasca" .. i, V3(0.5 * sc, 0.12 * sc, 0.2 * sc), CF(rnd:NextNumber(-2.2, 2.2) * sc, -ar + 0.1, -rnd:NextNumber(1.6, 4.6) * sc) * ang(0, rnd:NextNumber(0, 180), 0), rgb(120, 94, 64), Mat.Wood)
	end
end

local function cruz(m, R, nome, cf, sc)
	peca(m, R, nome .. "V", V3(0.18 * sc, 1.8 * sc, 0.18 * sc), cf * CF(0, 0.9 * sc, 0), MADEIRA, Mat.Wood)
	peca(m, R, nome .. "H", V3(0.95 * sc, 0.17 * sc, 0.17 * sc), cf * CF(0, 1.25 * sc, 0), MADEIRA, Mat.Wood)
end

function CORPO.cova(m, ctx)
	local R, sc, ar = m.HumanoidRootPart, ctx.sc, ctx.ar
	local terra = rgb(66, 52, 38)
	-- cova aberta (disco escuro) e monte de terra
	cil(m, R, "CovaBuraco", 0.1, 3.2, CF(-2.6, -ar + 0.12, -2.2), rgb(44, 34, 24), Mat.Ground) -- terra revolvida (era quase preto, e um disco preto no chão parecia uma sombra com defeito)
	bola(m, R, "CovaMonte", V3(4.0, 1.5, 2.8), CF(2.8, -ar + 0.4, -2.4) * ang(0, 20, 0), terra, Mat.Ground)
	bola(m, R, "CovaMonte2", V3(2.4, 1.0, 2.0), CF(3.9, -ar + 0.3, -0.9) * ang(0, -20, 0), terra:Lerp(rgb(90, 72, 52), 0.3), Mat.Ground)
	-- tumulos recentes com cruzes
	for i, x in ipairs({ -6.5, -9.0, -11.5 }) do
		bola(m, R, "Tumulo" .. i, V3(2.2, 0.7, 4.0), CF(x, -ar + 0.2, -3.2), terra, Mat.Ground)
		cruz(m, R, "Cruz" .. i, CF(x, -ar + 0.4, -5.3) * ang(0, (i - 2) * 9, (i - 2) * 6), 1.0)
	end
end

function CORPO.caixa_vazia(m, ctx)
	local R, sc, ar = m.HumanoidRootPart, ctx.sc, ctx.ar
	peca(m, R, "CaixaVazia", V3(2.2, 1.2, 1.6), CF(-2.5, -ar + 0.6, 0.4) * ang(0, 20, 0), rgb(96, 74, 50), Mat.WoodPlanks)
	peca(m, R, "CaixaVazia2", V3(1.6, 1.0, 1.4), CF(2.7, -ar + 0.5, 0.8) * ang(0, -10, 0), rgb(84, 64, 44), Mat.WoodPlanks)
end

function CORPO.alaude(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	local base = CF(0.2 * sc, -0.4 * sc, -0.95 * sc) * ang(0, 0, 38)
	local madeira, escuro = rgb(124, 88, 52), rgb(70, 50, 34)
	peca(m, UT, "AlaudeCorpo", V3(1.35 * sc, 1.5 * sc, 0.55 * sc), base, madeira, Mat.Wood, "Part", Enum.PartType.Ball)
	cilH(m, UT, "AlaudeBoca", 0.06 * sc, 0.42 * sc, "z", base * CF(0, 0.05 * sc, -0.27 * sc), rgb(20, 14, 10), Mat.SmoothPlastic)
	peca(m, UT, "AlaudeBraco", V3(0.2 * sc, 1.9 * sc, 0.14 * sc), base * CF(0, 1.55 * sc, -0.12 * sc), escuro, Mat.Wood)
	peca(m, UT, "AlaudeCabeca", V3(0.3 * sc, 0.42 * sc, 0.2 * sc), base * CF(0, 2.7 * sc, -0.12 * sc), escuro, Mat.Wood)
	peca(m, UT, "AlaudeCordas", V3(0.03 * sc, 3.0 * sc, 0.03 * sc), base * CF(0, 1.2 * sc, -0.3 * sc), rgb(200, 190, 160), Mat.Fabric)
end

function CORPO.livro(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	local base = CF(0, -0.1 * sc, -1.3 * sc) * ang(40, 0, 0)
	peca(m, UT, "LivroCapa", V3(1.5 * sc, 0.1 * sc, 1.1 * sc), base * CF(0, -0.06 * sc, 0), rgb(84, 48, 40), Mat.Leather)
	peca(m, UT, "LivroPaginas", V3(1.38 * sc, 0.12 * sc, 1.0 * sc), base * CF(0, 0.02 * sc, 0), rgb(204, 192, 160), Mat.Fabric)
	peca(m, UT, "LivroLombada", V3(0.12 * sc, 0.2 * sc, 1.1 * sc), base * CF(0, -0.02 * sc, 0), rgb(70, 40, 34), Mat.Leather)
end

local function bandeja(m, UT, sc)
	cil(m, UT, "Bandeja", 0.1 * sc, 2.4 * sc, CF(0, -0.3 * sc, -1.95 * sc), MADEIRA, Mat.Wood)
	cil(m, UT, "BandejaAro", 0.16 * sc, 2.5 * sc, CF(0, -0.36 * sc, -1.95 * sc), MADEIRA_ESC, Mat.Wood)
end

function CORPO.bandeja_paes(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	bandeja(m, UT, sc)
	local pos = { { -0.55, -1.7 }, { 0.5, -1.9 }, { -0.05, -2.3 } }
	for i, p in ipairs(pos) do
		bola(m, UT, "Pao" .. i, V3(0.95 * sc, 0.5 * sc, 0.6 * sc), CF(p[1] * sc, -0.06 * sc, p[2] * sc) * ang(0, i * 40, 0), rgb(176 - i * 8, 134 - i * 6, 84), Mat.Fabric)
	end
end

function CORPO.bandeja_velas(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	bandeja(m, UT, sc)
	local pos = { { -0.6, -1.65 }, { 0.2, -1.55 }, { 0.7, -1.95 }, { -0.5, -2.3 }, { 0.15, -2.4 }, { 0.65, -2.45 } }
	for i, p in ipairs(pos) do
		cil(m, UT, "Vela" .. i, 0.5 * sc, 0.16 * sc, CF(p[1] * sc, -0.0 * sc, p[2] * sc), rgb(214, 204, 176), Mat.SmoothPlastic)
		chama(m, UT, "VelaChama" .. i, CF(p[1] * sc, 0.34 * sc, p[2] * sc), V3(0.1 * sc, 0.18 * sc, 0.1 * sc), i == 2 and 14 or nil, 0.9)
	end
end

function CORPO.mochila(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	peca(m, UT, "Mochila", V3(1.5 * sc, 1.7 * sc, 0.8 * sc), CF(0, 0, 0.92 * sc), rgb(96, 76, 52), Mat.Leather)
	cilH(m, UT, "MochilaManta", 1.9 * sc, 0.7 * sc, "x", CF(0, 1.05 * sc, 0.95 * sc), rgb(110, 96, 70), Mat.Fabric)
	for _, l in ipairs({ -1, 1 }) do
		peca(m, UT, "MochilaCorreia", V3(0.18 * sc, 1.5 * sc, 0.1 * sc), CF(l * 0.5 * sc, 0.05 * sc, -0.58 * sc), COURO, Mat.Leather)
	end
end

function CORPO.aljava(m, ctx)
	local UT, sc = m.UpperTorso, ctx.sc
	local aq = CF(0.45 * sc, 0.35 * sc, 0.78 * sc) * ang(0, 0, -18)
	cil(m, UT, "Aljava", 1.9 * sc, 0.5 * sc, aq, COURO, Mat.Leather)
	for i = 1, 3 do
		peca(m, UT, "Seta" .. i, V3(0.05 * sc, 1.0 * sc, 0.05 * sc), aq * CF((i - 2) * 0.12 * sc, 1.4 * sc, 0), MADEIRA, Mat.Wood)
		peca(m, UT, "SetaPena" .. i, V3(0.16 * sc, 0.3 * sc, 0.03 * sc), aq * CF((i - 2) * 0.12 * sc, 1.85 * sc, 0), rgb(150, 62, 48), Mat.Fabric)
	end
end

function CORPO.jarros_chao(m, ctx)
	local R, sc, ar = m.HumanoidRootPart, ctx.sc, ctx.ar
	local barro = rgb(132, 86, 58)
	local lista = { { -2.4, -2.2, 1.7, 1.3 }, { -0.4, -3.0, 2.1, 1.5 }, { 1.8, -2.4, 1.4, 1.1 }, { 2.9, -1.4, 1.0, 0.9 } }
	for i, j in ipairs(lista) do
		cil(m, R, "Pote" .. i, j[3] * sc, j[4] * sc, CF(j[1] * sc, -ar + j[3] * sc / 2, j[2] * sc), barro:Lerp(rgb(90, 60, 44), i * 0.08), Mat.Slate)
		cil(m, R, "PoteBoca" .. i, j[3] * sc * 0.25, j[4] * sc * 0.72, CF(j[1] * sc, -ar + j[3] * sc * 1.12, j[2] * sc), barro, Mat.Slate)
	end
end

local function itemDeMao(m, nome, lado, sc, inc)
	local mao = (lado == "E") and m.LeftHand or m.RightHand
	local sinal = (lado == "E") and -1 or 1
	local f = ITENS[nome]
	assert(f, "item de mao desconhecido: " .. tostring(nome))
	local antes = {}
	for _, c in ipairs(m:GetChildren()) do antes[c] = true end
	f(m, mao, sc, sinal)
	-- inc: gira o objeto inteiro em torno do punho (eixo X) para alinhar com a pose do braco
	if inc and inc ~= 0 then
		for _, c in ipairs(m:GetChildren()) do
			if not antes[c] then
				local w = c:FindFirstChildOfClass("Weld")
				if w then w.C0 = ang(inc, 0, 0) * w.C0 end
			end
		end
	end
end

-- ===================== montagem =====================
local PARAMS_CHAO = RaycastParams.new()
PARAMS_CHAO.FilterType = Enum.RaycastFilterType.Include

local function chaoEm(x, z)
	local v = workspace:FindFirstChild("Vila")
	local alvos = { workspace.Terrain }
	if v then
		for _, n in ipairs({ "Praca", "Pedras", "Pracas" }) do
			local f = v:FindFirstChild(n)
			if f then table.insert(alvos, f) end
		end
	end
	PARAMS_CHAO.FilterDescendantsInstances = alvos
	local melhor = nil
	for _, d in ipairs({ { 0, 0 }, { 0.9, 0 }, { -0.9, 0 }, { 0, 0.9 }, { 0, -0.9 } }) do
		local r = workspace:Raycast(V3(x + d[1], 60, z + d[2]), V3(0, -120, 0), PARAMS_CHAO)
		if r and (not melhor or r.Position.Y > melhor) then melhor = r.Position.Y end
	end
	return melhor or 0.6
end
M.chaoEm = chaoEm

function M.criar(spec, pasta)
	local esc = spec.esc or {}
	local m = criarRig(esc)
	m.Name = "NPC_" .. spec.id
	m.Parent = pasta

	-- medidas do corpo em repouso
	local footY = math.min(m.LeftFoot.Position.Y - m.LeftFoot.Size.Y / 2, m.RightFoot.Position.Y - m.RightFoot.Size.Y / 2)
	local ar = m.HumanoidRootPart.Position.Y - footY
	local quadrilY = (m.LowerTorso.CFrame * m.RightUpperLeg.RightHip.C0).Position.Y - footY
	local sc = esc.h or 1

	vestir(m, spec, quadrilY)
	if spec.cabelo then cabelo(m, spec.cabelo.estilo, spec.cabelo.cor) end
	if spec.chapeu then cobertura(m, spec.chapeu.tipo, spec.chapeu.cor) end

	local ctx = { sc = sc, ar = ar, hipY = quadrilY }
	for _, it in ipairs(spec.itens or {}) do
		if it.mao then
			itemDeMao(m, it.tipo, it.mao, sc, it.inc)
		else
			local f = CORPO[it.tipo]
			assert(f, "item de corpo desconhecido: " .. tostring(it.tipo))
			f(m, ctx)
		end
	end

	-- posicionamento no chao
	local px, pz = spec.pos.X, spec.pos.Y
	local gy = chaoEm(px, pz)
	local alvo = Vector3.new(px, gy + ar, pz)
	local mira = spec.mira or Vector2.new(0, 0)
	local olhar = Vector3.new(mira.X, alvo.Y, mira.Y)
	if (olhar - alvo).Magnitude < 0.1 then olhar = alvo + V3(0, 0, -1) end
	m:PivotTo(CFrame.lookAt(alvo, olhar))

	-- colisor invisivel (so para quem fica parado)
	if not spec.rota then
		local tam = (spec.colisor and spec.colisor.tam) or V3(2.2 * (esc.w or 1), 4.8 * sc, 1.8 * (esc.w or 1))
		local dy = (spec.colisor and spec.colisor.y) or 0
		local c = peca(m, m.HumanoidRootPart, "Colisor", tam, CF(0, dy, 0), rgb(255, 0, 255), Mat.SmoothPlastic)
		c.Transparency = 1
		c.CanCollide = true
	end

	-- alvo da conversa
	if spec.interativo then
		local al = peca(m, m.UpperTorso, "Alvo", V3(0.6, 0.6, 0.6), CF(0, 0.9 * sc + (spec.alvoY or 0), 0), rgb(255, 255, 255), Mat.SmoothPlastic)
		al.Transparency = 1
		local pp = Instance.new("ProximityPrompt")
		pp.Name = "Falar"
		pp.ActionText = "Conversar"
		pp.ObjectText = spec.nome
		pp.KeyboardKeyCode = Enum.KeyCode.E
		pp.GamepadKeyCode = Enum.KeyCode.ButtonX
		pp.HoldDuration = 0
		pp.MaxActivationDistance = 10
		pp.RequiresLineOfSight = false
		pp.Style = Enum.ProximityPromptStyle.Custom
		pp.Parent = al
	end

	-- dados lidos pelo cliente
	m:SetAttribute("NpcId", spec.id)
	m:SetAttribute("Nome", spec.nome)
	m:SetAttribute("Titulo", spec.titulo or "")
	m:SetAttribute("Papel", spec.papel or "")
	m:SetAttribute("Genero", spec.genero)
	m:SetAttribute("Idade", spec.idade)
	m:SetAttribute("Pose", spec.pose or "parado")
	m:SetAttribute("Interativo", spec.interativo and true or false)
	m:SetAttribute("AlturaRaiz", ar)
	m:SetAttribute("AlturaQuadril", quadrilY)
	m:SetAttribute("Escala", sc)
	if spec.rota then
		local pts = {}
		for _, p in ipairs(spec.rota) do table.insert(pts, string.format("%.1f,%.1f", p.X, p.Y)) end
		m:SetAttribute("Rota", table.concat(pts, ";"))
		m:SetAttribute("Velocidade", spec.vel or 3)
	end
	if spec.fase then m:SetAttribute("Fase", spec.fase) end
	return m
end

function M.limpar(pasta)
	pasta:ClearAllChildren()
end

return M
