---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, codigo, fonte]
---
# Módulo ConstrutorVilaGrande - Código parte 6 fonte
Índice: Jogos - Gerais

## Conceito
- Emissor de partículas da fonte, o script de falhas (texto em string) e a versão final de `M.fonte` (sem câmara, bacia fechada, pedestal maciço, pedra limpa). No arquivo real, `emissor` e `FONTE_SCRIPT` ficam antes da versão antiga de `M.fonte`, e a versão final é definida no fim, antes de `return M`.

## Emissor
```lua
local function emissor(part, nivel, taxa, vel, spread, vida, tam)
	local e = Instance.new("ParticleEmitter")
	e.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	e.Rate = taxa
	e.Lifetime = NumberRange.new(vida * 0.9, vida * 1.1)
	e.Speed = NumberRange.new(vel * 0.92, vel * 1.08)
	e.SpreadAngle = Vector2.new(spread, spread)
	e.Acceleration = Vector3.new(0, -30, 0)
	e.Color = ColorSequence.new(Color3.fromRGB(205, 228, 255))
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, tam), NumberSequenceKeypoint.new(1, tam * 0.6) })
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.8, 0.45), NumberSequenceKeypoint.new(1, 1) })
	e.LightEmission = 0.5
	e.LightInfluence = 0.2
	e:SetAttribute("Nivel", nivel)
	e.Parent = part
	return e
end
```

## Script de falhas
- `local FONTE_SCRIPT = [==[ ... ]==]` contém o texto do script mostrado em Fonte - Falhas periódicas; a função `M.fonte` cria um `Script` chamado "FonteFalha" com essa string em `Source`.

## Função final M.fonte
```lua
function M.fonte(parent, pos)
	M.variant[Mat.Cobblestone] = nil  -- pedra lisa e limpa, sem as rachaduras do material gerado
	local PA, PB, PL, PD = Color3.fromRGB(66, 66, 70), Color3.fromRGB(57, 57, 61), Color3.fromRGB(80, 80, 86), Color3.fromRGB(46, 46, 50)
	local m = Instance.new("Model")
	m.Name = "Fonte"
	local b = pos.Y
	local x, z = pos.X, pos.Z
	local function at(y) return Vector3.new(x, y, z) end
	local T = workspace.Terrain

	local function anel(nome, n, raio, y, h, grossura, cor1, cor2, colide)
		local tang = 2 * math.pi * raio / n * 1.04
		for k = 0, n - 1 do
			local ang = k * 2 * math.pi / n
			local p = Vector3.new(x + math.cos(ang) * raio, y, z + math.sin(ang) * raio)
			P(m, nome, Vector3.new(tang, h, grossura), CFrame.lookAt(p, at(y)), (k % 2 == 0) and cor1 or cor2, Mat.Cobblestone, colide)
		end
	end
	local function agua(raio, y0, y1)
		T:FillCylinder(CFrame.new(x, (y0 + y1) / 2, z), y1 - y0, raio, Enum.Material.Water)
	end
	local function bicas(nivel, n, raio, y, vel, vida, taxa, tam, off)
		for k = 0, n - 1 do
			local ang = off + k * 2 * math.pi / n
			local dir = Vector3.new(math.cos(ang), 0, math.sin(ang))
			local p = at(y) + dir * raio
			P(m, "Gargula", Vector3.new(1.1, 1.1, 2.4), CFrame.lookAt(p + dir * 0.9, p + dir * 3), PD, Mat.Cobblestone, false)
			P(m, "Focinho", Vector3.new(0.8, 0.8, 0.5), CFrame.lookAt(p + dir * 2.2, p + dir * 4), PB, Mat.Cobblestone, false, false)
			local bica = P(m, "Bica", Vector3.new(0.3, 0.3, 0.3), CFrame.lookAt(p + dir * 2.6, p + dir * 5), PA, Mat.Plastic, false, false)
			bica.Transparency = 1
			local e = emissor(bica, nivel, taxa, vel, 3.5, vida, tam)
			e.EmissionDirection = Enum.NormalId.Front
		end
	end
	local function respingos(nivel, n, raio, y, taxa)
		for k = 0, n - 1 do
			local ang = k * 2 * math.pi / n
			local p = P(m, "Respingo", Vector3.new(0.3, 0.3, 0.3), CFrame.new(x + math.cos(ang) * raio, y, z + math.sin(ang) * raio), PA, Mat.Plastic, false, false)
			p.Transparency = 1
			local e = emissor(p, nivel, taxa, 5, 80, 0.55, 0.7)
			e.Acceleration = Vector3.new(0, -26, 0)
		end
	end

	-- bacia principal fechada (sem abertura), degrau externo e pilastras
	Cyl(m, "FundoBacia", 27.6, 0.6, at(b + 0.3), PD, Mat.Cobblestone)
	anel("ParedeBacia", 56, 26.2, b + 3, 6, 3.0, PA, PB, true)
	anel("CapaBacia", 56, 26.2, b + 6.4, 0.9, 4.3, PL, PL, false)
	anel("DegrauBacia", 64, 30.6, b + 0.8, 1.6, 2.8, PD, PB, true)
	for k = 0, 7 do
		local ang = k * math.pi / 4 + math.pi / 8
		local p = Vector3.new(x + math.cos(ang) * 27.6, b + 4.2, z + math.sin(ang) * 27.6)
		P(m, "Pilastra", Vector3.new(2.6, 8.4, 2.6), CFrame.lookAt(p, at(b + 4.2)), PL, Mat.Cobblestone)
		local orb = P(m, "PilastraTopo", Vector3.new(2.2, 2.2, 2.2), CFrame.new(p + Vector3.new(0, 5.2, 0)), PA, Mat.Cobblestone, false)
		orb.Shape = Enum.PartType.Ball
	end
	agua(24.8, b + 0.6, b + 4.2)

	-- pedestal central maciço (nada habitável dentro)
	Cyl(m, "PedestalCentral", 10.5, 16, at(b + 8), PA, Mat.Cobblestone)
	Cyl(m, "ColarPedestalBase", 11.5, 1.4, at(b + 1.1), PL, Mat.Cobblestone, false)
	Cyl(m, "ColarPedestalTopo", 11.3, 1.2, at(b + 15.4), PL, Mat.Cobblestone, false)
	anel("PilastraPedestal", 14, 10.9, b + 8.6, 14, 1.2, PB, PD, false)
	Cyl(m, "PratoMedio", 17, 1.2, at(b + 16.6), PA, Mat.Cobblestone)

	-- nível 1
	anel("BordaMedia", 40, 16.2, b + 18.7, 3, 1.7, PA, PL, false)
	agua(14.4, b + 17.2, b + 19.2)
	Cyl(m, "ColarColuna1", 6.2, 0.8, at(b + 17.6), PL, Mat.Cobblestone, false)
	Cyl(m, "Coluna1", 4.6, 11.8, at(b + 23.1), PL, Mat.Cobblestone)
	Cyl(m, "ColarColuna1b", 5.6, 0.8, at(b + 28.6), PL, Mat.Cobblestone, false)
	-- nível 2
	Cyl(m, "BaciaN2", 11, 1.2, at(b + 29.6), PA, Mat.Cobblestone)
	anel("BordaN2", 28, 10.6, b + 31.5, 2.6, 1.5, PA, PL, false)
	agua(9.5, b + 30.2, b + 31.8)
	Cyl(m, "Coluna2", 2.6, 9.8, at(b + 35.1), PL, Mat.Cobblestone)
	Cyl(m, "ColarColuna2", 3.6, 0.8, at(b + 39.6), PL, Mat.Cobblestone, false)
	-- nível 3
	Cyl(m, "BaciaN3", 6.5, 1.0, at(b + 40.5), PA, Mat.Cobblestone)
	anel("BordaN3", 20, 6.2, b + 42.1, 2.2, 1.1, PA, PL, false)
	agua(5.5, b + 41.0, b + 42.3)
	Cyl(m, "Coluna3", 1.3, 6, at(b + 44), PL, Mat.Cobblestone)
	Cyl(m, "Pinaculo", 0.9, 2, at(b + 47.8), PA, Mat.Cobblestone, false)
	local orb = P(m, "Esfera", Vector3.new(3.4, 3.4, 3.4), CFrame.new(at(b + 49.4)), PL, Mat.Cobblestone, false)
	orb.Shape = Enum.PartType.Ball

	-- jato central e bicas
	local jato = P(m, "Jato", Vector3.new(0.3, 0.3, 0.3), CFrame.new(at(b + 51.4)), PA, Mat.Plastic, false, false)
	jato.Transparency = 1
	emissor(jato, 0, 240, 30, 5, 2.3, 0.65)
	bicas(3, 4, 6.6, b + 42.9, 2.2, 0.9, 70, 0.5, math.pi / 4)
	bicas(2, 6, 11.0, b + 32.4, 2.6, 0.95, 80, 0.55, 0)
	bicas(1, 8, 16.5, b + 19.7, 4.8, 1.05, 110, 0.6, math.pi / 8)
	respingos(0, 3, 2.0, b + 42.4, 22)
	respingos(3, 4, 8.5, b + 31.9, 14)
	respingos(2, 6, 13.4, b + 19.3, 16)
	respingos(1, 12, 21.5, b + 4.4, 20)
	local nev = P(m, "Neblina", Vector3.new(0.3, 0.3, 0.3), CFrame.new(at(b + 5.5)), PA, Mat.Plastic, false, false)
	nev.Transparency = 1
	local ne = Instance.new("ParticleEmitter")
	ne.Texture = "rbxasset://textures/particles/smoke_main.dds"
	ne.Rate = 6
	ne.Lifetime = NumberRange.new(7, 10)
	ne.Speed = NumberRange.new(0.8, 1.6)
	ne.SpreadAngle = Vector2.new(180, 180)
	ne.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 12), NumberSequenceKeypoint.new(1, 26) })
	ne.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.94), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 1) })
	ne.Color = ColorSequence.new(Color3.fromRGB(150, 170, 210))
	ne.LightInfluence = 0.6
	ne:SetAttribute("Nivel", 1)
	ne.Parent = nev

	local s = Instance.new("Script")
	s.Name = "FonteFalha"
	s.Source = FONTE_SCRIPT
	s.Parent = m
	m.Parent = parent
	return m
end

return M
```

## Chamada usada
```lua
-- limpar água antiga, depois construir
workspace.Terrain:FillBlock(CFrame.new(0, 45, 0), Vector3.new(80, 90, 80), Enum.Material.Air)
V.fonte(workspace.Vila, Vector3.new(0, 0.5, 0))
-- passe de resfriamento das cores da pedra
for _, p in ipairs(workspace.Vila.Fonte:GetDescendants()) do
	if p:IsA("BasePart") and p.Material == Enum.Material.Cobblestone then
		local c = p.Color
		p.Color = Color3.new(c.R * 0.88, c.G * 0.96, math.min(c.B * 1.14, 1))
	end
end
```

## Relacionados
- Fonte - Estrutura em níveis
- Módulo ConstrutorVilaGrande - Visão geral e API
