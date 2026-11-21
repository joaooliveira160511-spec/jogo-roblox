-- ElencoNPCs: os 30 NPCs da vila (10 homens, 10 mulheres, 10 criancas). Usado por ConstrutorNPCs.criar.
-- pos/mira em (x, z); rota = pontos (x, z) de vai-e-vem; inc = giro do objeto de mao (graus) para
-- alinhar a ferramenta com o braco na pose.

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local V2 = Vector2.new
local V3 = Vector3.new

-- peles
local PALIDA, CLARA, MORENA, PARDA, ESCURA = rgb(234, 184, 146), rgb(214, 168, 128), rgb(190, 140, 100), rgb(150, 104, 72), rgb(112, 78, 54)
-- tecidos (tons foscos e dessaturados)
local AVEIA, MARROM, CINZA, AZUL, MUSGO, FERRUGEM, LA, OCRE, LINHO = rgb(128, 112, 86), rgb(92, 72, 54), rgb(88, 88, 84), rgb(66, 80, 98), rgb(70, 80, 58), rgb(108, 64, 50), rgb(56, 50, 50), rgb(140, 116, 66), rgb(166, 154, 128)
-- cabelos
local PRETO, CASTANHO, CASTANHOC, GRISALHO, BRANCO, RUIVO = rgb(34, 28, 26), rgb(66, 48, 34), rgb(96, 70, 46), rgb(120, 116, 112), rgb(170, 166, 160), rgb(110, 58, 36)

local COURO_, CORDA_ = rgb(84, 62, 44), rgb(150, 126, 86)

local AJOELHADO = { tam = V3(2.4, 3.0, 2.6), y = -1.0 }
local SENTADO = { tam = V3(2.4, 2.4, 3.2), y = -1.5 }
local AGACHADO = { tam = V3(2.0, 2.4, 2.0), y = -1.0 }

local E = {}
local function add(t) table.insert(E, t) end

-- ===================== HOMENS =====================
add { id = "tobias", nome = "Velho Tobias", titulo = "Lavrador", genero = "H", idade = "idoso", interativo = true,
	pos = V2(95, 62), mira = V2(95, 30), pele = CLARA, face = "idoso", esc = { h = 0.97, w = 0.82 },
	roupa = { camisa = AVEIA, calca = MARROM, mangaCurta = true, sujo = "torso1", remendos = 2 },
	cabelo = { estilo = "calvo", cor = BRANCO }, chapeu = { tipo = "palha", cor = rgb(150, 128, 86) },
	pose = "enxada", itens = { { tipo = "enxada", mao = "D", inc = -90 } } }

add { id = "heitor", nome = "Heitor", titulo = "Coveiro", genero = "H", idade = "adulto", interativo = true,
	pos = V2(14, -42), mira = V2(14, -60), pele = MORENA, face = "homem3", esc = { h = 1.02, w = 0.9 },
	roupa = { camisa = CINZA, calca = LA, mangaCurta = true, sujo = "torso2", botas = rgb(48, 40, 34), colete = COURO_ },
	cabelo = { estilo = "curto", cor = PRETO },
	pose = "pa", itens = { { tipo = "pa", mao = "D", inc = -95 }, { tipo = "cova" } } }

add { id = "anselmo", nome = "Anselmo", titulo = "Carregador de água", genero = "H", idade = "adulto", interativo = false,
	pos = V2(-192.4, -132), pele = PARDA, face = "homem2", esc = { h = 1.0, w = 0.84 },
	roupa = { camisa = AZUL, calca = MARROM, mangaCurta = true, sujo = "torso1" },
	cabelo = { estilo = "curto", cor = CASTANHO },
	rota = { V2(-192.4, -132), V2(-192.4, -68) }, vel = 2.0,
	pose = "marcha_baldes", itens = { { tipo = "balde", mao = "D" }, { tipo = "balde", mao = "E" } } }

add { id = "bartolomeu", nome = "Bartolomeu", titulo = "Carroceiro", genero = "H", idade = "adulto", interativo = false,
	pos = V2(-96, -206.6), pele = CLARA, face = "homem1", esc = { h = 1.04, w = 0.92 },
	roupa = { camisa = MUSGO, calca = LA, mangaCurta = true, sujo = "torso2", cintoCor = COURO_ },
	cabelo = { estilo = "rebelde", cor = RUIVO }, chapeu = { tipo = "boina", cor = rgb(70, 62, 52) },
	rota = { V2(-96, -206.6), V2(-160, -206.6) }, vel = 1.9,
	pose = "marcha_carrinho", itens = { { tipo = "carrinho" } } }

add { id = "orlando", nome = "Orlando", titulo = "Moleiro", genero = "H", idade = "adulto", interativo = false,
	pos = V2(128, 192.4), pele = PALIDA, face = "homem4", esc = { h = 0.98, w = 0.86 },
	roupa = { camisa = LINHO, calca = CINZA, mangaCurta = true, sujo = "torso1" },
	cabelo = { estilo = "curto", cor = GRISALHO },
	rota = { V2(128, 192.4), V2(48, 192.4) }, vel = 2.0,
	pose = "marcha_saco", itens = { { tipo = "saco_ombro" } } }

add { id = "gaspar", nome = "Gaspar", titulo = "Soldado reformado", genero = "H", idade = "adulto", interativo = true,
	pos = V2(27, 43), mira = V2(0, 44), pele = ESCURA, face = "homem4", esc = { h = 1.0, w = 0.8 },
	roupa = { camisa = FERRUGEM, calca = MARROM, sujo = "torso2", remendos = 3, cinto = false },
	cabelo = { estilo = "curto", cor = GRISALHO },
	colisor = SENTADO, alvoY = -1.2,
	pose = "esmolar", itens = { { tipo = "tigela", mao = "D", inc = -85 } } }

add { id = "ambrosio", nome = "Ambrósio", titulo = "Lenhador", genero = "H", idade = "adulto", interativo = false,
	pos = V2(-92, 3), mira = V2(-92, -20), pele = MORENA, face = "homem1", esc = { h = 1.06, w = 0.94 },
	roupa = { camisa = OCRE, calca = MARROM, mangaCurta = true, sujo = "torso1", colete = COURO_ },
	cabelo = { estilo = "curto", cor = CASTANHO },
	pose = "machado", itens = { { tipo = "machado", mao = "D", inc = -80 }, { tipo = "toco" } } }

add { id = "leonidas", nome = "Frei Leonidas", titulo = "Frade", genero = "H", idade = "adulto", interativo = true,
	pos = V2(-9, 39), mira = V2(0, 0), pele = PALIDA, face = "homem2", esc = { h = 0.98, w = 0.84 },
	roupa = { camisa = rgb(84, 66, 48), habito = true, cintoCor = CORDA_, sujo = "torso1" },
	cabelo = { estilo = "calvo", cor = CASTANHO }, chapeu = { tipo = "capuz", cor = rgb(84, 66, 48) },
	colisor = AJOELHADO, alvoY = -1.2,
	pose = "ajoelhado_reza" }

add { id = "cassio", nome = "Cássio", titulo = "Feirante", genero = "H", idade = "adulto", interativo = true,
	pos = V2(-31.4, 31.4), mira = V2(-41, 41), pele = CLARA, face = "homem3", esc = { h = 0.99, w = 0.82 },
	roupa = { camisa = LINHO, calca = LA, mangaCurta = true, avental = rgb(150, 136, 110), sujo = "torso2" },
	cabelo = { estilo = "curto", cor = PRETO },
	pose = "parado", itens = { { tipo = "caixa_vazia" } } }

add { id = "rufino", nome = "Rufino", titulo = "Guarda", genero = "H", idade = "adulto", interativo = true,
	pos = V2(-7, 62), mira = V2(0, 0), pele = MORENA, face = "homem4", esc = { h = 1.05, w = 0.86 },
	roupa = { camisa = rgb(70, 66, 62), calca = rgb(56, 54, 52), colete = rgb(60, 50, 40), botas = rgb(44, 38, 32), sujo = "torso1" },
	cabelo = { estilo = "curto", cor = PRETO }, chapeu = { tipo = "gorro", cor = rgb(70, 66, 60) },
	pose = "guarda", itens = { { tipo = "lanca", mao = "D", inc = -45 } } }

-- ===================== MULHERES =====================
add { id = "marta", nome = "Marta", titulo = "Viúva", genero = "M", idade = "adulto", interativo = true,
	pos = V2(-24, 44), mira = V2(0, 0), pele = PALIDA, face = "mulher1", esc = { h = 0.95, w = 0.82 },
	roupa = { camisa = rgb(40, 38, 42), vestido = rgb(44, 42, 48), xale = rgb(30, 28, 32), sujo = "torso2" },
	cabelo = { estilo = "longo", cor = CASTANHO }, chapeu = { tipo = "lenco", cor = rgb(54, 50, 54) },
	colisor = AJOELHADO, alvoY = -1.2,
	pose = "lamentar" }

add { id = "eulalia", nome = "Dona Eulália", titulo = "Curandeira", genero = "M", idade = "adulto", interativo = true,
	pos = V2(-12, -46), mira = V2(0, 0), pele = CLARA, face = "mulher2", esc = { h = 0.96, w = 0.84 },
	roupa = { camisa = MUSGO, vestido = rgb(76, 84, 64), xale = rgb(92, 76, 56), sujo = "torso1" },
	cabelo = { estilo = "coque", cor = GRISALHO }, chapeu = { tipo = "lenco", cor = rgb(150, 138, 108) },
	pose = "parado", itens = { { tipo = "cesto", mao = "E" } } }

add { id = "berenice", nome = "Berenice", titulo = "Lavadeira", genero = "M", idade = "adulto", interativo = true,
	pos = V2(-44, 18), mira = V2(0, 0), pele = PARDA, face = "mulher4", esc = { h = 0.97, w = 0.86 },
	roupa = { camisa = AZUL, vestido = rgb(74, 84, 100), mangaCurta = true, sujo = "torso2" },
	cabelo = { estilo = "coque", cor = PRETO }, chapeu = { tipo = "lenco", cor = LINHO },
	colisor = AJOELHADO, alvoY = -1.2,
	pose = "ajoelhado_lava", itens = { { tipo = "bacia" }, { tipo = "pano", mao = "D" } } }

add { id = "sidonia", nome = "Sidonia", titulo = "Padeira", genero = "M", idade = "adulto", interativo = true,
	pos = V2(44, -18), mira = V2(0, 0), pele = PALIDA, face = "mulher3", esc = { h = 0.96, w = 0.9 },
	roupa = { camisa = LINHO, vestido = rgb(150, 136, 112), xale = rgb(104, 84, 62), sujo = "torso1" },
	cabelo = { estilo = "curto", cor = RUIVO }, chapeu = { tipo = "lenco", cor = rgb(176, 166, 140) },
	pose = "olhar_luz", itens = { { tipo = "caixa_vazia" } } }

add { id = "ines", nome = "Inês", titulo = "Mãe", genero = "M", idade = "adulto", interativo = true,
	pos = V2(50, 14), mira = V2(0, 0), pele = MORENA, face = "mulher3", esc = { h = 0.95, w = 0.78 },
	roupa = { camisa = FERRUGEM, vestido = rgb(96, 70, 62), xale = rgb(74, 66, 60), sujo = "torso1" },
	cabelo = { estilo = "tranca", cor = PRETO },
	pose = "olhar_luz" }

add { id = "albertina", nome = "Albertina", titulo = "Costureira", genero = "M", idade = "adulto", interativo = true,
	pos = V2(46, -28), mira = V2(0, 0), pele = CLARA, face = "mulher2", esc = { h = 0.95, w = 0.84 },
	roupa = { camisa = OCRE, vestido = rgb(120, 100, 72), mangaCurta = true, sujo = "torso2" },
	cabelo = { estilo = "longo", cor = CASTANHOC }, chapeu = { tipo = "lenco", cor = rgb(140, 120, 96) },
	colisor = SENTADO, alvoY = -1.2,
	pose = "costurar", itens = { { tipo = "agulha", mao = "D" } } }

add { id = "ludmila", nome = "Ludmila", titulo = "Taberneira", genero = "M", idade = "adulto", interativo = true,
	pos = V2(-48, 30), mira = V2(-48, 10), pele = PARDA, face = "mulher4", esc = { h = 0.98, w = 0.9 },
	roupa = { camisa = LINHO, vestido = rgb(112, 70, 60), xale = rgb(70, 60, 54), sujo = "torso1" },
	cabelo = { estilo = "tranca", cor = PRETO },
	pose = "vassoura", itens = { { tipo = "vassoura", mao = "D", inc = -93 } } }

add { id = "cecilia", nome = "Cecília", titulo = "Aguadeira", genero = "M", idade = "adulto", interativo = false,
	pos = V2(144, 6.6), pele = PALIDA, face = "mulher1", esc = { h = 0.94, w = 0.8 },
	roupa = { camisa = AZUL, vestido = rgb(80, 90, 108), sujo = "torso2" },
	cabelo = { estilo = "tranca", cor = CASTANHOC }, chapeu = { tipo = "lenco", cor = LINHO },
	rota = { V2(144, 6.6), V2(224, 6.6) }, vel = 2.0,
	pose = "marcha_jarro", itens = { { tipo = "jarro", mao = "D" } } }

add { id = "josefa", nome = "Josefa", titulo = "Camponesa", genero = "M", idade = "adulto", interativo = false,
	pos = V2(160, -7.6), pele = MORENA, face = "mulher2", esc = { h = 0.95, w = 0.88 },
	roupa = { camisa = LINHO, vestido = rgb(100, 82, 60), xale = rgb(66, 74, 56), sujo = "torso1" },
	cabelo = { estilo = "coque", cor = PRETO }, chapeu = { tipo = "lenco", cor = rgb(150, 136, 108) },
	rota = { V2(160, -7.6), V2(96, -7.6) }, vel = 1.9,
	pose = "marcha_cesto", itens = { { tipo = "cesto", mao = "E" } } }

-- ===================== CRIANCAS =====================
local function crianca(t)
	t.genero = "C"
	t.idade = "crianca"
	t.esc = t.esc or { h = 0.66, w = 0.8, cab = 1.25 }
	return t
end

add(crianca { id = "pedrinho", nome = "Pedrinho", titulo = "Menino", interativo = true,
	pos = V2(7.5, 40.5), mira = V2(30, 40), pele = CLARA, face = "crianca2",
	roupa = { camisa = AVEIA, calca = MARROM, mangaCurta = true, sujo = "torso1", cinto = false },
	cabelo = { estilo = "rebelde", cor = CASTANHOC },
	colisor = { tam = V3(1.6, 2.0, 1.6), y = -0.8 }, alvoY = -0.8,
	pose = "desenhar", itens = { { tipo = "graveto", mao = "D", inc = -130 } } })

add(crianca { id = "clarinha", nome = "Clarinha", titulo = "Menina", interativo = true,
	pos = V2(28, -44), mira = V2(0, 0), pele = PALIDA, face = "crianca1",
	roupa = { camisa = rgb(120, 96, 90), vestido = rgb(106, 90, 96), sujo = "torso2", cinto = false },
	cabelo = { estilo = "tranca", cor = CASTANHO },
	colisor = { tam = V3(1.8, 1.8, 2.4), y = -1.0 }, alvoY = -0.8,
	pose = "boneca", itens = { { tipo = "boneca" } } })

add(crianca { id = "tome", nome = "Tomé", titulo = "Órfão", interativo = true,
	pos = V2(-6, -63), mira = V2(0, 0), pele = PARDA, face = "crianca2", esc = { h = 0.7, w = 0.76, cab = 1.22 },
	roupa = { camisa = CINZA, calca = LA, mangaCurta = true, sujo = "torso1", cinto = false },
	cabelo = { estilo = "curto", cor = PRETO },
	pose = "parado", itens = { { tipo = "balde", mao = "E" } } })

add(crianca { id = "lia", nome = "Lia", titulo = "Menina", interativo = true,
	pos = V2(-26, -44), mira = V2(-26, -30), pele = MORENA, face = "crianca3",
	roupa = { camisa = FERRUGEM, vestido = rgb(104, 70, 60), mangaCurta = true, sujo = "torso1", cinto = false },
	cabelo = { estilo = "tranca", cor = PRETO },
	colisor = AGACHADO, alvoY = -0.8,
	pose = "agachado" })

add(crianca { id = "davi", nome = "Davi", titulo = "Menino", interativo = false,
	pos = V2(76, -193.4), pele = PARDA, face = "crianca3", esc = { h = 0.72, w = 0.8, cab = 1.2 },
	roupa = { camisa = MUSGO, calca = MARROM, mangaCurta = true, sujo = "torso2", cinto = false },
	cabelo = { estilo = "rebelde", cor = PRETO },
	rota = { V2(76, -193.4), V2(156, -193.4) }, vel = 1.6,
	pose = "marcha_lenha_costas", itens = { { tipo = "feixe_costas" } } })

add(crianca { id = "nico", nome = "Nico", titulo = "Menino", interativo = false,
	pos = V2(-47, -20), mira = V2(0, 0), pele = CLARA, face = "crianca4",
	roupa = { camisa = AVEIA, calca = LA, mangaCurta = true, sujo = "torso1", cinto = false },
	cabelo = { estilo = "curto", cor = CASTANHOC },
	colisor = { tam = V3(1.8, 1.8, 1.8), y = -1.0 },
	pose = "sentado_joelhos" })

add(crianca { id = "nina", nome = "Nina", titulo = "Menina", interativo = false,
	pos = V2(-45, -23), mira = V2(0, 0), pele = CLARA, face = "crianca1",
	roupa = { camisa = rgb(110, 92, 84), vestido = rgb(96, 84, 88), mangaCurta = true, sujo = "torso2", cinto = false },
	cabelo = { estilo = "tranca", cor = CASTANHOC },
	colisor = { tam = V3(1.8, 1.8, 1.8), y = -1.0 },
	pose = "sentado_joelhos", fase = 0.4 })

add(crianca { id = "rosa", nome = "Rosa", titulo = "Menina", interativo = true,
	pos = V2(12.5, 46), mira = V2(9, 49), pele = PALIDA, face = "crianca3",
	roupa = { camisa = rgb(116, 100, 92), vestido = rgb(100, 88, 92), sujo = "torso1", cinto = false },
	cabelo = { estilo = "longo", cor = CASTANHO },
	pose = "rezar_pe" })

add(crianca { id = "zeca", nome = "Zeca", titulo = "Menino", interativo = true,
	pos = V2(70, 8), mira = V2(78, 14), pele = MORENA, face = "crianca2", esc = { h = 0.68, w = 0.78, cab = 1.25 },
	roupa = { camisa = AZUL, calca = MARROM, mangaCurta = true, sujo = "torso2", cinto = false },
	cabelo = { estilo = "rebelde", cor = PRETO },
	colisor = AGACHADO, alvoY = -0.8,
	pose = "agachado", itens = { { tipo = "graveto", mao = "D", inc = -110 } } })

add(crianca { id = "beto", nome = "Beto", titulo = "Menino", interativo = false,
	pos = V2(207.6, 32), pele = ESCURA, face = "crianca4", esc = { h = 0.7, w = 0.8, cab = 1.22 },
	roupa = { camisa = LINHO, calca = LA, mangaCurta = true, sujo = "torso1", cinto = false },
	cabelo = { estilo = "curto", cor = PRETO },
	rota = { V2(207.6, 32), V2(207.6, 112) }, vel = 1.7,
	pose = "marcha_lenha_braco", itens = { { tipo = "lenha_frente" } } })

-- ===================== posicoes, feirantes, caminhantes e elenco sorteado =====================
local SS = game:GetService("ServerStorage")
local Pos = require(SS.PosicoesNPC)
local Gerador = require(SS.GeradorNPCs)

-- posicoes sorteadas e validadas (longe das ruas e sem objetos na frente) para quem ja existia
for _, spec in ipairs(E) do
	local p = Pos[spec.id]
	if p and not spec.rota then
		spec.pos = V2(p.x, p.z)
		spec.mira = V2(p.mx, p.mz)
	end
end
-- quem anda ja olha para o segundo ponto da rota
for _, spec in ipairs(E) do
	if spec.rota then spec.mira = spec.rota[2] end
end

-- feirantes das outras tres barracas (frente da barraca = direcao do olhar; o feirante fica atras do balcao)
local BARRACAS = {
	{ id = "feira1", papel = "feirante", nome = "Hilário", c = V2(33.2, 33.2), l = V2(0.707, 0.707) },
	{ id = "feira2", papel = "feirante_f", nome = "Anselma", c = V2(33.2, -33.2), l = V2(0.707, -0.707) },
	{ id = "feira3", papel = "feirante", nome = "Dionísio", c = V2(-33.2, -33.2), l = V2(-0.707, -0.707) },
}
for _, b in ipairs(BARRACAS) do
	local sp = Gerador.spec(b.id, { x = b.c.X - b.l.X * 2.6, z = b.c.Y - b.l.Y * 2.6, mx = b.c.X + b.l.X * 10, mz = b.c.Y + b.l.Y * 10 }, b.papel, { interativo = true })
	sp.nome = b.nome
	table.insert(E, sp)
end

-- caminhantes novos pelas ruas (sempre rente a calcada)
local function caminhante(id, papel, rota, vel, pose, itens, tit)
	local sp = Gerador.spec(id, { x = rota[1].X, z = rota[1].Y, mx = rota[2].X, mz = rota[2].Y }, papel, { interativo = false })
	sp.pose, sp.itens, sp.rota, sp.vel, sp.colisor, sp.alvoY = pose, itens, rota, vel, nil, nil
	sp.titulo = tit
	return sp
end
table.insert(E, caminhante("carreg1", "lavrador", { V2(206.6, -160), V2(206.6, -92) }, 2.0, "marcha_saco", { { tipo = "saco_ombro" } }, "Carregador"))
table.insert(E, caminhante("aguad2", "camponesa", { V2(-164, -6.6), V2(-88, -6.6) }, 1.9, "marcha_jarro", { { tipo = "jarro", mao = "D" } }, "Aguadeira"))
table.insert(E, caminhante("lenha3", "menino_agacha", { V2(-6.6, 160), V2(-6.6, 96) }, 1.6, "marcha_lenha_costas", { { tipo = "feixe_costas" } }, "Menino"))
table.insert(E, caminhante("carro4", "lavrador", { V2(192.4, -132), V2(192.4, -56) }, 1.8, "marcha_carrinho", { { tipo = "carrinho" } }, "Carroceiro"))
table.insert(E, caminhante("carreg5", "lavrador", { V2(-207.6, -32), V2(-207.6, -104) }, 1.9, "marcha_saco", { { tipo = "saco_ombro" } }, "Carregador"))

-- caminhantes do elenco ampliado (ruas laterais e trechos iluminados, escolhidos por ServerStorage.RotasNPC)
table.insert(E, caminhante("wperegrino", "peregrino", { V2(-207.6, 96), V2(-207.6, 172) }, 1.6, "marcha_cajado", { { tipo = "cajado", mao = "D", inc = -42 }, { tipo = "mochila" } }, "Peregrino"))
table.insert(E, caminhante("wlanterneira", "lanterneira", { V2(7.6, -208), V2(7.6, -140) }, 1.7, "marcha_lanterna", { { tipo = "lanterna", mao = "D", inc = -48 } }, "Lanterneira"))
table.insert(E, caminhante("wacendedor", "acendedor", { V2(-84, 192.4), V2(-148, 192.4) }, 1.8, "marcha_cajado", { { tipo = "vara_acendedor", mao = "D", inc = -42 } }, "Acendedor de lampiões"))
table.insert(E, caminhante("wmensageiro", "mensageiro", { V2(168, 207.6), V2(96, 207.6) }, 2.4, "marcha", { { tipo = "mochila" } }, "Mensageiro"))
table.insert(E, caminhante("wcarregador", "lavrador", { V2(-48, 206.6), V2(-120, 206.6) }, 1.9, "marcha_saco", { { tipo = "saco_ombro" } }, "Carregador"))
table.insert(E, caminhante("wcamponesa", "camponesa", { V2(-152, 6.6), V2(-232, 6.6) }, 1.8, "marcha_cesto", { { tipo = "cesto", mao = "E" } }, "Camponesa"))

-- elenco sorteado (unicos novos e genericos)
for _, sp in ipairs(Gerador.todos()) do table.insert(E, sp) end

return E
