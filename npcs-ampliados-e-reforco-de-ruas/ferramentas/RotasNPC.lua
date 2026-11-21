-- RotasNPC (v2): escolhe as rotas de vai-e-vem dos NPCs que andam, ESPALHADAS por toda a malha de ruas
-- (4 avenidas e 4 lados do anel). Cada rota fica inteira em trecho com iluminacao no chao >= T (so luz "ligada").
-- Uso: require(clone)(T, N, semente) -> lista de N rotas { eixo = "x"|"z", c = linha fixa, a = inicio, b = fim, ... }
-- eixo "x": anda ao longo de X com z = c; eixo "z": anda ao longo de Z com x = c. Gulosa de maior distancia minima.
local CS = game:GetService("CollectionService")

return function(T, N, SEMENTE)
	local rnd = Random.new(SEMENTE or 7)
	local fontes = {}
	for _, p in ipairs(CS:GetTagged("Luz")) do
		local luz = p:FindFirstChildWhichIsA("PointLight")
		if p:IsA("BasePart") and luz and p:GetAttribute("Estado") == "ligada" and luz.Range >= 16 and not p:IsDescendantOf(workspace.NPCs) then
			table.insert(fontes, { x = p.Position.X, y = p.Position.Y, z = p.Position.Z, R = luz.Range, B = luz.Brightness })
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
	local function ponto(eixo, c, t) if eixo == "x" then return t, c else return c, t end end

	-- linhas de passeio: avenidas (|t| de 64 a 246) e lados do anel (|t| de 28 a 186), nos quatro deslocamentos usuais
	local linhas = {}
	for _, off in ipairs({ -7.6, -6.6, 6.6, 7.6 }) do
		for _, sg in ipairs({ -1, 1 }) do
			table.insert(linhas, { eixo = "x", c = off, a = sg * 64, b = sg * 246, tipo = "avenida" })
			table.insert(linhas, { eixo = "z", c = off, a = sg * 64, b = sg * 246, tipo = "avenida" })
			for _, lado in ipairs({ -1, 1 }) do
				table.insert(linhas, { eixo = "z", c = lado * 200 + off, a = sg * 28, b = sg * 186, tipo = "anel" })
				table.insert(linhas, { eixo = "x", c = lado * 200 + off, a = sg * 28, b = sg * 186, tipo = "anel" })
			end
		end
	end
	-- trechos candidatos: janelas de 64 a 80 de comprimento, todas as amostras (passo 4) com I >= T
	local cand = {}
	for _, ln in ipairs(linhas) do
		local passo = (ln.b >= ln.a) and 4 or -4
		local I, ts = {}, {}
		for t = ln.a, ln.b, passo do table.insert(ts, t); local x, z = ponto(ln.eixo, ln.c, t); table.insert(I, ilum(x, z)) end
		local i = 1
		while i <= #ts do
			if I[i] >= T then
				local j = i
				while j + 1 <= #ts and I[j + 1] >= T do j += 1 end
				local comp = math.abs(ts[j] - ts[i])
				if comp >= 64 then
					local alvo = math.min(comp, 64 + 4 * rnd:NextInteger(0, 4))
					local ini = i + rnd:NextInteger(0, math.floor((comp - alvo) / 4))
					local fim = ini + math.floor(alvo / 4)
					local a, b = ts[ini], ts[fim]
					if rnd:NextInteger(0, 1) == 1 then a, b = b, a end
					local mx, mz = ponto(ln.eixo, ln.c, (a + b) / 2)
					table.insert(cand, { eixo = ln.eixo, c = ln.c, a = a, b = b, mx = mx, mz = mz, tipo = ln.tipo })
				end
				i = j + 1
			else
				i += 1
			end
		end
	end
	local function mesmaFaixa(u, r)
		if u.eixo ~= r.eixo or math.abs(u.c - r.c) >= 3 then return false end
		local lo1, hi1 = math.min(u.a, u.b), math.max(u.a, u.b)
		local lo2, hi2 = math.min(r.a, r.b), math.max(r.a, r.b)
		return lo1 < hi2 + 12 and lo2 < hi1 + 12
	end
	-- guloso: a cada passo, o trecho cujo ponto medio fica mais longe dos ja escolhidos
	local escolhidas = {}
	while #escolhidas < N and #cand > 0 do
		local melhor, ms
		for _, r in ipairs(cand) do
			local dm = 1e9
			for _, e in ipairs(escolhidas) do dm = math.min(dm, math.sqrt((e.mx - r.mx) ^ 2 + (e.mz - r.mz) ^ 2)) end
			if #escolhidas == 0 then dm = rnd:NextNumber(0, 10) end
			local sc = dm + rnd:NextNumber(0, 8)
			if not ms or sc > ms then melhor, ms = r, sc end
		end
		table.insert(escolhidas, melhor)
		local resto = {}
		for _, r in ipairs(cand) do if not mesmaFaixa(melhor, r) then table.insert(resto, r) end end
		cand = resto
	end
	return escolhidas
end
