-- GeradorNPCs: cria especificacoes (specs) de NPCs a partir dos papeis (PapeisNPC) e das posicoes
-- sorteadas (PosicoesNPC). A aparencia e sorteada com semente fixa derivada do id: sempre igual.
local SS = game:GetService("ServerStorage")
local Papeis = require(SS.PapeisNPC)
local Pos = require(SS.PosicoesNPC)

local V2 = Vector2.new
local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end

local PELES = { rgb(234, 184, 146), rgb(214, 168, 128), rgb(190, 140, 100), rgb(150, 104, 72), rgb(112, 78, 54) }
local CAMISAS = { rgb(128, 112, 86), rgb(92, 72, 54), rgb(88, 88, 84), rgb(66, 80, 98), rgb(70, 80, 58), rgb(108, 64, 50), rgb(140, 116, 66), rgb(166, 154, 128), rgb(78, 68, 60), rgb(100, 94, 76) }
local CALCAS = { rgb(92, 72, 54), rgb(56, 50, 50), rgb(88, 88, 84), rgb(70, 64, 54), rgb(60, 56, 62), rgb(84, 70, 52) }
local VESTIDOS = { rgb(76, 84, 64), rgb(74, 84, 100), rgb(150, 136, 112), rgb(112, 70, 60), rgb(96, 70, 62), rgb(120, 100, 72), rgb(100, 82, 60), rgb(80, 90, 108), rgb(88, 74, 84), rgb(104, 96, 78) }
local LUTO = { rgb(40, 38, 42), rgb(44, 42, 48), rgb(52, 46, 46), rgb(36, 36, 40) }
local XALES = { rgb(84, 70, 66), rgb(92, 76, 56), rgb(66, 74, 56), rgb(74, 66, 60), rgb(104, 84, 62) }
local LENCOS = { rgb(166, 154, 128), rgb(150, 138, 108), rgb(120, 112, 100), rgb(176, 166, 140), rgb(140, 120, 96), rgb(54, 50, 54) }
local CABELOS = { rgb(34, 28, 26), rgb(66, 48, 34), rgb(96, 70, 46), rgb(110, 58, 36), rgb(34, 28, 26), rgb(66, 48, 34) }
local GRISALHOS = { rgb(120, 116, 112), rgb(170, 166, 160), rgb(142, 138, 130) }
local COURO = rgb(84, 62, 44)
local CORDA = rgb(150, 126, 86)

local NOMES_H = { "Abílio", "Adão", "Afonso", "Aldo", "Amaro", "Anastácio", "Baltazar", "Brás", "Celso", "Clemente", "Dâmaso", "Dionísio", "Durval", "Edmundo", "Egídio", "Eusébio", "Faustino", "Felício", "Gil", "Hilário", "Inácio", "Jacó", "Josué", "Lourenço", "Mateus", "Olavo", "Pascoal", "Rodrigo", "Sebastião", "Tadeu", "Ulisses", "Vicente", "Zacarias", "Adriano", "Casimiro", "Evaristo", "Fidélis", "Gervásio", "Leandro", "Moisés", "Norberto", "Ovídio", "Patrício", "Quirino", "Rogério", "Saulo", "Tiago", "Ubaldo", "Valério", "Xavier" }
local NOMES_M = { "Aurora", "Benedita", "Catarina", "Dalila", "Edite", "Elvira", "Felícia", "Gertrudes", "Helena", "Isadora", "Joana", "Leonor", "Maura", "Nair", "Otília", "Páscoa", "Rita", "Sabina", "Tereza", "Úrsula", "Violeta", "Zulmira", "Amélia", "Berta", "Cândida", "Dolores", "Eugênia", "Flora", "Graça", "Hilda", "Iracema", "Jandira", "Laura", "Mirtes", "Noêmia", "Odete", "Pura", "Rosália", "Sílvia", "Teresinha", "Alzira", "Bernadete", "Clotilde", "Delfina", "Emília", "Filomena", "Glória", "Heloísa", "Ilda", "Judite" }
local NOMES_CM = { "Caio", "Dudu", "Gui", "Jorginho", "Lucas", "Nando", "Otto", "Pipo", "Tico", "Zé", "Beco", "Juca", "Neno", "Quim", "Teco", "Vitinho", "Lelê", "Miguelito", "Nandinho", "Tonho" }
local NOMES_CF = { "Alice", "Bia", "Dalva", "Flor", "Gabi", "Ida", "Julinha", "Lili", "Mara", "Olga", "Paula", "Rute", "Sara", "Tina", "Vera", "Zélia", "Cida", "Duda", "Lúcia", "Nena" }

-- nomes do elenco ampliado (so quem tem `novo` usa estas listas; os NPCs antigos mantem os nomes de sempre)
local NOMES_H2 = { "Acácio", "Alcides", "Almiro", "Ambrósio", "Aniceto", "Arlindo", "Aristides", "Augusto", "Belmiro", "Bernardo", "Cristóvão", "Damião", "Demétrio", "Ernesto", "Fabrício", "Floriano", "Frederico", "Gaudêncio", "Geraldo", "Horácio", "Jonas", "Jorge", "Josias", "Lauro", "Lino", "Manassés", "Nicanor", "Nilo", "Onofre", "Orestes", "Osório", "Pancrácio", "Plínio", "Quintino", "Raimundo", "Reinaldo", "Sandoval", "Telmo", "Tertuliano", "Valentim", "Zeferino", "Zózimo", "Alberto", "Ananias", "Cândido", "Delfim", "Eurico", "Fausto", "Gumercindo", "Heliodoro", "Ivo", "Januário", "Leopoldo", "Maximino", "Narciso", "Odilon", "Prudêncio", "Rúben", "Silvano" }
local NOMES_M2 = { "Adelaide", "Albina", "Anastácia", "Augusta", "Balbina", "Brites", "Carlota", "Celeste", "Conceição", "Constança", "Damiana", "Deolinda", "Dulce", "Efigênia", "Elisa", "Ernestina", "Esmeralda", "Genésia", "Jacinta", "Lídia", "Luzia", "Margarida", "Mécia", "Olímpia", "Palmira", "Quintina", "Raquel", "Rufina", "Sancha", "Severina", "Tecla", "Umbelina", "Venância", "Vitória", "Zenaide", "Ágata", "Basília", "Carmélia", "Cleusa", "Domitila", "Felismina", "Gilda", "Hortência", "Idalina", "Josefina", "Lavínia", "Matilde", "Noemi", "Otacília", "Prisca" }
local NOMES_CM2 = { "Tonico", "Zequinha", "Chico", "Luizinho", "Nonô", "Quinzinho", "Juninho", "Dinho", "Bastião", "Cacá", "Fabinho", "Guto", "Hugo", "Jão", "Kiko", "Lico", "Mingo", "Neco", "Paco", "Rui", "Sadi", "Tião", "Vavá", "Eduzinho" }
local NOMES_CF2 = { "Bela", "Cecé", "Dedé", "Eli", "Fifi", "Gigi", "Helinha", "Isa", "Janja", "Lalá", "Mimosa", "Neném", "Pipa", "Quita", "Rosinha", "Sinhá", "Tati", "Uli", "Vivi", "Zazá", "Dorinha", "Estela", "Fininha", "Gabriela" }

local INTERATIVIDADE = { P = 1.0, A = 0.9, B = 0.7, C = 0.45, D = 0.2 }

local function hash(s)
	local h = 7
	for i = 1, #s do h = (h * 131 + s:byte(i)) % 1000003 end
	return h
end

local G = {}

-- ofícios que tem nome proprio e dialogo proprio (id -> dados)
G.UNICOS = {
	abel = { nome = "Abel", titulo = "Sineiro" },
	claudio = { nome = "Cláudio", titulo = "Escrivão" },
	valdemar = { nome = "Mestre Valdemar", titulo = "Ferreiro" },
	lazaro = { nome = "Lázaro", titulo = "Mendigo" },
	dorotea = { nome = "Dorotéia", titulo = "Parteira" },
	genoveva = { nome = "Genoveva", titulo = "Tecelã" },
	hortensia = { nome = "Hortênsia", titulo = "Estalajadeira" },
	quiteria = { nome = "Quitéria", titulo = "Ervateira" },
	brigida = { nome = "Brígida", titulo = "Viúva" },
	olinda = { nome = "Olinda", titulo = "Mãe" },
	otavio = { nome = "Otávio", titulo = "Guarda" },
	caetano = { nome = "Caetano", titulo = "Pastor" },
	nestor = { nome = "Velho Nestor", titulo = "Ex-sineiro" },
	bento = { nome = "Bento", titulo = "Menino", sub = "m" },
	dora = { nome = "Dora", titulo = "Menina", sub = "f" },
	nita = { nome = "Nita", titulo = "Menina", sub = "f" },
	silvestre = { nome = "Silvestre", titulo = "Lenhador" },
	benicio = { nome = "Benício", titulo = "Doente" },
	jeronimo = { nome = "Jerônimo", titulo = "Lavrador" },
	firmino = { nome = "Firmino", titulo = "Coveiro" },
	teodoro = { nome = "Teodoro", titulo = "Lavrador" },
	isaura = { nome = "Isaura", titulo = "Lavadeira" },
	valeria = { nome = "Valéria", titulo = "Camponesa" },
	perpetua = { nome = "Perpétua", titulo = "Rezadeira" },
	goncalo = { nome = "Gonçalo", titulo = "Pedreiro" },
	aurelio = { nome = "Frei Aurélio", titulo = "Frade" },
	raul = { nome = "Raul", titulo = "Menino", sub = "m" },
	eva = { nome = "Eva", titulo = "Menina", sub = "f" },
	tito = { nome = "Tito", titulo = "Menino", sub = "m" },
	lucinda = { nome = "Lucinda", titulo = "Costureira" },
	honorio = { nome = "Honório", titulo = "Vigia" },
	madalena = { nome = "Madalena", titulo = "Mãe" },
	-- elenco ampliado
	ezequiel = { nome = "Ezequiel", titulo = "Acendedor de lampiões" },
	amadeu = { nome = "Mestre Amadeu", titulo = "Médico da peste" },
	tristao = { nome = "Tristão", titulo = "Menestrel" },
	benvindo = { nome = "Benvindo", titulo = "Padeiro" },
	gedeao = { nome = "Gedeão", titulo = "Soldado" },
	ildefonso = { nome = "Ildefonso", titulo = "Sentinela" },
	hermano = { nome = "Hermano", titulo = "Caçador" },
	cipriano = { nome = "Cipriano", titulo = "Peregrino" },
	eliseu = { nome = "Mestre Eliseu", titulo = "Carpinteiro" },
	macario = { nome = "Macário", titulo = "Bêbado" },
	teofilo = { nome = "Frei Teófilo", titulo = "Frade copista" },
	romulo = { nome = "Rômulo", titulo = "Oleiro" },
	lourival = { nome = "Lourival", titulo = "Escrivão" },
	isidoro = { nome = "Isidoro", titulo = "Sineiro" },
	abraao = { nome = "Abraão", titulo = "Lavrador" },
	dimas = { nome = "Dimas", titulo = "Lenhador" },
	icaro = { nome = "Sargento Ícaro", titulo = "Guarda" },
	crispim = { nome = "Velho Crispim", titulo = "Velho" },
	ptolomeu = { nome = "Ptolomeu", titulo = "Vigia" },
	wenceslau = { nome = "Mestre Wenceslau", titulo = "Pedreiro" },
	feliciano = { nome = "Feliciano", titulo = "Doente" },
	jacinto = { nome = "Jacinto", titulo = "Mendigo" },
	joel = { nome = "Joel", titulo = "Pastor" },
	ermelinda = { nome = "Ermelinda", titulo = "Vendedora de velas" },
	joaquina = { nome = "Joaquina", titulo = "Padeira" },
	salome = { nome = "Salomé", titulo = "Herbalista" },
	aldina = { nome = "Aldina", titulo = "Lanterneira" },
	serafina = { nome = "Serafina", titulo = "Cantora" },
	herminia = { nome = "Dona Hermínia", titulo = "Viúva" },
	leocadia = { nome = "Leocádia", titulo = "Mãe" },
	clementina = { nome = "Clementina", titulo = "Lavadeira" },
	benigna = { nome = "Benigna", titulo = "Costureira" },
	nazare = { nome = "Nazaré", titulo = "Rezadeira" },
	mirela = { nome = "Mirela", titulo = "Menina", sub = "f" },
	toninho = { nome = "Toninho", titulo = "Menino", sub = "m" },
	biel = { nome = "Biel", titulo = "Menino", sub = "m" },
	aninha = { nome = "Aninha", titulo = "Menina", sub = "f" },
	chiquinho = { nome = "Chiquinho", titulo = "Menino", sub = "m" },
	maricota = { nome = "Maricota", titulo = "Menina", sub = "f" },
}

local usados = {}
local function nomeUnico(lista, rnd)
	for _ = 1, 40 do
		local n = lista[rnd:NextInteger(1, #lista)]
		if not usados[n] then usados[n] = true return n end
	end
	return lista[rnd:NextInteger(1, #lista)]
end

-- monta a spec de um NPC parado
function G.spec(id, e, papelNome, opc)
	opc = opc or {}
	local def = Papeis[papelNome]
	assert(def, "papel desconhecido: " .. tostring(papelNome))
	local rnd = Random.new(hash(id))
	local function pick(t) return t[rnd:NextInteger(1, #t)] end
	local uni = G.UNICOS[id]
	local sub = (uni and uni.sub) or def.sub or "x"
	local genero = def.g
	if genero == "C" and sub == "x" then sub = (rnd:NextNumber() < 0.5) and "m" or "f" end

	local spec = {
		id = id, genero = genero, idade = def.idade, pose = def.pose,
		pos = V2(e.x, e.z), mira = V2(e.mx, e.mz),
		colisor = def.colisor, alvoY = def.alvoY, papel = def.pool,
		interativo = opc.interativo and true or false,
		fase = rnd:NextNumber(0, 1),
	}
	-- nome e titulo
	if uni then
		spec.nome, spec.titulo = uni.nome, uni.titulo
	else
		local nv = opc.novo
		local lista
		if genero == "H" then lista = nv and NOMES_H2 or NOMES_H
		elseif genero == "M" then lista = nv and NOMES_M2 or NOMES_M
		elseif sub == "m" then lista = nv and NOMES_CM2 or NOMES_CM
		else lista = nv and NOMES_CF2 or NOMES_CF end
		spec.nome = nomeUnico(lista, rnd)
		spec.titulo = def.titulo
		if genero == "C" then spec.titulo = (sub == "m") and "Menino" or "Menina" end
	end
	-- itens (copia)
	spec.itens = {}
	for _, it in ipairs(def.itens or {}) do
		local c = {}
		for k, v in pairs(it) do c[k] = v end
		table.insert(spec.itens, c)
	end
	-- pele, escala, rosto
	spec.pele = pick(PELES)
	local sujo = (rnd:NextNumber() < 0.5) and "torso1" or "torso2"
	if genero == "H" then
		spec.esc = { h = rnd:NextNumber(0.96, 1.06), w = rnd:NextNumber(0.8, 0.94) }
		if def.idade == "idoso" then spec.esc = { h = 0.97, w = 0.82 } end
		spec.face = (def.idade == "idoso") and pick({ "i1", "i2" }) or ("h" .. rnd:NextInteger(1, 8))
		if def.habito then
			spec.roupa = { camisa = rgb(84, 66, 48), habito = true, cintoCor = CORDA, sujo = sujo }
			spec.cabelo = { estilo = "calvo", cor = pick(CABELOS) }
			spec.chapeu = { tipo = "capuz", cor = rgb(84, 66, 48) }
		else
			local r = { camisa = pick(CAMISAS), calca = pick(CALCAS), mangaCurta = rnd:NextNumber() < 0.55, sujo = sujo }
			if def.colete or rnd:NextNumber() < 0.18 then r.colete = COURO end
			if def.botas then r.botas = rgb(48, 40, 34) end
			if def.avental then r.avental = rgb(150, 136, 110) end
			if def.rasgado then r.camisa = rgb(108, 64, 50); r.mangaCurta = false end
			spec.roupa = r
			local idoso = def.idade == "idoso"
			spec.cabelo = { estilo = idoso and pick({ "calvo", "curto" }) or pick({ "curto", "curto", "rebelde", "calvo" }), cor = idoso and pick(GRISALHOS) or pick(CABELOS) }
			if def.boina then
				spec.chapeu = { tipo = "boina", cor = rgb(70, 62, 52) }
			elseif def.chapeuProb and rnd:NextNumber() < def.chapeuProb then
				local tipo = pick(def.chapeuTipos)
				spec.chapeu = { tipo = tipo, cor = (tipo == "palha") and rgb(150, 128, 86) or ((tipo == "gorro") and rgb(70, 66, 60) or rgb(70, 62, 52)) }
			end
		end
	elseif genero == "M" then
		spec.esc = { h = rnd:NextNumber(0.93, 0.99), w = rnd:NextNumber(0.78, 0.9) }
		spec.face = "m" .. rnd:NextInteger(1, 8)
		local vest = def.luto and pick(LUTO) or pick(VESTIDOS)
		local r = { camisa = def.luto and vest or pick({ rgb(166, 154, 128), rgb(128, 112, 86), vest:Lerp(rgb(255, 255, 255), 0.15) }), vestido = vest, sujo = sujo, mangaCurta = rnd:NextNumber() < 0.4 }
		if def.luto or rnd:NextNumber() < 0.5 then r.xale = def.luto and rgb(30, 28, 32) or pick(XALES) end
		if def.avental then r.avental = rgb(150, 136, 110) end
		spec.roupa = r
		spec.cabelo = { estilo = pick({ "longo", "tranca", "coque", "curto" }), cor = pick(CABELOS) }
		if def.luto or rnd:NextNumber() < 0.65 then spec.chapeu = { tipo = "lenco", cor = def.luto and rgb(54, 50, 54) or pick(LENCOS) } end
	else -- crianca
		spec.esc = { h = rnd:NextNumber(0.64, 0.74), w = rnd:NextNumber(0.76, 0.84), cab = rnd:NextNumber(1.2, 1.26) }
		spec.face = "c" .. rnd:NextInteger(1, 8)
		if sub == "m" then
			spec.roupa = { camisa = pick(CAMISAS), calca = pick(CALCAS), mangaCurta = true, sujo = sujo, cinto = false }
			spec.cabelo = { estilo = pick({ "curto", "rebelde", "rebelde" }), cor = pick(CABELOS) }
		else
			local vest = pick(VESTIDOS)
			spec.roupa = { camisa = pick({ rgb(120, 96, 90), rgb(116, 100, 92), rgb(110, 92, 84) }), vestido = vest, sujo = sujo, mangaCurta = rnd:NextNumber() < 0.5, cinto = false }
			spec.cabelo = { estilo = pick({ "tranca", "longo", "coque" }), cor = pick(CABELOS) }
		end
	end
	-- elementos fixos do papel (chapeu, armadura, capa): nao consomem sorteios
	if def.fixo then
		local f = def.fixo
		if f.chapeu then spec.chapeu = { tipo = f.chapeu, cor = f.chapeuCor } end
		if f.armadura then spec.roupa.armadura = f.armadura end
		if f.capa then spec.roupa.capa = f.capa end
	end
	return spec
end

-- todos os NPCs sorteados (tipo "gen" e "unico"); os "orig" ficam no ElencoNPCs
function G.todos()
	local lista = {}
	local ids = {}
	for id in pairs(Pos) do table.insert(ids, id) end
	table.sort(ids)
	for _, id in ipairs(ids) do
		local e = Pos[id]
		if e.tipo ~= "orig" then
			local interativo = true
			if e.tipo == "gen" then
				interativo = (hash(id) % 100) / 100 < (INTERATIVIDADE[e.banda] or 0.3)
			end
			table.insert(lista, G.spec(id, e, e.papel, { interativo = interativo, novo = e.novo }))
		end
	end
	return lista
end

G.Pos = Pos
G.interatividade = INTERATIVIDADE
return G
