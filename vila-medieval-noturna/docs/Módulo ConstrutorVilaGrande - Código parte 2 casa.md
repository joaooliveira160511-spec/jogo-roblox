---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, casa]
---
# Módulo ConstrutorVilaGrande - Código parte 2 casa
Índice: Jogos - Gerais

## Conceito
- Função `M.casa`, que monta uma casa completa: base de pedra, porta, janelas do térreo, andares de madeira com enxaimel e balanço, telhado em fiadas, empenas, trapeiras, chaminé, placa (opcional) e hera. Vem depois da Módulo ConstrutorVilaGrande - Código parte 1 base e luzes.

## Código
```lua
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
```

## Pontos de atenção
- A telha usa `CFrame.fromMatrix(posição, Vector3.xAxis, n)`, em que `n` é a normal da água; o eixo Z do quadro resultante pode apontar para cima em um dos lados, o que não importa porque a peça é simétrica em Z.
- A segunda janela da frente de cada andar recebe PointLight (`luzIdx = 2`); a primeira janela do térreo também (`k == 1`).
- A ordem das chamadas a `rng` define a aparência de cada casa; alterar a ordem muda cores e venezianas.

## Relacionados
- Casa - Telhado em fiadas de telhas
- Casas - Posicionamento no anel da praça
