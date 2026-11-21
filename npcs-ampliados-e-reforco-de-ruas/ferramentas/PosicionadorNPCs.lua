-- PosicionadorNPCs: escolhe as posicoes de TODOS os NPCs parados da vila e grava ServerStorage.PosicoesNPC.
-- Regra do projeto: todo NPC fica em rua ou local iluminado por uma fonte de luz ACESA (estado "ligada":
-- lampioes, lanternas de porta e barraca, pocos, janelas de casas acesas). A iluminacao no chao e a soma de
-- brilho * (1 - distancia / alcance) das PointLights; o limite padrao e 0,55 (ver T abaixo).
-- Uso: require(clone)(true) grava PosicoesNPC; require(clone)(false) so simula.
local SS = game:GetService("ServerStorage")
local CS = game:GetService("CollectionService")

return function(GRAVAR)
	local function req(m) return require(m:Clone()) end
	local OldPos = req(SS:FindFirstChild("PosicoesNPCOriginal") or SS.PosicoesNPC)
	local Papeis = req(SS.PapeisNPC)
	local rnd = Random.new(20261102)

	-- ============ fontes de luz acesas ============
	local fontes, lampsLit, pocosLit = {}, {}, {}
	for _, p in ipairs(CS:GetTagged("Luz")) do
		local luz = p:FindFirstChildWhichIsA("PointLight")
		if p:IsA("BasePart") and luz and p:GetAttribute("Estado") == "ligada" and luz.Range >= 16 and not p:IsDescendantOf(workspace.NPCs) then
			table.insert(fontes, { x = p.Position.X, y = p.Position.Y, z = p.Position.Z, R = luz.Range, B = luz.Brightness })
			if p.Name == "Chama" and not p:FindFirstAncestor("Poco") then table.insert(lampsLit, { x = p.Position.X, z = p.Position.Z }) end
			if p.Name == "Chama" and p:FindFirstAncestor("Poco") then table.insert(pocosLit, { x = p.Position.X, z = p.Position.Z }) end
		end
	end
	local function ilum(x, z)
		local I = 0
		for _, f in ipairs(fontes) do
			local dx, dz, dy = f.x - x, f.z - z, f.y - 1.5
			local d = math.sqrt(dx * dx + dz * dz + dy * dy)
			if d < f.R then I += f.B * (1 - d / f.R) end
		end
		return I
	end
	local function maisPerto(lista, x, z)
		local b, bi = 1e9, nil
		for _, l in ipairs(lista) do
			local d = math.sqrt((l.x - x) ^ 2 + (l.z - z) ^ 2)
			if d < b then b, bi = d, l end
		end
		return b, bi
	end

	-- ============ celulas livres (grade de 4 studs, LocaisBrutos) ============
	local cellset, cells = {}, {}
	local function chave(x, z) return string.format("%d,%d", math.floor(x / 4 + 0.5) * 4, math.floor(z / 4 + 0.5) * 4) end
	for line in string.gmatch(require(SS.LocaisBrutos:Clone()), "[^\n]+") do
		local x, z, dh, dob, y = line:match("^(%-?[%d%.]+),(%-?[%d%.]+),(%-?[%d%.]+),(%-?[%d%.]+),(%-?[%d%.]+)")
		if x then
			local c = { x = tonumber(x), z = tonumber(z), dh = tonumber(dh), dob = tonumber(dob), y = tonumber(y) }
			c.r = math.sqrt(c.x ^ 2 + c.z ^ 2)
			cellset[chave(c.x, c.z)] = c
			table.insert(cells, c)
		end
	end
	local function naPista(x, z)
		if math.abs(z) < 11.8 and math.abs(x) > 56 then return true end
		if math.abs(x) < 11.8 and math.abs(z) > 56 then return true end
		if math.abs(math.abs(x) - 200) < 11.8 and math.abs(z) <= 212 then return true end
		if math.abs(math.abs(z) - 200) < 11.8 and math.abs(x) <= 212 then return true end
		return false
	end
	local spawn = workspace.SpawnLocation.Position
	for _, c in ipairs(cells) do c.I = ilum(c.x, c.z) end
	-- ============ zonas e cotas (espalhar o elenco, em vez de concentrar nas pracas) ============
	local SAT = { { 296.8, 0 }, { -296.8, 0 }, { 0, 296.8 }, { 0, -296.8 } }
	local function zonaDe(x, z)
		if x * x + z * z < 62 * 62 then return "central" end
		for _, sc in ipairs(SAT) do if (x - sc[1]) ^ 2 + (z - sc[2]) ^ 2 < 56 * 56 then return "sat" end end
		if (math.abs(math.abs(x) - 200) < 26 and math.abs(z) <= 226) or (math.abs(math.abs(z) - 200) < 26 and math.abs(x) <= 226) then return "anel" end
		if (math.abs(z) < 26 and math.abs(x) > 56) or (math.abs(x) < 26 and math.abs(z) > 56) then return "avenida" end
		return "bairro"
	end
	local ZONAS = { "central", "sat", "anel", "avenida", "bairro" }
	local FRACAO = { central = 0.12, sat = 0.16, anel = 0.28, avenida = 0.28, bairro = 0.16 }
	local zc = { central = {}, sat = {}, anel = {}, avenida = {}, bairro = {} }
	for _, c in ipairs(cells) do c.zona = zonaDe(c.x, c.z); table.insert(zc[c.zona], c) end
	local RUA, CASA, CRIANCA = {}, {}, {}
	for _, p in ipairs({ "acendedor", "lanterneira", "sentinela", "guarda", "soldado", "mensageiro", "peregrino", "vigia", "menestrel", "cantora", "bebado", "mendigo", "vendedora_velas", "cacador", "medico_peste" }) do RUA[p] = true end
	for _, p in ipairs({ "carpinteiro", "oleiro", "copista", "costureira", "lavadeira", "lavrador", "lenhador", "padeiro", "padeira", "herbalista", "pedreiro", "viuva", "mae", "doente", "escrivao", "pastor", "coveiro", "rezadeira", "varredora", "camponesa", "monge", "velho" }) do CASA[p] = true end
	for _, p in ipairs({ "crianca_vela", "crianca_lanterna", "crianca_pao", "crianca_livro", "menino_desenha", "menina_boneca" }) do CRIANCA[p] = true end
	local function afinidade(papel, z)
		if RUA[papel] then return ({ central = 0.6, sat = 0.5, anel = 2, avenida = 2, bairro = 0.6 })[z] end
		if CASA[papel] then return ({ central = 0.7, sat = 0.8, anel = 1.2, avenida = 1.2, bairro = 2.2 })[z] end
		if CRIANCA[papel] then return ({ central = 1, sat = 1.5, anel = 1, avenida = 1, bairro = 1.5 })[z] end
		return 1
	end
	local function bandaDe(r) return r < 62 and "P" or (r < 130 and "A" or (r < 235 and "B" or (r < 300 and "C" or "D"))) end
	local function valida(c, T) return c.I >= T and not naPista(c.x, c.z) and c.r >= 36 and math.sqrt((c.x - spawn.X) ^ 2 + (c.z - spawn.Z) ^ 2) > 12 end

	-- ============ pegada livre a frente do NPC ============
	local function okPonto(px, pz) return cellset[chave(px, pz)] ~= nil and not naPista(px, pz) end
	-- pegadas muito grandes (cova do coveiro) sao conferidas com a geometria real: nada alem do piso pode tocar a caixa
	local ov = OverlapParams.new()
	ov.FilterType = Enum.RaycastFilterType.Exclude
	ov.FilterDescendantsInstances = { workspace.Vila.Praca, workspace.Vila.Pedras, workspace.Vila.Pracas, workspace.Grama, workspace.NPCs }
	local function livreReal(x, z, y, fx, fz, def)
		local rx, rz = -fz, fx
		for _, b in ipairs(def.foot or {}) do
			local cx, cz = x + rx * b.cx + fx * (-b.cz), z + rz * b.cx + fz * (-b.cz)
			if naPista(cx, cz) then return false end
			for _, k in ipairs({ { -0.5, -0.5 }, { 0.5, -0.5 }, { -0.5, 0.5 }, { 0.5, 0.5 } }) do
				local lx, lz = b.cx + k[1] * b.sx, b.cz + k[2] * b.sz
				if naPista(x + rx * lx + fx * (-lz), z + rz * lx + fz * (-lz)) then return false end
			end
			local pos = Vector3.new(cx, y + 3.2, cz)
			local cf = CFrame.lookAt(pos, pos + Vector3.new(fx, 0, fz))
			if #workspace:GetPartBoundsInBox(cf, Vector3.new(b.sx, 5, b.sz), ov) > 0 then return false end
		end
		return true
	end
	local function livreFoot(x, z, fx, fz, def, cy)
		if def.pose == "pa" then return livreReal(x, z, cy or 0, fx, fz, def) end
		local rx, rz = -fz, fx
		local function ponto(lx, lz) return x + rx * lx + fx * (-lz), z + rz * lx + fz * (-lz) end
		if not okPonto(ponto(0, -3.2)) then return false end
		for _, b in ipairs(def.foot or {}) do
			local x0, x1, z0, z1 = b.cx - b.sx / 2, b.cx + b.sx / 2, b.cz - b.sz / 2, b.cz + b.sz / 2
			local nx, nz = math.max(1, math.ceil((x1 - x0) / 2)), math.max(1, math.ceil((z1 - z0) / 2))
			for ix = 0, nx do
				for iz = 0, nz do
					if not okPonto(ponto(x0 + (x1 - x0) * ix / nx, z0 + (z1 - z0) * iz / nz)) then return false end
				end
			end
		end
		return true
	end
	local function melhorDirecao(x, z, def, alvo, cy)
		local melhor, ms
		for i = 0, 15 do
			local a = i * math.pi / 8
			local fx, fz = math.sin(a), -math.cos(a)
			if livreFoot(x, z, fx, fz, def, cy) then
				local tx, tz = alvo.x - x, alvo.z - z
				local tl = math.sqrt(tx * tx + tz * tz) + 1e-6
				local sc = (fx * tx + fz * tz) / tl + rnd:NextNumber(0, 0.05)
				if not ms or sc > ms then melhor, ms = { fx, fz }, sc end
			end
		end
		return melhor
	end

	-- ============ elenco a posicionar ============
	local PAPEL_UNICOS = { ezequiel = "acendedor", amadeu = "medico_peste", tristao = "menestrel", benvindo = "padeiro", gedeao = "soldado", ildefonso = "sentinela", hermano = "cacador", cipriano = "peregrino", eliseu = "carpinteiro", macario = "bebado", teofilo = "copista", romulo = "oleiro", lourival = "escrivao", isidoro = "sineiro", abraao = "lavrador", dimas = "lenhador", icaro = "guarda", crispim = "velho", ptolomeu = "vigia", wenceslau = "pedreiro", feliciano = "doente", jacinto = "mendigo", joel = "pastor", ermelinda = "vendedora_velas", joaquina = "padeira", salome = "herbalista", aldina = "lanterneira", serafina = "cantora", herminia = "viuva", leocadia = "mae", clementina = "lavadeira", benigna = "costureira", nazare = "rezadeira", mirela = "crianca_vela", toninho = "crianca_lanterna", biel = "crianca_pao", aninha = "crianca_livro", chiquinho = "menino_desenha", maricota = "menina_boneca" }
	local GENS_NOVOS = { acendedor = 4, medico_peste = 2, menestrel = 3, padeiro = 3, soldado = 5, sentinela = 5, cacador = 3, peregrino = 3, carpinteiro = 3, bebado = 3, copista = 2, oleiro = 3, vendedora_velas = 4, padeira = 3, herbalista = 3, lanterneira = 5, cantora = 3, crianca_vela = 5, crianca_lanterna = 4, crianca_pao = 3, crianca_livro = 3,
		lavrador = 3, lenhador = 2, pastor = 2, guarda = 2, mendigo = 2, coveiro = 1, doente = 2, monge = 2, velho = 2, lavadeira = 2, costureira = 2, viuva = 2, mae = 3, varredora = 1, rezadeira = 1, camponesa = 2, menino_desenha = 1, menina_boneca = 1 }

	local todos = {}
	for id, e in pairs(OldPos) do table.insert(todos, { id = id, papel = e.papel, tipo = e.tipo, banda = e.banda, ox = e.x, oz = e.z, velho = true }) end
	for id, papel in pairs(PAPEL_UNICOS) do table.insert(todos, { id = id, papel = papel, tipo = "unico", novo = true }) end
	local nomesPapel = {}
	for papel in pairs(GENS_NOVOS) do table.insert(nomesPapel, papel) end
	table.sort(nomesPapel)
	for _, papel in ipairs(nomesPapel) do
		for k = 1, GENS_NOVOS[papel] do table.insert(todos, { id = "n" .. papel .. k, papel = papel, tipo = "gen", novo = true }) end
	end
	local function area(def) local a = 0; for _, b in ipairs(def.foot or {}) do a += b.sx * b.sz end return a end
	table.sort(todos, function(a, b)
		local aa, ab = area(Papeis[a.papel]), area(Papeis[b.papel])
		if aa ~= ab then return aa > ab end
		return a.id < b.id
	end)

	local escolhidos = {}
	for _, n in ipairs(workspace.NPCs:GetChildren()) do
		local id = n:GetAttribute("NpcId")
		if id == "cassio" or id == "feira1" or id == "feira2" or id == "feira3" then
			local p = n.HumanoidRootPart.Position
			table.insert(escolhidos, { x = p.X, z = p.Z, sep = 7 })
		end
	end
	local function sepDe(def)
		if def.pose == "pa" then return 14 end
		if def.pose == "machado" or def.pose == "enxada" or def.pose == "vassoura" then return 9 end
		return 7
	end
	local function distOk(x, z, sep)
		for _, e in ipairs(escolhidos) do
			local d = math.sqrt((e.x - x) ^ 2 + (e.z - z) ^ 2)
			if d < math.max(sep, e.sep) then return false end
		end
		return true
	end

	-- ============ posicionamento ============
	local resultado, falhas = {}, {}
	local porPapel = {}
	local function candidatoPara(n, def, T, usaPoco, zona)
		local function tentaCelula(c)
			if not valida(c, T) then return nil end
			if not distOk(c.x, c.z, sepDe(def)) then return nil end
			local alvo
			if def.lamp then
				local d, l = maisPerto(lampsLit, c.x, c.z)
				if d < 3.2 or d > 8.5 then return nil end
				alvo = l
			elseif usaPoco and def.poco and #pocosLit > 0 then
				local d, l = maisPerto(pocosLit, c.x, c.z)
				if d < 5 or d > 20 then return nil end
				alvo = l
			else
				local _, l = maisPerto(fontes, c.x, c.z)
				alvo = l
			end
			local dir = melhorDirecao(c.x, c.z, def, alvo, c.y)
			if not dir then return nil end
			return dir, alvo
		end
		local lista = zc[zona]
		if #lista == 0 then return nil end
		local melhor, md, mdir, malvo
		local N, tentativas = 0, 0
		while N < 24 and tentativas < 900 do
			tentativas += 1
			local c = lista[rnd:NextInteger(1, #lista)]
			local dir, alvo = tentaCelula(c)
			if dir then
				N += 1
				local dm = 1e9
				for _, e in ipairs(escolhidos) do
					local d = math.sqrt((e.x - c.x) ^ 2 + (e.z - c.z) ^ 2)
					if d < dm then dm = d end
				end
				local dp = 1e9
				for _, e in ipairs(porPapel[n.papel] or {}) do
					local d = math.sqrt((e.x - c.x) ^ 2 + (e.z - c.z) ^ 2)
					if d < dp then dp = d end
				end
				local sc = math.min(dm, 45) + 0.5 * math.min(dp, 70) + rnd:NextNumber(0, 6)
				if not md or sc > md then melhor, md, mdir, malvo = c, sc, dir, alvo end
			end
		end
		if melhor then return melhor, mdir, malvo end
		return nil
	end

	local restante, somaF = {}, 0
	for _, z in ipairs(ZONAS) do restante[z] = math.floor(FRACAO[z] * #todos); somaF += restante[z] end
	restante.bairro += #todos - somaF
	local function ordemZonas(papel)
		local pool, ordem = {}, {}
		for _, z in ipairs(ZONAS) do table.insert(pool, { z = z, w = math.max(restante[z], 0.05) * afinidade(papel, z) }) end
		while #pool > 0 do
			local tot = 0
			for _, p in ipairs(pool) do tot += p.w end
			local alvo, acum, k = rnd:NextNumber(0, tot), 0, #pool
			for i, p in ipairs(pool) do acum += p.w; if alvo <= acum then k = i break end end
			table.insert(ordem, pool[k].z)
			table.remove(pool, k)
		end
		return ordem
	end
	local porZona = { central = 0, sat = 0, anel = 0, avenida = 0, bairro = 0 }
	for _, n in ipairs(todos) do
		local def = Papeis[n.papel]
		local c, dir, alvo
		-- tenta primeiro os pontos mais claros (>= 0,8) e so entao desce ate o minimo de 0,55
		local Ts = { 0.8, 0.65, 0.55 }
		if def.pose == "pa" then Ts = { 0.8, 0.65, 0.55, 0.45, 0.38, 0.3, 0.22, 0.15 } end
		for _, zona in ipairs(ordemZonas(n.papel)) do
			for _, usaPoco in ipairs({ true, false }) do
				for _, T in ipairs(Ts) do
					c, dir, alvo = candidatoPara(n, def, T, usaPoco, zona)
					if c then n.Tusado = T break end
				end
				if c then break end
			end
			if c then n.zona = zona break end
		end
		if not c then
			table.insert(falhas, n.id .. "(" .. n.papel .. ")")
		else
			n.x, n.z = c.x, c.z
			n.mx, n.mz = c.x + dir[1] * 10, c.z + dir[2] * 10
			if def.lamp or (def.poco and #pocosLit > 0 and select(1, maisPerto(pocosLit, c.x, c.z)) < 20) then n.mx, n.mz = alvo.x, alvo.z end
			n.r = c.r
			n.I = c.I
			table.insert(escolhidos, { x = c.x, z = c.z, sep = sepDe(def) })
			porPapel[n.papel] = porPapel[n.papel] or {}
			table.insert(porPapel[n.papel], { x = c.x, z = c.z })
			restante[n.zona] -= 1
			porZona[n.zona] += 1
			table.insert(resultado, n)
		end
	end

	-- ============ gravacao ============
	table.sort(resultado, function(a, b) return a.id < b.id end)
	local linhas = { "-- Posicoes sorteadas e validadas (sem casas ou objetos na frente, e SEMPRE em local iluminado por luz acesa). id -> x, z, mira (mx, mz), papel, banda, tipo", "-- Gerado por ServerStorage.PosicionadorNPCs. `novo = true` marca o elenco ampliado. banda: faixa de distancia que decide a chance de conversar.", "return {" }
	local porBanda, baixaT, minI = { P = 0, A = 0, B = 0, C = 0, D = 0 }, 0, 99
	for _, n in ipairs(resultado) do
		local banda = n.banda or bandaDe(n.r)
		porBanda[bandaDe(n.r)] += 1
		if n.Tusado and n.Tusado < 0.55 then baixaT += 1 end
		minI = math.min(minI, n.I)
		table.insert(linhas, string.format("\t%s = { x = %g, z = %g, mx = %.1f, mz = %.1f, r = %d, papel = %q, banda = %q, tipo = %q%s },", n.id, n.x, n.z, n.mx, n.mz, math.floor(n.r + 0.5), n.papel, banda, n.tipo, n.novo and ", novo = true" or ""))
	end
	table.insert(linhas, "}")
	local texto = table.concat(linhas, "\n") .. "\n"
	if GRAVAR then
		if not SS:FindFirstChild("PosicoesNPCOriginal") then
			local bk = SS.PosicoesNPC:Clone(); bk.Name = "PosicoesNPCOriginal"; bk.Parent = SS
		end
		SS.PosicoesNPC.Source = texto
	end
	local desl = {}
	for _, n in ipairs(resultado) do if n.velho then table.insert(desl, math.sqrt((n.x - n.ox) ^ 2 + (n.z - n.oz) ^ 2)) end end
	table.sort(desl)
	local somaI, nClaros = 0, 0
	for _, n in ipairs(resultado) do somaI += n.I; if n.I >= 0.8 then nClaros += 1 end end
	print(string.format("iluminacao media=%.2f; com I>=0.8: %d de %d", somaI / #resultado, nClaros, #resultado))
	return string.format("total=%d colocados=%d falhas=%d [%s]\nzonas: central=%d sat=%d anel=%d avenida=%d bairro=%d\nfaixas (por r): P=%d A=%d B=%d C=%d D=%d | com T<0.55: %d | menor iluminacao=%.2f | deslocamento antigos: mediana=%.0f max=%.0f | gravado=%s",
		#todos, #resultado, #falhas, table.concat(falhas, ", "), porZona.central, porZona.sat, porZona.anel, porZona.avenida, porZona.bairro, porBanda.P, porBanda.A, porBanda.B, porBanda.C, porBanda.D, baixaT, minI, desl[math.floor(#desl / 2)] or 0, desl[#desl] or 0, tostring(GRAVAR)), resultado
end
