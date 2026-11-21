-- PapeisNPC: papeis (ofícios e situacoes) dos NPCs da vila. Cada papel diz o genero, a pose, os objetos
-- de mao, o colisor e a area livre necessaria a frente (foot: caixas {cx, cz, sx, sz} no espaco local do NPC,
-- onde -Z e a frente). `pool` escolhe os dialogos genericos em Dialogos.papel[pool].
local V3 = Vector3.new

local AJOELHADO = { tam = V3(2.4, 3.0, 2.6), y = -1.0 }
local SENTADO = { tam = V3(2.4, 2.4, 3.2), y = -1.5 }
local AGACHADO = { tam = V3(2.0, 2.4, 2.0), y = -1.0 }
local CRIANCA_BAIXA = { tam = V3(1.8, 1.8, 1.8), y = -1.0 }

local FERRAMENTA = { { cx = 0, cz = -3.2, sx = 3.6, sz = 5 } }

local P = {}

-- ----- homens -----
P.lavrador = { g = "H", idade = "adulto", titulo = "Lavrador", pose = "enxada", itens = { { tipo = "enxada", mao = "D", inc = -90 } }, foot = FERRAMENTA, chapeuProb = 0.7, chapeuTipos = { "palha" } }
P.lenhador = { g = "H", idade = "adulto", titulo = "Lenhador", pose = "machado", itens = { { tipo = "machado", mao = "D", inc = -80 }, { tipo = "toco" } }, foot = { { cx = 0, cz = -3.3, sx = 6.2, sz = 5.4 } }, colete = true }
P.coveiro = { g = "H", idade = "adulto", titulo = "Coveiro", pose = "pa", itens = { { tipo = "pa", mao = "D", inc = -95 }, { tipo = "cova" } }, foot = { { cx = -4, cz = -3.4, sx = 18, sz = 7.4 } }, colete = true }
P.pastor = { g = "H", idade = "adulto", titulo = "Pastor", pose = "apoiado", itens = { { tipo = "cajado", mao = "D", inc = -54 } }, foot = { { cx = 0, cz = -1.5, sx = 3, sz = 3 } }, chapeuProb = 0.5, chapeuTipos = { "boina", "palha" } }
P.guarda = { g = "H", idade = "adulto", titulo = "Guarda", pose = "guarda", itens = { { tipo = "lanca", mao = "D", inc = -45 } }, foot = { { cx = 0, cz = -1.5, sx = 3, sz = 3 } }, chapeuProb = 0.8, chapeuTipos = { "gorro" }, colete = true, botas = true }
P.mendigo = { g = "H", idade = "adulto", titulo = "Mendigo", pose = "esmolar", itens = { { tipo = "tigela", mao = "D", inc = -85 } }, colisor = SENTADO, alvoY = -1.2, foot = { { cx = 0, cz = -1, sx = 3.4, sz = 3.4 } }, rasgado = true }
P.doente = { g = "H", idade = "adulto", titulo = "Doente", pose = "sentado_joelhos", itens = {}, colisor = SENTADO, alvoY = -1.2, foot = { { cx = 0, cz = -1, sx = 3.4, sz = 3.4 } } }
P.monge = { g = "H", idade = "adulto", titulo = "Frade", pose = "ajoelhado_reza", itens = {}, colisor = AJOELHADO, alvoY = -1.2, habito = true, foot = { { cx = 0, cz = -1.2, sx = 3.2, sz = 3.4 } } }
P.sineiro = { g = "H", idade = "adulto", titulo = "Sineiro", pose = "olhar_luz", itens = {}, foot = {} }
P.ferreiro = { g = "H", idade = "adulto", titulo = "Ferreiro", pose = "parado", itens = {}, avental = true, foot = {} }
P.escrivao = { g = "H", idade = "adulto", titulo = "Escrivão", pose = "parado", itens = {}, foot = {}, boina = true }
P.vigia = { g = "H", idade = "adulto", titulo = "Vigia", pose = "olhar_luz", itens = {}, foot = {}, chapeuProb = 0.6, chapeuTipos = { "gorro" } }
P.pedreiro = { g = "H", idade = "adulto", titulo = "Pedreiro", pose = "apoiado", itens = {}, foot = {}, colete = true }
P.feirante = { g = "H", idade = "adulto", titulo = "Feirante", pose = "parado", itens = { { tipo = "caixa_vazia" } }, avental = true, foot = {} }
P.feirante_f = { g = "M", idade = "adulto", titulo = "Feirante", pose = "parado", itens = { { tipo = "caixa_vazia" } }, avental = true, foot = {}, pool = "feirante" }
P.velho = { g = "H", idade = "idoso", titulo = "Velho", pose = "apoiado", itens = { { tipo = "cajado", mao = "D", inc = -54 } }, foot = { { cx = 0, cz = -1.5, sx = 3, sz = 3 } }, chapeuProb = 0.6, chapeuTipos = { "boina", "palha" } }

-- ----- mulheres -----
P.lavadeira = { g = "M", idade = "adulto", titulo = "Lavadeira", pose = "ajoelhado_lava", itens = { { tipo = "bacia" }, { tipo = "pano", mao = "D" } }, colisor = AJOELHADO, alvoY = -1.2, foot = { { cx = 0, cz = -2.2, sx = 3.6, sz = 4.2 } } }
P.costureira = { g = "M", idade = "adulto", titulo = "Costureira", pose = "costurar", itens = { { tipo = "agulha", mao = "D" } }, colisor = SENTADO, alvoY = -1.2, foot = { { cx = 0, cz = -1, sx = 3.6, sz = 3.6 } } }
P.viuva = { g = "M", idade = "adulto", titulo = "Viúva", pose = "lamentar", itens = {}, colisor = AJOELHADO, alvoY = -1.2, luto = true, foot = { { cx = 0, cz = -1.2, sx = 3.4, sz = 3.4 } } }
P.mae = { g = "M", idade = "adulto", titulo = "Mãe", pose = "olhar_luz", itens = {}, foot = {} }
P.varredora = { g = "M", idade = "adulto", titulo = "Varredora", pose = "vassoura", itens = { { tipo = "vassoura", mao = "D", inc = -93 } }, foot = FERRAMENTA }
P.parteira = { g = "M", idade = "adulto", titulo = "Parteira", pose = "parado", itens = { { tipo = "cesto", mao = "E" } }, foot = {} }
P.rezadeira = { g = "M", idade = "adulto", titulo = "Rezadeira", pose = "rezar_pe", itens = {}, foot = {}, luto = true }
P.camponesa = { g = "M", idade = "adulto", titulo = "Camponesa", pose = "parado", itens = { { tipo = "cesto", mao = "E" } }, foot = {} }

-- ----- criancas -----
P.menino_desenha = { g = "C", sub = "m", idade = "crianca", titulo = "Menino", pose = "desenhar", itens = { { tipo = "graveto", mao = "D", inc = -130 } }, colisor = { tam = V3(1.6, 2.0, 1.6), y = -0.8 }, alvoY = -0.8, foot = { { cx = 0, cz = -1.5, sx = 3, sz = 3 } } }
P.menina_boneca = { g = "C", sub = "f", idade = "crianca", titulo = "Menina", pose = "boneca", itens = { { tipo = "boneca" } }, colisor = { tam = V3(1.8, 1.8, 2.4), y = -1.0 }, alvoY = -0.8, foot = { { cx = 0, cz = -1.4, sx = 3, sz = 3 } } }
P.menino_agacha = { g = "C", sub = "m", idade = "crianca", titulo = "Menino", pose = "agachado", itens = { { tipo = "graveto", mao = "D", inc = -110 } }, colisor = AGACHADO, alvoY = -0.8, foot = { { cx = 0, cz = -1.5, sx = 3, sz = 3 } } }
P.menina_agacha = { g = "C", sub = "f", idade = "crianca", titulo = "Menina", pose = "agachado", itens = {}, colisor = AGACHADO, alvoY = -0.8, foot = { { cx = 0, cz = -1.2, sx = 3, sz = 3 } } }
P.crianca_sentada = { g = "C", sub = "x", idade = "crianca", titulo = "Criança", pose = "sentado_joelhos", itens = {}, colisor = CRIANCA_BAIXA, alvoY = -0.8, foot = { { cx = 0, cz = -1, sx = 3, sz = 3 } } }
P.crianca_balde = { g = "C", sub = "x", idade = "crianca", titulo = "Criança", pose = "parado", itens = { { tipo = "balde", mao = "E" } }, foot = {} }
P.crianca_reza = { g = "C", sub = "f", idade = "crianca", titulo = "Menina", pose = "rezar_pe", itens = {}, foot = {} }
P.crianca_luz = { g = "C", sub = "x", idade = "crianca", titulo = "Criança", pose = "olhar_luz", itens = {}, foot = {} }

-- ----- elenco ampliado: novos oficios e situacoes -----
-- fixo: chapeu/armadura/capa fixos do papel; lamp: fica ao lado de um lampiao aceso; poco: perto de um poco aceso
local function C(r, g, b) return Color3.fromRGB(r, g, b) end
local PEQUENA = { { cx = 0, cz = -1.6, sx = 3.2, sz = 3.4 } }
local BANDEJA = { { cx = 0, cz = -2.4, sx = 3.8, sz = 3.6 } }
local GUARDA_FOOT = { { cx = 0, cz = -1.8, sx = 3.6, sz = 3.4 } }

P.acendedor = { g = "H", idade = "adulto", titulo = "Acendedor de lampiões", pose = "acender", itens = { { tipo = "vara_acendedor", mao = "D", inc = -88 } }, foot = { { cx = 0, cz = -2.4, sx = 3.4, sz = 4.4 } }, chapeuProb = 0.7, chapeuTipos = { "gorro", "boina" }, colete = true, botas = true, lamp = true }
P.medico_peste = { g = "H", idade = "adulto", titulo = "Médico da peste", pose = "apoiado", itens = { { tipo = "cajado", mao = "D", inc = -54 } }, foot = { { cx = 0, cz = -1.5, sx = 3, sz = 3 } }, fixo = { chapeu = "peste", chapeuCor = C(74, 58, 44), capa = C(34, 30, 32) } }
P.menestrel = { g = "H", idade = "adulto", titulo = "Menestrel", pose = "tocar_alaude", itens = { { tipo = "alaude" } }, foot = { { cx = 0, cz = -1.8, sx = 3.6, sz = 3.6 } }, fixo = { chapeu = "barrete", chapeuCor = C(120, 70, 56) }, poco = true }
P.padeiro = { g = "H", idade = "adulto", titulo = "Padeiro", pose = "bandeja", itens = { { tipo = "bandeja_paes" } }, foot = BANDEJA, avental = true, fixo = { chapeu = "touca", chapeuCor = C(190, 184, 170) } }
P.soldado = { g = "H", idade = "adulto", titulo = "Soldado", pose = "guarda", itens = { { tipo = "lanca", mao = "D", inc = -45 }, { tipo = "escudo", mao = "E", inc = -99 } }, foot = GUARDA_FOOT, botas = true, fixo = { chapeu = "elmo", chapeuCor = C(112, 112, 118), armadura = C(104, 104, 110) } }
P.sentinela = { g = "H", idade = "adulto", titulo = "Sentinela", pose = "guarda", itens = { { tipo = "tocha", mao = "D", inc = -45 } }, foot = GUARDA_FOOT, botas = true, fixo = { chapeu = "elmo", chapeuCor = C(112, 112, 118), armadura = C(104, 104, 110) } }
P.cacador = { g = "H", idade = "adulto", titulo = "Caçador", pose = "parado", itens = { { tipo = "arco", mao = "E", inc = -22 }, { tipo = "aljava" } }, foot = PEQUENA, botas = true, fixo = { chapeu = "capuz", chapeuCor = C(70, 80, 58), capa = C(66, 76, 54) } }
P.peregrino = { g = "H", idade = "adulto", titulo = "Peregrino", pose = "apoiado", itens = { { tipo = "cajado", mao = "D", inc = -54 }, { tipo = "mochila" } }, foot = { { cx = 0, cz = -1.5, sx = 3, sz = 3 } }, fixo = { chapeu = "viajante", chapeuCor = C(70, 62, 52), capa = C(84, 72, 58) } }
P.carpinteiro = { g = "H", idade = "adulto", titulo = "Carpinteiro", pose = "machado", itens = { { tipo = "martelo", mao = "D", inc = -80 } }, foot = { { cx = 0, cz = -3.3, sx = 4.2, sz = 5.2 } }, colete = true }
P.bebado = { g = "H", idade = "adulto", titulo = "Bêbado", pose = "cambaleante", itens = { { tipo = "garrafa", mao = "D", inc = -40 } }, foot = { { cx = 0, cz = -1.5, sx = 3.8, sz = 3.8 } }, rasgado = true }
P.copista = { g = "H", idade = "adulto", titulo = "Frade copista", pose = "ler", itens = { { tipo = "livro" } }, foot = PEQUENA, habito = true }
P.oleiro = { g = "H", idade = "adulto", titulo = "Oleiro", pose = "parado", itens = { { tipo = "jarros_chao" } }, foot = { { cx = 0, cz = -2.4, sx = 6.6, sz = 4.4 } }, avental = true }
P.mensageiro = { g = "H", idade = "adulto", titulo = "Mensageiro", pose = "marcha", itens = { { tipo = "mochila" } }, foot = {}, fixo = { chapeu = "barrete", chapeuCor = C(66, 80, 98) } }

P.vendedora_velas = { g = "M", idade = "adulto", titulo = "Vendedora de velas", pose = "bandeja", itens = { { tipo = "bandeja_velas" } }, foot = BANDEJA }
P.padeira = { g = "M", idade = "adulto", titulo = "Padeira", pose = "bandeja", itens = { { tipo = "bandeja_paes" } }, foot = BANDEJA, avental = true, fixo = { chapeu = "touca", chapeuCor = C(190, 184, 170) } }
P.herbalista = { g = "M", idade = "adulto", titulo = "Herbalista", pose = "parado", itens = { { tipo = "cesto", mao = "E" } }, foot = {} }
P.lanterneira = { g = "M", idade = "adulto", titulo = "Lanterneira", pose = "luz_mao", itens = { { tipo = "lanterna", mao = "D", inc = -104 } }, foot = { { cx = 0, cz = -1.8, sx = 3.2, sz = 3.4 } } }
P.cantora = { g = "M", idade = "adulto", titulo = "Cantora", pose = "cantar", itens = {}, foot = PEQUENA, poco = true }

P.crianca_vela = { g = "C", sub = "x", idade = "crianca", titulo = "Criança", pose = "parado", itens = { { tipo = "vela", mao = "E", inc = -22 } }, foot = {} }
P.crianca_lanterna = { g = "C", sub = "x", idade = "crianca", titulo = "Criança", pose = "parado", itens = { { tipo = "lanterna", mao = "E", inc = -22 } }, foot = {} }
P.crianca_pao = { g = "C", sub = "x", idade = "crianca", titulo = "Criança", pose = "parado", itens = { { tipo = "pao", mao = "D" } }, foot = {} }
P.crianca_livro = { g = "C", sub = "x", idade = "crianca", titulo = "Criança", pose = "ler", itens = { { tipo = "livro" } }, foot = PEQUENA }

-- dialogo generico de cada papel (chave em Dialogos.papel)
local POOL = {
	menino_desenha = "menino", menino_agacha = "menino", menina_boneca = "menina", menina_agacha = "menina",
	crianca_sentada = "crianca", crianca_balde = "crianca", crianca_reza = "menina", crianca_luz = "crianca",
}
for nome, p in pairs(P) do p.nome = nome; p.pool = p.pool or POOL[nome] or nome end

return P
