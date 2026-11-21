---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, posicionamento]
---
# Casas - Posicionamento no anel da praça
Índice: Jogos - Gerais

## Conceito
- Doze casas formam um anel ao redor da praça, três por quadrante, com as fachadas coladas em fachada contínua e as portas voltadas para o centro. As quatro bocas de rua ficam livres.

## Parâmetros
- Ângulos base por quadrante: 22,7, 45 e 67,3 graus, somados a q*90 para q de 0 a 3, com jitter de ±0,6 graus; o ângulo é medido do eixo +X para -Z: `pos = (cos(ang)*rc, 0, -sin(ang)*rc)`.
- Frente dos andares superiores em rf = 62; centro da casa em `rc = rf + d/2 + 2,4` (2,4 é o balanço dos andares superiores).
- Orientação: `CFrame.lookAt(pos, (0,0,0))` com guinada aleatória de ±0,02 rad. A frente da casa é o -Z local.
- Largura w de 22 a 24, profundidade d de 18 a 24, andares superiores de 2 a 3, `gableFront` (empena de frente) com 35% de probabilidade.
- Sementes: Random 1618 para os parâmetros; `seed = 300 + n` dentro de cada casa; cor de parede aleatória em `M.plasters`.

## Estados de luz
- Doze estados embaralhados (Fisher-Yates com Random 31415) a partir de: 4 ligadas, 3 piscando e 5 apagadas.
- Cada casa recebe um nome ("Casa1" a "Casa12") e um grupo ("casa1" a "casa12"), usados pelo sistema de luzes (ver Luzes - Sistema de estados).

## Código de criação (resumo)
```lua
local V = require(game.ServerStorage.ConstrutorVilaGrande_run)
local casas = Instance.new("Folder"); casas.Name = "Casas"; casas.Parent = workspace.Vila
local rs = Random.new(31415)
local estados = { "ligada","ligada","ligada","piscando","piscando","piscando","apagada","apagada","apagada","apagada","apagada","ligada" }
for i = #estados, 2, -1 do local j = rs:NextInteger(1, i); estados[i], estados[j] = estados[j], estados[i] end
local rng = Random.new(1618)
local n = 0
for q = 0, 3 do
	for _, base in ipairs({ 22.7, 45, 67.3 }) do
		n += 1
		local ang = math.rad(base + q * 90 + rng:NextNumber(-0.6, 0.6))
		local w = rng:NextInteger(22, 24)
		local d = rng:NextInteger(18, 24)
		local rf = 62
		local rc = rf + d / 2 + 2.4
		local pos = Vector3.new(math.cos(ang) * rc, 0, -math.sin(ang) * rc)
		V.casa(casas, CFrame.lookAt(pos, Vector3.zero) * CFrame.Angles(0, rng:NextNumber(-0.02, 0.02), 0), {
			name = "Casa" .. n, grupo = "casa" .. n, seed = 300 + n,
			w = w, d = d, andares = rng:NextInteger(2, 3),
			plaster = V.plasters[rng:NextInteger(1, #V.plasters)],
			gableFront = rng:NextNumber() < 0.35,
			estado = estados[n],
		})
		if n % 3 == 0 then task.wait() end
	end
end
```
- Observação: a chamada original também sorteava `placa` com 50% de chance; as placas foram removidas (ver Casas - Placas removidas).

## Exceções e limites
- Com larguras de até 24, os cantos frontais ficam a mais de 11,3 studs do eixo da rua (meia largura de 10 mais meio-fio), por isso 22,7 e 67,3 graus são os ângulos extremos.
- Casas mais largas do que 24 se sobrepõem às vizinhas ou invadem as ruas.
- Cada casa tem cerca de 540 partes (6.466 no total).

## Anéis e fileiras posteriores
- As casas posicionadas depois do anel original seguem outras regras: fileiras ao longo das ruas e anéis de 11 casas em praças circulares menores (ver Casas das ruas - Fileiras variadas e luzes apagadas e Praça circular - Anel de casas voltadas para dentro). As casas do anel original nos ângulos de 22,7 e 67,3 graus projetam seus cantos até cerca de x = 86 ao longo das ruas, o que define o início das fileiras novas em x = 90.

## Relacionados
- Praça - Geometria e raios
- Casa - Base de pedra, porta e degraus
