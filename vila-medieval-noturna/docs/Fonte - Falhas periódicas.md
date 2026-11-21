---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, fonte, script]
---
# Fonte - Falhas periódicas
Índice: Jogos - Gerais

## Conceito
- A fonte "falha" de tempos em tempos: o jato e as bicas engasgam, secam ou pingam, e depois voltam a jorrar. O comportamento está num Script chamado "FonteFalha", filho do Model "Fonte". Cada nível (0 a 3) tem seu próprio ciclo independente.

## Ciclos
- Nível 0 (jato central): funcionamento normal de 6 a 14 s entre falhas.
- Nível 3: de 10 a 22 s.
- Nível 2: de 12 a 26 s.
- Nível 1: de 14 a 30 s.
- Cada ciclo começa com uma espera aleatória de 0 a 6 s.

## Tipos de falha (escolhido ao acaso)
1. **Engasgo**: de 4 a 8 pulsos (taxa de 30 a 100%) com 0,08 a 0,35 s ligado e 0,1 a 0,55 s desligado; depois pausa de 2 a 6 s.
2. **Fraqueza**: a pressão cai de 100% a 30% em passos de 0,2 s e fica fraca por 3 a 7 s.
3. **Pingar**: a pressão cai a 10% em passos de 0,18 s, desliga tudo e deixa um emissor pingando (taxa 4) por 3 a 6 s.
- Depois de qualquer falha: retomada gradual em dez passos de 0,12 s, com 20% de chance de "tosse" (desliga 0,12 s) em cada passo.

## Código
```lua
local fonte = script.Parent
local niveis = {}
for _, d in ipairs(fonte:GetDescendants()) do
	if d:IsA("ParticleEmitter") then
		local n = d:GetAttribute("Nivel")
		if n then
			niveis[n] = niveis[n] or {}
			table.insert(niveis[n], { e = d, base = d.Rate })
		end
	end
end
local rng = Random.new()

local function pressao(list, f)
	for _, it in ipairs(list) do it.e.Rate = math.max(it.base * f, 0.5) end
end
local function liga(list, on)
	for _, it in ipairs(list) do it.e.Enabled = on end
end

local function ciclo(n, minOn, maxOn)
	local list = niveis[n]
	if not list then return end
	task.spawn(function()
		task.wait(rng:NextNumber(0, 6))
		while true do
			pressao(list, 1); liga(list, true)
			task.wait(rng:NextNumber(minOn, maxOn))
			local tipo = rng:NextInteger(1, 3)
			if tipo == 1 then
				for _ = 1, rng:NextInteger(4, 8) do
					pressao(list, rng:NextNumber(0.3, 1)); liga(list, true)
					task.wait(rng:NextNumber(0.08, 0.35))
					liga(list, false)
					task.wait(rng:NextNumber(0.1, 0.55))
				end
				task.wait(rng:NextNumber(2, 6))
			elseif tipo == 2 then
				for i = 10, 3, -1 do pressao(list, i / 10); task.wait(0.2) end
				task.wait(rng:NextNumber(3, 7))
			else
				for i = 10, 1, -1 do pressao(list, i / 10); task.wait(0.18) end
				liga(list, false)
				local pingo = list[rng:NextInteger(1, #list)]
				pingo.e.Rate = 4; pingo.e.Enabled = true
				task.wait(rng:NextNumber(3, 6))
				pingo.e.Enabled = false
			end
			liga(list, true)
			for i = 1, 10 do
				pressao(list, i / 10)
				if rng:NextNumber() < 0.2 then liga(list, false); task.wait(0.12); liga(list, true) end
				task.wait(0.12)
			end
		end
	end)
end
ciclo(0, 6, 14)
ciclo(3, 10, 22)
ciclo(2, 12, 26)
ciclo(1, 14, 30)
```

## Verificação
- Em teste, o jato central alternou entre ligado e desligado em períodos de cerca de 5 a 20 s, com sequências de pulsos curtos.
- Para checar: em Play, no datamodel Server, ler `Enabled` do emissor de Nivel 0 a cada 0,5 s durante 30 s.

## Relacionados
- Fonte - Jatos, bicas e respingos
- Módulo ConstrutorVilaGrande - Código parte 6 fonte
