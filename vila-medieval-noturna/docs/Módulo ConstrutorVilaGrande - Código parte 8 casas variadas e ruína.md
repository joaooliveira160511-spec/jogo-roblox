---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, expansao, casas, ruina]
---
# Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína
Índice: [[Jogos - Gerais]]

## Conceito
- Segundo bloco da extensão, logo depois de [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]]. Contém o envelhecimento das casas, o entulho, os sorteios de nível e de estado de luz e os construtores de fileira de rua e de anel em círculo. Usa as constantes `HB`, `FH` e `JET` e a função `assenta` da parte 7.

## Código
```lua
-- =====================================================================
-- EXTENSÃO 2: casas variadas, envelhecidas e em ruína; fileiras ao longo das ruas e anéis em círculo.
-- ruina: 0 intacta, 1 gasta, 2 decadente (buracos no telhado, janelas vazias), 3 caindo aos pedaços.
-- =====================================================================

-- hera extra, com as mesmas regras de M.casa
local function heraExtra(m, cf, o, n, rng)
	local w, d, andares = o.w, o.d, o.andares
	for _ = 1, n do
		local lado = rng:NextInteger(1, 4)
		local sx, sy = rng:NextNumber(2.4, 5.6), rng:NextNumber(3, 8)
		local col = Color3.fromRGB(rng:NextInteger(30, 46), rng:NextInteger(52, 74), rng:NextInteger(28, 42))
		local yMax = (lado >= 3) and (HB + FH * andares - 4) or (HB - 2)
		local y = rng:NextNumber(sy / 2 + 1.2, math.max(sy / 2 + 2, yMax))
		local fcf
		if lado == 1 then fcf = cf * CFrame.new(rng:NextNumber(-w / 2 + 3, w / 2 - 3), y, -(d / 2) - 0.12) * CFrame.Angles(0, math.pi, 0)
		elseif lado == 2 then fcf = cf * CFrame.new(rng:NextNumber(-w / 2 + 3, w / 2 - 3), y, d / 2 + 0.12)
		elseif lado == 3 then fcf = cf * CFrame.new(w / 2 + ((y > HB) and 0.85 or 0.12), y, rng:NextNumber(-d / 2 + 3, d / 2 - 3)) * CFrame.Angles(0, math.pi / 2, 0)
		else fcf = cf * CFrame.new(-w / 2 - ((y > HB) and 0.85 or 0.12), y, rng:NextNumber(-d / 2 + 3, d / 2 - 3)) * CFrame.Angles(0, -math.pi / 2, 0) end
		P(m, "Hera", Vector3.new(sx, sy, 0.12), fcf, col, Mat.Grass, false, false)
		P(m, "HeraFolha", Vector3.new(sx * 0.6, sy * 0.5, 0.2), fcf * CFrame.new(rng:NextNumber(-1, 1), rng:NextNumber(-1, 1), 0.06), col:Lerp(Color3.new(0, 0, 0), 0.25), Mat.Grass, false, false)
	end
end

-- envelhece uma casa já construída: telhas soltas, buracos, telhado caído, janelas vazias,
-- venezianas tortas, vigas faltando, canto de parede aberto (CSG) e inclinação leve
local function envelhece(m, cf, o, nivel, rng)
	local w, d, andares = o.w, o.d, o.andares
	local yTop = HB + FH * andares
	local ww, dd = w + 0.6, d + JET
	local rot = o.gableFront and CFrame.Angles(0, math.pi / 2, 0) or CFrame.new()
	local roofCF = cf * CFrame.new(0, yTop, -JET / 2) * rot
	local RL = o.gableFront and dd or ww
	local SP = o.gableFront and ww or dd
	local half, rise = SP / 2, SP * 0.56
	local a = math.atan2(rise, half)
	local sinA, cosA = math.sin(a), math.cos(a)
	local Ls = math.sqrt(half * half + rise * rise)
	local len = Ls + 1.8
	local function lado(p) return (roofCF:PointToObjectSpace(p.Position).Z >= 0) and 1 or -1 end
	local porNome = {}
	for _, p in ipairs(m:GetChildren()) do
		local l = porNome[p.Name]
		if not l then l = {}; porNome[p.Name] = l end
		l[#l + 1] = p
	end
	local function apaga(lista, prob)
		for _, p in ipairs(lista or {}) do
			if p.Parent and rng:NextNumber() < prob then p:Destroy() end
		end
	end

	-- telhas soltas e buracos no telhado
	apaga(porNome.Telha, ({ 0.04, 0.07, 0.10 })[nivel])
	if nivel >= 2 and porNome.Telha then
		for _ = 1, nivel do
			local t = porNome.Telha[rng:NextInteger(1, #porNome.Telha)]
			if t.Parent then
				local c, raio = t.Position, rng:NextNumber(3.2, 5.4)
				for _, tt in ipairs(porNome.Telha) do
					if tt.Parent and (tt.Position - c).Magnitude < raio then tt:Destroy() end
				end
				for _, cb in ipairs(porNome.Caibro or {}) do
					if cb.Parent and (cb.Position - c).Magnitude < raio * 0.8 then cb:Destroy() end
				end
			end
		end
	end

	-- janelas: vidro quebrado deixa o vão escuro; venezianas penduradas
	if nivel >= 2 then
		for _, v in ipairs(porNome.Vidro or {}) do
			if v.Parent and rng:NextNumber() < ((nivel == 2) and 0.3 or 0.5) then
				P(m, "JanelaVazia", v.Size, v.CFrame, Color3.fromRGB(5, 5, 7), Mat.SmoothPlastic, false, false)
				v:Destroy()
			end
		end
	end
	for _, v in ipairs(porNome.Veneziana or {}) do
		if v.Parent and rng:NextNumber() < 0.25 * nivel then
			local s = (rng:NextNumber() < 0.5) and -1 or 1
			v.CFrame = v.CFrame * CFrame.new(0, -v.Size.Y * 0.18, 0.1) * CFrame.Angles(0, 0, s * rng:NextNumber(0.25, 0.75))
		end
	end

	-- enxaimel com vigas faltando e escoras tortas
	if nivel >= 2 then
		apaga(porNome.Escora, 0.12 + 0.18 * (nivel - 1))
		apaga(porNome.Poste, 0.05 * (nivel - 1))
		for _, p in ipairs(porNome.Escora or {}) do
			if p.Parent and rng:NextNumber() < 0.35 then p.CFrame = p.CFrame * CFrame.Angles(0, 0, rng:NextNumber(-0.1, 0.1)) end
		end
	end

	-- ruína: uma água do telhado cai, restam caibros quebrados e um canto do último andar desaba
	if nivel >= 3 then
		local sCol = (rng:NextNumber() < 0.5) and 1 or -1
		for _, nome in ipairs({ "Telha", "Subtelhado", "Caibro", "Beiral", "Tabeira" }) do
			for _, p in ipairs(porNome[nome] or {}) do
				if p.Parent and lado(p) == sCol then p:Destroy() end
			end
		end
		for _, p in ipairs(porNome.VigaEmpena or {}) do
			if p.Parent and lado(p) == sCol and rng:NextNumber() < 0.6 then p:Destroy() end
		end
		if not o.gableFront then
			for _, nome in ipairs({ "Trapeira", "TrapeiraTeto", "TrapeiraViga" }) do
				for _, p in ipairs(porNome[nome] or {}) do
					if p.Parent and lado(p) == sCol then p:Destroy() end
				end
			end
			for _, nome in ipairs({ "Moldura", "Vidro", "TravessaV", "TravessaH", "Peitoril", "Verga", "Veneziana" }) do
				for _, p in ipairs(porNome[nome] or {}) do
					if p.Parent and cf:PointToObjectSpace(p.Position).Y > yTop - 0.5 and lado(p) == sCol then p:Destroy() end
				end
			end
		end
		local dirDown = Vector3.new(0, -sinA, sCol * cosA)
		local nrm = Vector3.new(0, cosA, sCol * sinA)
		for x = -RL / 2 + 1.2, RL / 2 - 1.0, 2.8 do
			if rng:NextNumber() < 0.8 then
				local L = rng:NextNumber(0.25, 0.8) * len
				local deCima = rng:NextNumber() < 0.75
				local t0 = deCima and 0 or (len - L)
				local c = Vector3.new(x, rise, 0) + dirDown * (t0 + L / 2) - nrm * 0.1
				local cfp = roofCF * CFrame.fromMatrix(c, Vector3.xAxis, nrm) * CFrame.Angles(rng:NextNumber(-0.06, 0.06), 0, 0)
				P(m, "CaibroQuebrado", Vector3.new(0.5, 0.6, L), cfp, C.wood, Mat.Wood, false, true)
			end
		end
		-- canto do último andar aberto por subtração de um bloco irregular
		local top = m:FindFirstChild("Andar" .. andares)
		if top then
			local sx = (rng:NextNumber() < 0.5) and -1 or 1
			local cw, ch, cd = ww * rng:NextNumber(0.25, 0.4), FH * rng:NextNumber(0.35, 0.6), dd * rng:NextNumber(0.3, 0.55)
			local cutter = Instance.new("Part")
			cutter.Size = Vector3.new(cw * 2, ch * 2, cd * 2)
			cutter.CFrame = roofCF * CFrame.new(sx * RL / 2, 0, sCol * SP / 2) * CFrame.Angles(rng:NextNumber(-0.3, 0.3), rng:NextNumber(-0.4, 0.4), rng:NextNumber(-0.3, 0.3))
			cutter.Anchored = true
			cutter.Parent = workspace
			for _, nome in ipairs({ "VigaSup", "VigaInf", "Poste", "Escora", "Moldura", "Vidro", "TravessaV", "TravessaH", "Peitoril", "Verga", "Veneziana", "Hera", "HeraFolha" }) do
				for _, p in ipairs(porNome[nome] or {}) do
					if p.Parent then
						local l = cutter.CFrame:PointToObjectSpace(p.Position)
						if math.abs(l.X) < cw + 0.8 and math.abs(l.Y) < ch + 0.8 and math.abs(l.Z) < cd + 0.8 and cf:PointToObjectSpace(p.Position).Y > HB + 1 then p:Destroy() end
					end
				end
			end
			-- empena e viga da empena sobre o canto aberto também caem
			for _, nome in ipairs({ "EmpenaE", "EmpenaD", "VigaBaseEmpena", "PosteEmpena" }) do
				for _, p in ipairs(porNome[nome] or {}) do
					if p.Parent then
						local l = roofCF:PointToObjectSpace(p.Position)
						if (l.X >= 0) == (sx > 0) and (nome == "VigaBaseEmpena" or lado(p) == sCol) then p:Destroy() end
					end
				end
			end
			local ok, novo = pcall(function() return top:SubtractAsync({ cutter }) end)
			cutter:Destroy()
			if ok and novo then
				novo.Name = top.Name
				novo.Anchored = true
				novo.CanCollide = true
				novo.CastShadow = true
				novo.Parent = m
				top:Destroy()
			end
		end
		for _, p in ipairs(porNome.Porta or {}) do
			if p.Parent and rng:NextNumber() < 0.6 then p.CFrame = p.CFrame * CFrame.new(0, -0.6, 0.4) * CFrame.Angles(-0.35, 0, 0) end
		end
	end

	heraExtra(m, cf, o, ({ 3, 6, 10 })[nivel], rng)

	-- inclinação leve em torno do centro ao nível do chão (WorldPivot = cf)
	local tilt = ({ 0.006, 0.02, 0.04 })[nivel]
	m:PivotTo(m:GetPivot() * CFrame.Angles(rng:NextNumber(-tilt, tilt), 0, rng:NextNumber(-tilt, tilt)))
end

-- entulho ao redor da casa: tábuas, vigas, pedras e telhas caídas, assentadas no piso (rp)
function M.entulho(parent, cf, o, n, rng, rp)
	local w, d = o.w, o.d
	local ex, ez = w / 2 + 1.2, d / 2 + 1.2
	for _ = 1, n do
		local lado = rng:NextInteger(1, 4)
		local lx, lz
		if lado == 1 then lx, lz = rng:NextNumber(-ex - 3, ex + 3), -ez - rng:NextNumber(0.3, 6.5)
		elseif lado == 2 then lx, lz = rng:NextNumber(-ex - 3, ex + 3), ez + rng:NextNumber(0.3, 5)
		elseif lado == 3 then lx, lz = ex + rng:NextNumber(0.3, 4), rng:NextNumber(-ez, ez)
		else lx, lz = -ex - rng:NextNumber(0.3, 4), rng:NextNumber(-ez, ez) end
		local pos = cf * Vector3.new(lx, 0, lz)
		local base = CFrame.new(pos) * CFrame.Angles(0, rng:NextNumber(0, math.pi * 2), 0) * CFrame.Angles(rng:NextNumber(-0.12, 0.12), 0, rng:NextNumber(-0.12, 0.12))
		local tipo = rng:NextNumber()
		local p
		if tipo < 0.34 then
			p = P(parent, "Tabua", Vector3.new(0.35, 0.28, rng:NextNumber(2.2, 6)), base, C.woodDark, Mat.Wood, false, false)
		elseif tipo < 0.52 then
			p = P(parent, "VigaCaida", Vector3.new(0.7, 0.7, rng:NextNumber(4, 9)), base, C.wood, Mat.Wood, false, true)
		elseif tipo < 0.80 then
			local s = rng:NextNumber(0.5, 1.5)
			local g = rng:NextInteger(54, 92)
			p = P(parent, "Entulho", Vector3.new(s * rng:NextNumber(0.9, 1.5), s * rng:NextNumber(0.5, 0.9), s * rng:NextNumber(0.8, 1.3)), base * CFrame.Angles(0, rng:NextNumber(0, 6), 0), Color3.fromRGB(g, g - 2, g - 4), Mat.Rock, false, true)
		else
			p = P(parent, "TelhaCaida", Vector3.new(rng:NextNumber(1.2, 2.2), 0.14, rng:NextNumber(0.9, 1.4)), base, slateColor(rng), Mat.Slate, false, false)
		end
		if not assenta(p, rp, 0.3) then p:Destroy() end
	end
end

-- casa com envelhecimento: o.ruina de 0 a 3; paredes mais gastas e luz sempre apagada a partir do nível 2
function M.casaVelha(parent, cf, o)
	local nivel = o.ruina or 0
	local rng = Random.new((o.seed or 1) * 7 + 13)
	if nivel >= 2 then o.estado = "apagada" end
	local base = o.plaster or M.plasters[1]
	o.plaster = base:Lerp(Color3.fromRGB(58, 54, 48), 0.12 * nivel + (o.desbote or 0))
	local m = M.casa(parent, cf, o)
	m.WorldPivot = cf
	-- fundação escondida sob a base, para a casa nunca flutuar sobre o terreno
	P(m, "Fundacao", Vector3.new(o.w + 0.8, 3.2, o.d + 0.8), cf * CFrame.new(0, -1.6, 0), C.stoneDark, Mat.Cobblestone, false, false)
	if nivel >= 1 then envelhece(m, cf, o, nivel, rng) end
	return m
end

-- sorteios que pioram com a distância (t de 0 a 1): mais ruína e mais luzes apagadas
local function sorteiaNivel(rng, t)
	local r = rng:NextNumber()
	local p3, p2, p1 = 0.03 + 0.14 * t, 0.10 + 0.18 * t, 0.28
	if r < p3 then return 3 elseif r < p3 + p2 then return 2 elseif r < p3 + p2 + p1 then return 1 end
	return 0
end

local function sorteiaEstado(rng, t)
	local r = rng:NextNumber()
	if r < 0.20 - 0.10 * t then return "ligada" elseif r < 0.36 - 0.10 * t then return "piscando" end
	return "apagada"
end

-- no máximo maxN casas caindo aos pedaços por conjunto; as demais passam a decadentes
local function limitaRuina(plano, maxN, rng)
	local idx = {}
	for i, c in ipairs(plano) do if c.nivel == 3 then idx[#idx + 1] = i end end
	while #idx > maxN do
		local j = rng:NextInteger(1, #idx)
		plano[idx[j]].nivel = 2
		table.remove(idx, j)
	end
end

local ANDARES = { 1, 1, 2, 2, 2, 3, 3 }

-- adereços de calçada na frente da casa: lenha, barris e caixas (nunca sobre os degraus)
local function adornos(mobiliario, cf, o, rng)
	local lat = o.w / 2 - 1.2
	if lat < 6.5 then return end
	local function ponto()
		local sx = (rng:NextNumber() < 0.5) and -1 or 1
		return cf * CFrame.new(sx * rng:NextNumber(6.2, lat), 0, -(o.d / 2) - rng:NextNumber(0.8, 3.0))
	end
	if rng:NextNumber() < 0.35 then
		local p = ponto()
		M.lenha(mobiliario, CFrame.new(p.Position.X, 0.7, p.Position.Z) * CFrame.Angles(0, select(2, cf:ToOrientation()), 0), rng)
	end
	for _ = 1, rng:NextInteger(0, 2) do
		local p = ponto()
		M.barril(mobiliario, Vector3.new(p.Position.X, 0.7, p.Position.Z))
	end
	if rng:NextNumber() < 0.3 then
		local p = ponto()
		M.caixa(mobiliario, CFrame.new(p.Position.X, 0.7, p.Position.Z) * CFrame.Angles(0, rng:NextNumber(0, 6), 0))
	end
end

-- fileira de casas de um lado de uma rua cardeal (k: 0 Leste, 1 Norte, 2 Oeste, 3 Sul; lado: 1 ou -1)
-- cfg: x0, x1, rng, prefixo, semente, tBase, tSpan, forcaRuina, maxRuina, mobiliario (pasta), rp
function M.fileiraRua(parent, k, lado, cfg)
	local rng = cfg.rng
	local rot = CFrame.Angles(0, k * math.pi / 2, 0)
	local plano = {}
	local x = cfg.x0
	while true do
		local w, d = rng:NextInteger(19, 25), rng:NextInteger(16, 24)
		local ww = w + 0.6
		if x + ww > cfg.x1 then break end
		plano[#plano + 1] = { xc = x + ww / 2, w = w, d = d }
		x += ww + ((rng:NextNumber() < 0.12) and rng:NextNumber(6, 10) or rng:NextNumber(1.8, 4.0))
	end
	for _, c in ipairs(plano) do
		c.t = cfg.tBase + cfg.tSpan * ((c.xc - cfg.x0) / (cfg.x1 - cfg.x0))
		c.nivel = sorteiaNivel(rng, c.t)
		c.estado = sorteiaEstado(rng, c.t)
		c.andares = ANDARES[rng:NextInteger(1, #ANDARES)]
		c.gable = rng:NextNumber() < 0.35
		c.plaster = M.plasters[rng:NextInteger(1, #M.plasters)]
		c.Fz = 22.5 + rng:NextNumber(-1.0, 1.2)
		c.yaw = rng:NextNumber(-0.035, 0.035)
	end
	for _ = 1, (cfg.forcaRuina or 1) do
		if #plano > 0 then plano[rng:NextInteger(math.min(2, #plano), #plano)].nivel = 3 end
	end
	limitaRuina(plano, cfg.maxRuina or 2, rng)
	local feitas = {}
	for i, c in ipairs(plano) do
		local cfLocal = CFrame.new(c.xc, 0, lado * (c.Fz + c.d / 2)) * ((lado == 1) and CFrame.new() or CFrame.Angles(0, math.pi, 0)) * CFrame.Angles(0, c.yaw, 0)
		local cf = rot * cfLocal
		local nome = cfg.prefixo .. i
		local o = {
			name = nome, grupo = nome, seed = cfg.semente + i,
			w = c.w, d = c.d, andares = c.andares, plaster = c.plaster, gableFront = c.gable,
			estado = c.estado, ruina = c.nivel, desbote = 0.04 * c.t,
		}
		local m = M.casaVelha(parent, cf, o)
		if c.nivel >= 2 then M.entulho(m, cf, o, (c.nivel == 2) and rng:NextInteger(10, 16) or rng:NextInteger(26, 40), rng, cfg.rp) end
		adornos(cfg.mobiliario, cf, o, rng)
		feitas[#feitas + 1] = { nome = nome, nivel = c.nivel, estado = o.estado, xc = c.xc, w = c.w, d = c.d, andares = c.andares }
		task.wait()
	end
	return feitas
end

-- anel de casas voltadas para dentro de uma praça circular, sem novas ruas (só a entrada, em -X local)
-- 12 posições a cada 30 graus; a posição de 180 graus (a entrada) fica vazia
-- cfg: rng, prefixo, semente, tBase, forcaRuina, maxRuina, rp
function M.circuloCasas(parent, centro, rot, R, cfg)
	local rng = cfg.rng
	local plano = {}
	for j = 0, 11 do
		if j ~= 6 then
			local dist = math.abs(j - 6) / 6 -- 0 junto da entrada, 1 no ponto oposto
			plano[#plano + 1] = {
				j = j, w = rng:NextInteger(19, 23), d = rng:NextInteger(16, 24),
				t = cfg.tBase + (1 - cfg.tBase) * dist,
			}
		end
	end
	for _, c in ipairs(plano) do
		c.nivel = sorteiaNivel(rng, c.t)
		c.estado = sorteiaEstado(rng, c.t)
		c.andares = ANDARES[rng:NextInteger(1, #ANDARES)]
		c.gable = rng:NextNumber() < 0.35
		c.plaster = M.plasters[rng:NextInteger(1, #M.plasters)]
		c.jit = rng:NextNumber(-0.6, 0.6)
		c.yaw = rng:NextNumber(-0.03, 0.03)
	end
	for _ = 1, (cfg.forcaRuina or 2) do
		plano[rng:NextInteger(1, #plano)].nivel = 3
	end
	limitaRuina(plano, cfg.maxRuina or 3, rng)
	local feitas = {}
	for i, c in ipairs(plano) do
		local phi = math.rad(30 * c.j + c.jit)
		local rf = R + 4 -- frente dos andares superiores
		local rc = rf + c.d / 2 + JET
		local pos = centro + rot:VectorToWorldSpace(Vector3.new(math.cos(phi) * rc, 0, -math.sin(phi) * rc))
		local cf = CFrame.lookAt(pos, centro) * CFrame.Angles(0, c.yaw, 0)
		local nome = cfg.prefixo .. i
		local o = {
			name = nome, grupo = nome, seed = cfg.semente + i,
			w = c.w, d = c.d, andares = c.andares, plaster = c.plaster, gableFront = c.gable,
			estado = c.estado, ruina = c.nivel, desbote = 0.04 * c.t,
		}
		local m = M.casaVelha(parent, cf, o)
		if c.nivel >= 2 then M.entulho(m, cf, o, (c.nivel == 2) and rng:NextInteger(10, 16) or rng:NextInteger(26, 40), rng, cfg.rp) end
		feitas[#feitas + 1] = { nome = nome, nivel = c.nivel, estado = o.estado, j = c.j, w = c.w, d = c.d, andares = c.andares }
		task.wait()
	end
	return feitas
end
```

## Pontos de atenção
- A ordem das chamadas ao gerador aleatório define a aparência de cada casa; mexer nela muda tudo.
- `limitaRuina` e a mudança das probabilidades de `sorteiaNivel` foram acrescentadas depois de o sorteio original produzir ruínas demais (ver [[Casas em ruína - Níveis de envelhecimento]]).
- `casaVelha` precisa de `m.WorldPivot = cf` antes de inclinar e para o carregamento por distância (ver [[Carregamento por distância - Pivôs dos Models novos]]).
- O recorte por `SubtractAsync` só roda em Edit.

## Relacionados
- [[Módulo ConstrutorVilaGrande - Código parte 2 casa]]
- [[Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção]]
- [[Casas das ruas - Fileiras variadas e luzes apagadas]]
- [[Praça circular - Anel de casas voltadas para dentro]]
- [[Módulo ConstrutorVilaGrande - Visão geral e API]]
