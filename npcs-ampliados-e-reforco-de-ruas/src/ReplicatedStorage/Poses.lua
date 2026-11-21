-- Poses: animacao procedural dos NPCs (rig R15 com Motor6D) por Transform das juntas.
-- Angulos em graus. Convencoes verificadas (personagem olha para -Z, direita = +X):
--   ombro/quadril x+ : membro balanca para a frente;  cotovelo x+ : antebraco dobra para a frente;
--   joelho x- : canela dobra para tras;  cintura/pescoco x- : inclina para a frente / olha para baixo;
--   z em ombro/quadril = abducao (para fora); o lado esquerdo e espelhado aqui.
-- Formato de cada junta: { x, y, z, dy, dz } (dy/dz so na Raiz, em fracao da altura do quadril).

local Poses = {}
local rad = math.rad

local JUNTAS = {
	Raiz = { "LowerTorso", "Root" },
	Cint = { "UpperTorso", "Waist" },
	Pesc = { "Head", "Neck" },
	OmbE = { "LeftUpperArm", "LeftShoulder" }, OmbD = { "RightUpperArm", "RightShoulder" },
	CotE = { "LeftLowerArm", "LeftElbow" }, CotD = { "RightLowerArm", "RightElbow" },
	PunE = { "LeftHand", "LeftWrist" }, PunD = { "RightHand", "RightWrist" },
	QuaE = { "LeftUpperLeg", "LeftHip" }, QuaD = { "RightUpperLeg", "RightHip" },
	JoeE = { "LeftLowerLeg", "LeftKnee" }, JoeD = { "RightLowerLeg", "RightKnee" },
	TorE = { "LeftFoot", "LeftAnkle" }, TorD = { "RightFoot", "RightAnkle" },
}
local ESPELHA_Z = { OmbE = true, QuaE = true }
local ORDEM = { "Raiz", "Cint", "Pesc", "OmbE", "OmbD", "CotE", "CotD", "PunE", "PunD", "QuaE", "QuaD", "JoeE", "JoeD", "TorE", "TorD" }

-- ====================== definicoes ======================
-- dur: duracao do ciclo (s); base: pose de repouso; keys: { t(0..1), {juntas...}, ease }; marcha/balanco: ver passo()
local D = {}
Poses.def = D

D.parado = {
	dur = 5,
	base = { Cint = { -8 }, Pesc = { -14 }, OmbE = { 6, 0, 3 }, OmbD = { 6, 0, 3 }, CotE = { 16 }, CotD = { 16 } },
	keys = { { 0.5, { Cint = { -11 }, Pesc = { -18 }, OmbE = { 3, 0, 3 }, OmbD = { 3, 0, 3 } } } },
}

D.apoiado = {
	dur = 6,
	base = { Raiz = { 0, 0, 0, -0.03 }, Cint = { -26, 0, 4 }, Pesc = { 12 }, OmbD = { 26, 0, -8 }, CotD = { 28 }, OmbE = { -6, 0, 4 }, CotE = { 20 },
		QuaE = { 4 }, QuaD = { -4 }, JoeE = { -6 }, JoeD = { -14 } },
	keys = { { 0.5, { Cint = { -29, 0, 4 }, Pesc = { 14 }, OmbD = { 24, 0, -8 } } } },
}

D.guarda = {
	dur = 10,
	base = { Cint = { -9 }, Pesc = { -8 }, OmbD = { 10, 0, 6 }, CotD = { 35 }, OmbE = { 14, 0, -4 }, CotE = { 85 }, QuaD = { 3 }, JoeD = { -4 } },
	keys = { { 0.3, { Pesc = { -8, 24, 0 } } }, { 0.55, { Pesc = { -10, 0, 0 }, Cint = { -12 } } }, { 0.8, { Pesc = { -8, -22, 0 } } } },
}

D.enxada = {
	dur = 3.0,
	base = { Cint = { -10 }, Pesc = { -6 }, OmbD = { 105, 0, -18 }, OmbE = { 105, 0, -18 }, CotD = { 45 }, CotE = { 45 }, QuaD = { 6 }, QuaE = { 6 }, JoeD = { -8 }, JoeE = { -8 } },
	keys = {
		{ 0.45, { Cint = { -38 }, Pesc = { -10 }, OmbD = { 35, 0, -18 }, OmbE = { 35, 0, -18 }, CotD = { 22 }, CotE = { 22 }, QuaD = { 14 }, QuaE = { 14 }, JoeD = { -24 }, JoeE = { -24 }, Raiz = { 0, 0, 0, -0.05 } }, "in" },
		{ 0.62, { Cint = { -40 }, Pesc = { -10 }, OmbD = { 32, 0, -18 }, OmbE = { 32, 0, -18 }, CotD = { 22 }, CotE = { 22 }, QuaD = { 14 }, QuaE = { 14 }, JoeD = { -24 }, JoeE = { -24 }, Raiz = { 0, 0, 0, -0.05 } } },
		{ 0.85, { Cint = { -24 }, OmbD = { 80, 0, -18 }, OmbE = { 80, 0, -18 }, CotD = { 40 }, CotE = { 40 }, QuaD = { 9 }, QuaE = { 9 }, JoeD = { -14 }, JoeE = { -14 } } },
	},
}

D.pa = {
	dur = 3.6,
	base = { Cint = { -35 }, Pesc = { -8 }, OmbD = { 30, 0, -16 }, OmbE = { 30, 0, -16 }, CotD = { 15 }, CotE = { 15 }, QuaD = { 12 }, QuaE = { 12 }, JoeD = { -22 }, JoeE = { -22 } },
	keys = {
		{ 0.35, { Cint = { -15, -18, 0 }, OmbD = { 60, 0, -14 }, OmbE = { 60, 0, -14 }, CotD = { 55 }, CotE = { 55 }, QuaD = { 6 }, QuaE = { 6 }, JoeD = { -10 }, JoeE = { -10 } }, "out" },
		{ 0.6, { Cint = { -8, 34, 0 }, OmbD = { 75, 0, -14 }, OmbE = { 75, 0, -14 }, CotD = { 40 }, CotE = { 40 }, QuaD = { 6 }, QuaE = { 6 }, JoeD = { -10 }, JoeE = { -10 } } },
		{ 0.8, { Cint = { -20, 0, 0 }, OmbD = { 50, 0, -16 }, OmbE = { 50, 0, -16 } } },
	},
}

D.machado = {
	dur = 2.4,
	base = { Cint = { -6 }, Pesc = { -4 }, OmbD = { 120, 0, -14 }, OmbE = { 120, 0, -14 }, CotD = { 40 }, CotE = { 40 }, QuaD = { 6 }, QuaE = { 6 }, JoeD = { -6 }, JoeE = { -6 } },
	keys = {
		{ 0.4, { Cint = { -42 }, Pesc = { -10 }, OmbD = { 14, 0, -14 }, OmbE = { 14, 0, -14 }, CotD = { 15 }, CotE = { 15 }, QuaD = { 16 }, QuaE = { 16 }, JoeD = { -26 }, JoeE = { -26 }, Raiz = { 0, 0, 0, -0.06 } }, "in" },
		{ 0.55, { Cint = { -44 }, Pesc = { -10 }, OmbD = { 12, 0, -14 }, OmbE = { 12, 0, -14 }, CotD = { 15 }, CotE = { 15 }, QuaD = { 16 }, QuaE = { 16 }, JoeD = { -26 }, JoeE = { -26 }, Raiz = { 0, 0, 0, -0.06 } } },
		{ 0.8, { Cint = { -20 }, OmbD = { 70, 0, -14 }, OmbE = { 70, 0, -14 }, CotD = { 50 }, CotE = { 50 } } },
	},
}

D.vassoura = {
	dur = 1.8,
	base = { Cint = { -18, 14 }, Pesc = { -12 }, OmbD = { 38, 0, -14 }, OmbE = { 38, 0, -14 }, CotD = { 20 }, CotE = { 20 }, QuaD = { 5 }, QuaE = { 5 }, JoeD = { -8 }, JoeE = { -8 } },
	keys = { { 0.5, { Cint = { -20, -14 } } } },
}

local AJOELHADO = { Raiz = { 0, 0, 0, -0.50 }, QuaE = { 4 }, QuaD = { 4 }, JoeE = { -110 }, JoeD = { -110 }, TorE = { 30 }, TorD = { 30 } }
local function com(base, extra)
	local r = {}
	for k, v in pairs(base) do r[k] = v end
	for k, v in pairs(extra) do r[k] = v end
	return r
end

D.ajoelhado_reza = {
	dur = 5,
	base = com(AJOELHADO, { Cint = { -10 }, Pesc = { -32 }, OmbE = { 52, 0, -22 }, OmbD = { 52, 0, -22 }, CotE = { 105 }, CotD = { 105 } }),
	keys = { { 0.5, { Cint = { -15 }, Pesc = { -38 } } } },
}

D.ajoelhado_lava = {
	dur = 1.3,
	base = com(AJOELHADO, { Cint = { -28 }, Pesc = { -12 }, OmbE = { 58, 0, -8 }, OmbD = { 44, 0, -8 }, CotE = { 52 }, CotD = { 66 } }),
	keys = { { 0.5, { Cint = { -30 }, OmbE = { 44, 0, -8 }, OmbD = { 58, 0, -8 }, CotE = { 66 }, CotD = { 52 } } } },
}

D.lamentar = {
	dur = 2.6,
	base = com(AJOELHADO, { Cint = { -26 }, Pesc = { -40 }, OmbE = { 60, 0, -10 }, OmbD = { 60, 0, -10 }, CotE = { 140 }, CotD = { 140 } }),
	keys = { { 0.25, { Cint = { -29 }, Pesc = { -42 } } }, { 0.5, { Cint = { -26 } } }, { 0.75, { Cint = { -30 }, Pesc = { -43 } } } },
}

local SENTADO = { Raiz = { 0, 0, 0, -0.72 }, QuaE = { 90, 0, 8 }, QuaD = { 90, 0, 8 }, JoeE = { -8 }, JoeD = { -8 } }

D.sentado_joelhos = {
	dur = 1.7,
	base = { Raiz = { 0, 0, 0, -0.76 }, QuaE = { 105, 0, 6 }, QuaD = { 105, 0, 6 }, JoeE = { -115 }, JoeD = { -115 }, Cint = { -22 }, Pesc = { -28 }, OmbE = { 48, 0, -26 }, OmbD = { 48, 0, -26 }, CotE = { 110 }, CotD = { 110 } },
	keys = { { 0.5, { Raiz = { 0, 0, 0, -0.76 }, QuaE = { 105, 0, 6 }, QuaD = { 105, 0, 6 }, JoeE = { -115 }, JoeD = { -115 }, Cint = { -24 }, Pesc = { -30 }, OmbE = { 49, 0, -26 }, OmbD = { 49, 0, -26 }, CotE = { 110 }, CotD = { 110 } } } },
}

D.esmolar = {
	dur = 4,
	base = com(SENTADO, { Cint = { -14 }, Pesc = { -22 }, OmbD = { 40, 0, -8 }, CotD = { 45 }, OmbE = { 30, 0, -6 }, CotE = { 50 } }),
	keys = { { 0.5, { Cint = { -17 }, Pesc = { -25 }, OmbD = { 48, 0, -8 }, CotD = { 40 } } } },
}

D.costurar = {
	dur = 1.4,
	base = com(SENTADO, { Cint = { -16 }, Pesc = { -30 }, OmbD = { 40, 0, -24 }, OmbE = { 40, 0, -24 }, CotD = { 96 }, CotE = { 96 } }),
	keys = { { 0.5, { Cint = { -17 }, OmbD = { 46, 0, -24 }, OmbE = { 36, 0, -24 }, CotD = { 92 }, CotE = { 100 } } } },
}

D.boneca = {
	dur = 3.2,
	base = { Raiz = { 0, 0, 0, -0.72 }, QuaE = { 90, 0, 18 }, QuaD = { 90, 0, 18 }, JoeE = { -10 }, JoeD = { -10 }, Cint = { -10 }, Pesc = { -22 }, OmbD = { 40, 0, -30 }, OmbE = { 40, 0, -30 }, CotD = { 100 }, CotE = { 100 } },
	keys = { { 0.5, { Raiz = { 0, 0, 0, -0.72 }, QuaE = { 90, 0, 18 }, QuaD = { 90, 0, 18 }, JoeE = { -10 }, JoeD = { -10 }, Cint = { -4 }, Pesc = { -26 }, OmbD = { 40, 0, -30 }, OmbE = { 40, 0, -30 }, CotD = { 100 }, CotE = { 100 } } } },
}

local AGACHADO = { Raiz = { 0, 0, 0, -0.45 }, QuaE = { 95 }, QuaD = { 95 }, JoeE = { -120 }, JoeD = { -120 } }

D.agachado = {
	dur = 2.6,
	base = com(AGACHADO, { Cint = { -35 }, Pesc = { -15 }, OmbD = { 35 }, CotD = { 30 }, OmbE = { 25 }, CotE = { 25 } }),
	keys = { { 0.5, { Cint = { -48 }, OmbD = { 55 }, CotD = { 20 } } }, { 0.7, { Cint = { -46 }, OmbD = { 52 }, CotD = { 24 } } } },
}

D.desenhar = {
	dur = 1.2,
	base = com(AGACHADO, { Cint = { -40 }, Pesc = { -12 }, OmbD = { 62 }, CotD = { 24 }, OmbE = { 30 }, CotE = { 30 } }),
	keys = { { 0.5, { OmbD = { 46 }, CotD = { 34 } } } },
}

D.rezar_pe = {
	dur = 6,
	base = { Cint = { -6 }, Pesc = { -30 }, OmbE = { 50, 0, -24 }, OmbD = { 50, 0, -24 }, CotE = { 100 }, CotD = { 100 }, QuaD = { 2 } },
	keys = { { 0.5, { Cint = { -9 }, Pesc = { -34 } } } },
}

D.olhar_luz = {
	dur = 7,
	base = { Cint = { -4 }, Pesc = { 10 }, OmbE = { 4, 0, 4 }, OmbD = { 4, 0, 4 }, CotE = { 10 }, CotD = { 10 } },
	keys = { { 0.5, { Cint = { -6 }, Pesc = { 14 } } } },
}

-- ----- poses do elenco ampliado -----
D.cantar = {
	dur = 6,
	base = { Cint = { -2 }, Pesc = { 16 }, OmbE = { 46, 0, -20 }, OmbD = { 46, 0, -20 }, CotE = { 104 }, CotD = { 104 } },
	keys = { { 0.4, { Cint = { -4 }, Pesc = { 22 } } }, { 0.75, { Cint = { -1 }, Pesc = { 13 } } } },
}

D.ler = {
	dur = 6,
	base = { Cint = { -14 }, Pesc = { -34 }, OmbE = { 50, 0, -16 }, OmbD = { 50, 0, -16 }, CotE = { 96 }, CotD = { 96 } },
	keys = { { 0.5, { Pesc = { -38 } } }, { 0.8, { Pesc = { -34 }, OmbD = { 53, 0, -16 }, CotD = { 90 } } } },
}

D.tocar_alaude = {
	dur = 1.3,
	base = { Cint = { -6 }, Pesc = { -18 }, OmbE = { 52, 0, -8 }, CotE = { 84 }, OmbD = { 14, 0, -10 }, CotD = { 78 }, QuaD = { 3 } },
	keys = { { 0.5, { OmbD = { 22, 0, -10 }, CotD = { 70 }, Pesc = { -14 }, QuaD = { 0 } } } },
}

D.bandeja = {
	dur = 5,
	base = { Cint = { -6 }, Pesc = { -14 }, OmbE = { 46, 0, -8 }, OmbD = { 46, 0, -8 }, CotE = { 46 }, CotD = { 46 } },
	keys = { { 0.5, { Pesc = { -17 }, Cint = { -8 } } } },
}

D.luz_mao = {
	dur = 6,
	base = { Cint = { -6 }, Pesc = { -8 }, OmbD = { 46, 0, -6 }, CotD = { 58 }, OmbE = { 5, 0, 4 }, CotE = { 14 } },
	keys = { { 0.5, { OmbD = { 50, 0, -6 }, CotD = { 54 }, Pesc = { -10 } } } },
}

D.acender = {
	dur = 8,
	base = { Cint = { -4 }, Pesc = { 16 }, OmbD = { 36, 0, -8 }, CotD = { 52 }, OmbE = { 30, 0, -6 }, CotE = { 60 } },
	keys = {
		{ 0.4, { Cint = { -2 }, Pesc = { 24 }, OmbD = { 46, 0, -8 }, CotD = { 44 }, OmbE = { 40, 0, -6 }, CotE = { 50 } } },
		{ 0.7, { Cint = { -2 }, Pesc = { 24 }, OmbD = { 46, 0, -8 }, CotD = { 44 }, OmbE = { 40, 0, -6 }, CotE = { 50 } } },
	},
}

D.cambaleante = {
	dur = 4.2,
	base = { Cint = { -10 }, Pesc = { -10 }, OmbE = { 8, 0, 6 }, OmbD = { 10, 0, 8 }, CotE = { 20 }, CotD = { 30 }, QuaD = { 4 } },
	keys = {
		{ 0.25, { Raiz = { 0, 0, 5 }, Cint = { -12, 10, 6 }, Pesc = { -8, -12, 0 } } },
		{ 0.5, { Cint = { -8 } } },
		{ 0.75, { Raiz = { 0, 0, -5 }, Cint = { -12, -10, -6 }, Pesc = { -8, 12, 0 } } },
	},
}

-- ----- pose de cadeira alta -----
-- sentado_cadeira: a raiz NAO desce (nenhum dy): o NPC ja e posicionado na altura do assento. Quadril a 90 graus, pernas quase
-- estendidas com o tornozelo compensado (pe plano sobre um banquinho), tronco recostado e antebracos nos apoios de braco.
-- Medido por cinematica direta com o rig de altura 1,0 e largura 0,82; a cabeca olha devagar para um lado e para o outro.
D.sentado_cadeira = {
	dur = 9,
	base = { Cint = { 12 }, Pesc = { -12 }, QuaE = { 90, 0, 4 }, QuaD = { 90, 0, 4 }, JoeE = { -10 }, JoeD = { -10 }, TorE = { -80 }, TorD = { -80 },
		OmbE = { 20, 0, 6 }, OmbD = { 20, 0, 6 }, CotE = { 70 }, CotD = { 70 } },
	keys = {
		{ 0.28, { Cint = { 13 }, Pesc = { -14, 16, 0 } } },
		{ 0.52, { Cint = { 12 }, Pesc = { -12, 0, 0 } } },
		{ 0.78, { Cint = { 11 }, Pesc = { -13, -14, 0 }, CotD = { 66 } } },
	},
}

-- ----- poses de marcha: as pernas vem da marcha; marcha = true; balanco = "D"/"E"/true/false -----
D.marcha = {
	dur = 6, marcha = true, balanco = true,
	base = { Cint = { -14 }, Pesc = { -10 }, OmbE = { 0, 0, 3 }, OmbD = { 0, 0, 3 }, CotE = { 10 }, CotD = { 10 } },
}

D.marcha_saco = {
	dur = 6, marcha = true, balanco = "D",
	base = { Cint = { -18, 0, -3 }, Pesc = { -8 }, OmbE = { 96, 0, 32 }, CotE = { 125 }, OmbD = { 4, 0, 4 }, CotD = { 12 } },
}

D.marcha_cesto = {
	dur = 6, marcha = true, balanco = "D",
	base = { Cint = { -12 }, Pesc = { -10 }, OmbE = { 8, 0, 8 }, CotE = { 24 }, OmbD = { 0, 0, 3 }, CotD = { 10 } },
}

D.marcha_jarro = {
	dur = 6, marcha = true, balanco = "E",
	base = { Cint = { -12 }, Pesc = { -10 }, OmbD = { 8, 0, 8 }, CotD = { 24 }, OmbE = { 0, 0, 3 }, CotE = { 10 } },
}

D.marcha_baldes = {
	dur = 6, marcha = true, balanco = false,
	base = { Cint = { -12 }, Pesc = { -8 }, OmbD = { 2, 0, 12 }, OmbE = { 2, 0, 12 }, CotD = { 8 }, CotE = { 8 } },
}

D.marcha_carrinho = {
	dur = 6, marcha = true, balanco = false,
	base = { Cint = { -16 }, Pesc = { -12 }, OmbD = { 52, 0, -4 }, OmbE = { 52, 0, -4 }, CotD = { 14 }, CotE = { 14 } },
}

D.marcha_lenha_costas = {
	dur = 6, marcha = true, balanco = false,
	base = { Cint = { -28 }, Pesc = { -4 }, OmbD = { 12, 0, -8 }, OmbE = { 12, 0, -8 }, CotD = { 92 }, CotE = { 92 } },
}

D.marcha_lenha_braco = {
	dur = 6, marcha = true, balanco = false,
	base = { Cint = { -12 }, Pesc = { -10 }, OmbD = { 48, 0, -16 }, OmbE = { 48, 0, -16 }, CotD = { 62 }, CotE = { 62 } },
}

D.marcha_lanterna = {
	dur = 6, marcha = true, balanco = "E",
	base = { Cint = { -12 }, Pesc = { -10 }, OmbD = { 14, 0, 8 }, CotD = { 34 }, OmbE = { 0, 0, 3 }, CotE = { 10 } },
}

D.marcha_cajado = {
	dur = 6, marcha = true, balanco = "E",
	base = { Cint = { -10 }, Pesc = { -8 }, OmbD = { 16, 0, -4 }, CotD = { 26 }, OmbE = { 0, 0, 3 }, CotE = { 10 } },
}

-- ====================== motor ======================
local ZERO = { 0, 0, 0, 0, 0 }

local function copia(t)
	local r = {}
	for k, v in pairs(t) do r[k] = v end
	return r
end

local function compila(def)
	local chaves = {}
	table.insert(chaves, { t = 0, v = copia(def.base) })
	for _, k in ipairs(def.keys or {}) do
		local v = copia(def.base)
		for j, val in pairs(k[2]) do v[j] = val end
		table.insert(chaves, { t = k[1], v = v, e = k[3] })
	end
	table.sort(chaves, function(a, b) return a.t < b.t end)
	table.insert(chaves, { t = 1, v = chaves[1].v, e = nil })
	return chaves
end

local function ease(u, e)
	if e == "in" then return u * u
	elseif e == "out" then return 1 - (1 - u) * (1 - u)
	elseif e == "lin" then return u end
	return u * u * (3 - 2 * u)
end

local Classe = {}
Classe.__index = Classe

function Poses.novo(modelo, nomePose, fase)
	local def = D[nomePose] or D.parado
	local o = setmetatable({}, Classe)
	o.modelo = modelo
	o.def = def
	o.nome = nomePose
	o.quadril = modelo:GetAttribute("AlturaQuadril") or 2.2
	o.juntas = {}
	for nome, par in pairs(JUNTAS) do
		local p = modelo:FindFirstChild(par[1])
		local j = p and p:FindFirstChild(par[2])
		if j and j:IsA("Motor6D") then o.juntas[nome] = j end
	end
	o.chaves = compila(def)
	o.cur = {}
	for _, n in ipairs(ORDEM) do o.cur[n] = { 0, 0, 0, 0, 0 } end
	o.t = fase or 0
	o.passoMarcha = 0
	o.peso = 0
	o.olhar = 0
	o.alvoOlhar = 0
	-- atenção forçada (cenas): o tronco acompanha um pouco (alvoTronco, em graus) e o balanço de cabeça da pose diminui (alvoAtencao, 0 a 1)
	o.tronco = 0
	o.alvoTronco = 0
	o.atencao = 0
	o.alvoAtencao = 0
	return o
end

function Classe:amostra(frac)
	local ch = self.chaves
	local i = 1
	while i < #ch - 1 and frac > ch[i + 1].t do i += 1 end
	local a, b = ch[i], ch[i + 1]
	local span = b.t - a.t
	local u = span > 0 and (frac - a.t) / span or 0
	u = ease(math.clamp(u, 0, 1), b.e)
	for _, n in ipairs(ORDEM) do
		local va, vb = a.v[n] or ZERO, b.v[n] or ZERO
		local c = self.cur[n]
		for k = 1, 5 do
			local x, y = va[k] or 0, vb[k] or 0
			c[k] = x + (y - x) * u
		end
	end
end

local function aprox(v, alvo, passo)
	if v < alvo then return math.min(alvo, v + passo) end
	return math.max(alvo, v - passo)
end

-- vel: velocidade de caminhada em studs/s (0 = parado)
function Classe:passo(dt, vel)
	local def = self.def
	self.t += dt / def.dur
	self:amostra(self.t % 1)

	-- marcha
	local gQuaD, gQuaE, gJoeD, gJoeE, gOmbD, gOmbE, gDy, gRoll = 0, 0, 0, 0, 0, 0, 0, 0
	if def.marcha then
		self.peso = aprox(self.peso, (vel and vel > 0.25) and 1 or 0, dt * 4)
		if self.peso > 0 then
			self.passoMarcha += dt * (vel or 0) * 2.4
			local f = self.passoMarcha
			local w = self.peso
			local amp = 21 * math.clamp((vel or 2) / 3, 0.55, 1.1)
			local s1, s2 = math.sin(f), math.sin(f + math.pi)
			gQuaD, gQuaE = w * amp * s1, w * amp * s2
			gJoeD = -w * 34 * math.max(0, math.cos(f))
			gJoeE = -w * 34 * math.max(0, math.cos(f + math.pi))
			local b = def.balanco
			local ba = 11 * w
			if b == true or b == "D" then gOmbD = -ba * s1 end
			if b == true or b == "E" then gOmbE = -ba * s2 end
			gDy = w * 0.012 * math.abs(math.sin(f))
			gRoll = w * 2.2 * math.sin(f)
		end
	end

	-- cabeca acompanha quem esta perto
	-- (alisamento exponencial: o mesmo resultado a 13 ou a 60 quadros por segundo)
	self.olhar = self.olhar + (self.alvoOlhar - self.olhar) * (1 - math.exp(-dt * 4))
	self.tronco = self.tronco + (self.alvoTronco - self.tronco) * (1 - math.exp(-dt * 2.4))
	self.atencao = self.atencao + (self.alvoAtencao - self.atencao) * (1 - math.exp(-dt * 3))

	local q = self.quadril
	for nome, j in pairs(self.juntas) do
		local c = self.cur[nome]
		local x, y, z = c[1], c[2], c[3]
		if nome == "QuaD" then x += gQuaD
		elseif nome == "QuaE" then x += gQuaE
		elseif nome == "JoeD" then x += gJoeD
		elseif nome == "JoeE" then x += gJoeE
		elseif nome == "OmbD" then x += gOmbD
		elseif nome == "OmbE" then x += gOmbE
		elseif nome == "Pesc" then y = y * (1 - 0.8 * self.atencao) + self.olhar
		elseif nome == "Cint" then y += self.tronco
		end
		if ESPELHA_Z[nome] then z = -z end
		if nome == "Raiz" then
			j.Transform = CFrame.new(0, (c[4] + gDy) * q, c[5] * q) * CFrame.Angles(rad(x), rad(y), rad(z + gRoll))
		else
			j.Transform = CFrame.Angles(rad(x), rad(y), rad(z))
		end
	end
end

function Classe:zerar()
	for _, j in pairs(self.juntas) do j.Transform = CFrame.new() end
end

return Poses
