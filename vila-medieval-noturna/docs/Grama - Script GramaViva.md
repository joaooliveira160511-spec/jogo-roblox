---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, grama, script]
---
# Grama - Script GramaViva
Índice: [[Jogos - Gerais]]

## Conceito
- LocalScript em `StarterPlayer.StarterPlayerScripts.GramaViva`. Anima a grama no cliente: vento, empurrão de quem passa, brilho do luar (ver [[Grama - Reflexo da Lua]]), carregamento por distância e os vagalumes (ver [[Vagalumes - Script e parâmetros]]).

## Funcionamento
1. Espera as lâminas replicarem (a contagem de filhos fica estável por 1 s).
2. Monta caches por lâmina: parte, CFrame original, posição da base (centro menos metade da altura ao longo do vetor de cima), CFrame relativo, vetor de cima de repouso, cor-base e fase.
3. Cria uma grade espacial de células de 6 studs para achar rápido as lâminas perto da câmera.
4. A cada frame (RenderStepped), para as lâminas a menos de 42 studs da câmera:
   - Vento: rajadas por ruído e balanço individual por seno; amplitude `(0,07 + 0,16*gust) * borda`.
   - Empurrão: cada jogador (HumanoidRootPart) empurra as lâminas num raio de 7,5 com força suavizada (smoothstep) e arrasto na direção do movimento (0,03 por stud/s).
   - Mola amortecida (K = 45, C = 4,5) leva a curvatura (x, z) ao alvo, voltando balançando.
   - A lâmina é inclinada com `CFrame.fromAxisAngle` (ângulo máximo 1,5 rad) em torno de um eixo perpendicular à direção da curvatura.
   - Todas as peças movidas no frame são atualizadas com `workspace:BulkMoveTo(..., FireCFrameChanged)`.
   - As que saíram do raio voltam ao CFrame original.
5. Em paralelo, 260 lâminas por frame recebem nova cor (brilho do luar).
6. A cada 0,4 s, células além de 160 studs são removidas (`Parent = nil`) e voltam a menos de 140.

## Parâmetros
- WIND_RADIUS 42; PUSH_RADIUS 7,5; PUSH_BEND 1,5; SPRING_K 45; SPRING_C 4,5; COLORS_PER_FRAME 260; CELL 6; SILVER (215,232,255); LOAD_DIST 140; UNLOAD_DIST 160.

## Código
```lua
-- GramaViva: grama que se curva sob o vento e ao ser pisada, com brilho do luar e vagalumes.
-- Roda apenas no cliente; as lâminas (Workspace.Grama) já existem no mapa.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

if not game:IsLoaded() then game.Loaded:Wait() end

local camera = workspace.CurrentCamera
local gramaRoot = workspace:WaitForChild("Grama")

-- espera as lâminas terminarem de replicar (a contagem fica estável)
local function countBlades()
	local c = 0
	for _, f in ipairs(gramaRoot:GetChildren()) do c += #f:GetChildren() end
	return c
end
local last, stable = -1, 0
while stable < 5 do
	local c = countBlades()
	if c == last and c > 0 then stable += 1 else stable = 0; last = c end
	task.wait(0.2)
end

-- ===== parâmetros =====
local WIND_RADIUS = 42      -- só a grama perto da câmera é animada
local PUSH_RADIUS = 7.5     -- alcance do empurrão de quem passa
local PUSH_BEND = 1.5       -- inclinação máxima (rad) ao ser pisada
local SPRING_K, SPRING_C = 45, 4.5
local COLORS_PER_FRAME = 260
local CELL = 6
local SILVER = Color3.fromRGB(215, 232, 255)

local W2, R2 = WIND_RADIUS * WIND_RADIUS, PUSH_RADIUS * PUSH_RADIUS

-- ===== cache das lâminas =====
local parts, origCF, relCF, basePos, restUp, baseColor, phase = {}, {}, {}, {}, {}, {}, {}
local N = 0
for _, d in ipairs(gramaRoot:GetDescendants()) do
	if d:IsA("WedgePart") then
		N += 1
		local cf = d.CFrame
		local up = cf.UpVector
		local b = cf.Position - up * (d.Size.Y / 2)
		parts[N] = d
		origCF[N] = cf
		basePos[N] = b
		relCF[N] = CFrame.new(b):Inverse() * cf
		restUp[N] = up
		baseColor[N] = d.Color
		phase[N] = (b.X * 12.9898 + b.Z * 78.233) % 6.2831
	end
end

-- grade espacial para achar rápido as lâminas perto da câmera
local grid = {}
local function key(ix, iz) return ix * 2048 + iz end
for i = 1, N do
	local b = basePos[i]
	local k = key(math.floor(b.X / CELL), math.floor(b.Z / CELL))
	local c = grid[k]
	if not c then c = {}; grid[k] = c end
	c[#c + 1] = i
end

-- estado de cada lâmina (mola amortecida: curvatura x/z e velocidade)
local sx, sz, vx, vz, stamp = table.create(N, 0), table.create(N, 0), table.create(N, 0), table.create(N, 0), table.create(N, 0)

local moonDir = Lighting:GetMoonDirection().Unit
local frame, prev, colorCursor = 0, {}, 1

-- ===== carregamento por distância (a neblina esconde o que fica longe) =====
local LOAD_DIST, UNLOAD_DIST = 140, 160
local cells = {}
for _, c in pairs(grid) do
	local b = basePos[c[1]]
	cells[#cells + 1] = { x = (math.floor(b.X / CELL) + 0.5) * CELL, z = (math.floor(b.Z / CELL) + 0.5) * CELL, list = c, loaded = true }
end
local function setCell(cell, load)
	cell.loaded = load
	local parent = load and gramaRoot or nil
	for j = 1, #cell.list do parts[cell.list[j]].Parent = parent end
end
local function atualizaCarga()
	local cp = camera.CFrame.Position
	for _, cell in ipairs(cells) do
		local dx, dz = cell.x - cp.X, cell.z - cp.Z
		local d2 = dx * dx + dz * dz
		if cell.loaded then
			if d2 > UNLOAD_DIST * UNLOAD_DIST then setCell(cell, false) end
		elseif d2 < LOAD_DIST * LOAD_DIST then
			setCell(cell, true)
		end
	end
end
atualizaCarga()
task.spawn(function()
	while true do
		task.wait(0.4)
		atualizaCarga()
	end
end)

RunService.RenderStepped:Connect(function(dtRaw)
	frame += 1
	local dt = math.min(dtRaw, 1 / 30)
	local t = os.clock()
	local camPos = camera.CFrame.Position
	local cx, cz = camPos.X, camPos.Z

	-- quem está pisando na grama
	local mx, mz, mvx, mvz, mn = {}, {}, {}, {}, 0
	for _, pl in ipairs(Players:GetPlayers()) do
		local ch = pl.Character
		local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
		if hrp then
			mn += 1
			mx[mn], mz[mn] = hrp.Position.X, hrp.Position.Z
			local vel = hrp.AssemblyLinearVelocity
			mvx[mn], mvz[mn] = vel.X, vel.Z
		end
	end

	local wa = 0.6 + math.sin(t * 0.05) * 0.4
	local wdx, wdz = math.cos(wa), math.sin(wa)

	local list, ps, cfs, n = {}, {}, {}, 0
	for ix = math.floor((cx - WIND_RADIUS) / CELL), math.floor((cx + WIND_RADIUS) / CELL) do
		for iz = math.floor((cz - WIND_RADIUS) / CELL), math.floor((cz + WIND_RADIUS) / CELL) do
			local c = grid[key(ix, iz)]
			if c then
				for j = 1, #c do
					local i = c[j]
					local b = basePos[i]
					local bx, bz = b.X, b.Z
					local dx, dz = bx - cx, bz - cz
					local d2 = dx * dx + dz * dz
					if d2 < W2 then
						-- vento: rajadas lentas + balanço individual
						local edge = math.clamp((WIND_RADIUS - math.sqrt(d2)) / 8, 0, 1)
						local gust = 0.55 + math.noise(bx * 0.04 + t * 0.3, bz * 0.04 - t * 0.22) * 1.1
						local amp = (0.07 + 0.16 * gust) * edge
						local sw = math.sin(t * 1.8 + phase[i] + bx * 0.12) * 0.045 * edge
						local tx, tz = wdx * amp + sw, wdz * amp + sw * 0.6

						-- empurrão de quem passa
						for m = 1, mn do
							local ddx, ddz = bx - mx[m], bz - mz[m]
							local dd = ddx * ddx + ddz * ddz
							if dd < R2 then
								local d = math.sqrt(dd) + 1e-3
								local f = 1 - d / PUSH_RADIUS
								f = f * f * (3 - 2 * f)
								local s = PUSH_BEND * f / d
								tx += ddx * s + mvx[m] * 0.03 * f
								tz += ddz * s + mvz[m] * 0.03 * f
							end
						end

						-- mola amortecida: volta balançando
						local x, z, ux, uz = sx[i], sz[i], vx[i], vz[i]
						ux += (SPRING_K * (tx - x) - SPRING_C * ux) * dt
						uz += (SPRING_K * (tz - z) - SPRING_C * uz) * dt
						x += ux * dt
						z += uz * dt
						sx[i], sz[i], vx[i], vz[i] = x, z, ux, uz
						stamp[i] = frame

						n += 1
						list[n] = i
						ps[n] = parts[i]
						local mag = math.sqrt(x * x + z * z)
						if mag < 1e-3 then
							cfs[n] = origCF[i]
						else
							cfs[n] = CFrame.new(b) * CFrame.fromAxisAngle(Vector3.new(z / mag, 0, -x / mag), math.min(mag, 1.5)) * relCF[i]
						end
					end
				end
			end
		end
	end

	-- lâminas que saíram do raio voltam à pose original
	for k = 1, #prev do
		local i = prev[k]
		if stamp[i] ~= frame then
			sx[i], sz[i], vx[i], vz[i] = 0, 0, 0, 0
			n += 1
			ps[n] = parts[i]
			cfs[n] = origCF[i]
		end
	end
	prev = list
	if n > 0 then
		workspace:BulkMoveTo(ps, cfs, Enum.BulkMoveMode.FireCFrameChanged)
	end

	-- reflexo da Lua: trilha de brilho (como no mar) na direção da Lua, cintilando com a curvatura
	for _ = 1, COLORS_PER_FRAME do
		colorCursor += 1
		if colorCursor > N then colorCursor = 1 end
		local i = colorCursor
		local u = restUp[i]
		local x, z = sx[i], sz[i]
		if x ~= 0 or z ~= 0 then
			u = Vector3.new(u.X + x * 0.9, u.Y, u.Z + z * 0.9).Unit
		end
		local v = (camPos - (basePos[i] + Vector3.yAxis * 1.5)).Unit
		local spec = math.max(u:Dot((moonDir + v).Unit), 0) ^ 10
		local lit = math.max(u:Dot(moonDir), 0)
		local k = math.min(spec * (0.9 + 0.3 * math.sin(t * 3 + phase[i])) + lit * 0.10, 1)
		parts[i].Color = baseColor[i]:Lerp(SILVER, k)
	end
end)

-- ===== vagalumes =====
local ffFolder = Instance.new("Folder")
ffFolder.Name = "Vagalumes"
ffFolder.Parent = workspace
local rngF = Random.new(5)
local flies = {}
for i = 1, 45 do
	local p = Instance.new("Part")
	p.Shape = Enum.PartType.Ball
	p.Size = Vector3.new(0.28, 0.28, 0.28)
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(205, 255, 140)
	p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
	local l = Instance.new("PointLight")
	l.Color = Color3.fromRGB(190, 255, 150)
	l.Range = 8
	l.Brightness = 1.5
	l.Shadows = false
	l.Parent = p
	p.Parent = ffFolder
	flies[i] = {
		part = p, light = l,
		base = Vector3.new(rngF:NextNumber(-38, 38), rngF:NextNumber(1.8, 4.8), rngF:NextNumber(-38, 38)),
		a = rngF:NextNumber(0, 6.28), b = rngF:NextNumber(0, 6.28), c = rngF:NextNumber(0, 6.28),
		f = rngF:NextNumber(0.8, 1.6),
	}
end

RunService.Heartbeat:Connect(function()
	local t = os.clock()
	local ps, cfs = table.create(#flies), table.create(#flies)
	for i, fl in ipairs(flies) do
		local bp = fl.base
		ps[i] = fl.part
		cfs[i] = CFrame.new(
			bp.X + math.sin(t * 0.45 + fl.a) * 3.2,
			bp.Y + math.sin(t * 0.9 + fl.b) * 0.9,
			bp.Z + math.cos(t * 0.38 + fl.c) * 3.2
		)
		local s = (0.5 + 0.5 * math.sin(t * fl.f * 1.7 + fl.a * 3)) ^ 3
		fl.light.Brightness = 0.1 + 2.2 * s
		fl.part.Transparency = 0.85 - 0.85 * s
	end
	workspace:BulkMoveTo(ps, cfs, Enum.BulkMoveMode.FireCFrameChanged)
end)
```

## Exceções e limites
- O cache é montado uma única vez; lâminas criadas depois do início não são animadas.
- As lâminas removidas pelo carregamento por distância continuam referenciadas em tabelas e seguem recebendo mudanças de cor.
- Teste numérico de empurrão: andando a 16 studs/s, 56 de 154 lâminas num raio de 7,5 ficaram bem inclinadas (UpVector.Y < 0,8).

## Revisão - grama toda carregada
- Sem neblina, `LOAD_DIST, UNLOAD_DIST` passaram de 140 e 160 para 1000 e 1100, de modo que nenhuma célula de grama é descarregada. A animação continua restrita a 42 studs em torno da câmera.
- As lâminas recarregadas por uma célula voltam como filhas diretas de `Workspace.Grama`, e não mais nas duas pastas internas do mapa em Edit; qualquer contagem de lâminas feita de fora deve percorrer os descendentes (ver [[Casa da cobertura - Tela preta até o mundo carregar]]). O trecho "Funcionamento" acima, com 140 e 160 e a contagem por filhos de filhos, descreve a primeira versão do script.

## Revisão - guarda do interior
- Dentro da casa da cobertura a câmera fica a mais de 2000 studs da vila: sem uma guarda, toda a grama seria descarregada e voltaria de uma só vez na saída (o mundo carregando tarde). O script (9221 bytes) ganhou a função `noInterior`, que lê o atributo `InteriorAtivo` do Workspace (mantido em `true` pelo `CasaCobertura` enquanto o jogador está dentro; ver [[Casa da cobertura - Mundo mantido carregado ao entrar e sair]]), e duas guardas que retornam cedo. As células e as lâminas ficam como estão; os vagalumes, que andam no `Heartbeat`, não são afetados.
- Logo antes de `atualizaCarga`, depois de `setCell`:

```lua
-- Dentro da casa da cobertura a câmera fica a mais de 2000 studs da vila: sem esta guarda, toda a grama seria descarregada e
-- voltaria de uma só vez na saída (o mundo carregando tarde). O CasaCobertura marca o interior no atributo InteriorAtivo.
local function noInterior() return workspace:GetAttribute("InteriorAtivo") == true end
local function atualizaCarga()
	if noInterior() then return end
	-- ... (o restante da função é o mesmo)
```

- No início do passo de renderização (vento, empurrão e reflexo da Lua):

```lua
RunService.RenderStepped:Connect(function(dtRaw)
	if noInterior() then return end -- nada de vento nem de reflexo da Lua enquanto a vila está longe da câmera
	frame += 1
	-- ... (o restante do passo é o mesmo)
```

## Revisão - vagalumes também parados dentro da casa
- A última frase do primeiro parágrafo da revisão anterior ("os vagalumes, que andam no `Heartbeat`, não são afetados") deixou de valer. O laço de `Heartbeat` dos vagalumes, a última parte do script, passou a começar com a mesma guarda:

```lua
RunService.Heartbeat:Connect(function()
	if noInterior() then return end -- dentro da casa os vagalumes (e as 45 luzes deles) ficam parados, como a grama
	local t = os.clock()
	-- ... (o restante do laço é o mesmo)
```

- O script passou a ter 9335 bytes. Fora da casa nada mudou; dentro, as 45 peças e luzes deixam de ser reescritas a cada quadro.

## Revisão - substituído pela versão 2
- Todo o texto acima descreve a primeira versão do `GramaViva`, que foi trocada por uma reescrita de 351 linhas e 12.763 bytes (código completo na nota da versão 2, em Relacionados). A cópia da versão 1 fica desligada em `ServerStorage.GramaViva_v1_backup`.
- O que mudou: o cache vem só de `Workspace.Grama.Relva`, lido pelos nomes `b<n>_<k>` (base, ponta e espiga de cada lâmina); não há mais reflexo prateado da Lua; deixou de existir o carregamento e o descarregamento por distância (as revisões "grama toda carregada" não se aplicam mais); cada lâmina tem duas molas (base firme, ponta solta) e o vento é uma onda de rajadas calculada por célula de 4 studs.
- Custo: só a relva a até 34 studs da câmera se move, a cada quadro até 13 studs, a cada 2 quadros até 23 e a cada 4 quadros além disso; as células sob um jogador sempre a cada quadro. Uma escala de 0,5 a 1 encolhe o raio sozinha se o custo médio passar de 3,2 ms.
- Mantidos sem mudança: a guarda `noInterior` (no passo de renderização e nos vagalumes) e os 45 vagalumes. Os números do empurrão e do teste da v1 acima não valem para a v2 (raio de empurrão de 6,5 studs, inclinação máxima de 1,35 rad).

## Relacionados
- [[Grama - Geração das lâminas]]
- [[Carregamento por distância - Script NevoaDistante]]
- [[Vila Medieval - Varredura geral de bugs]]
- [[Script GramaViva - Código completo da versão 2]]
- [[Grama - Relva densa em dois segmentos]]
