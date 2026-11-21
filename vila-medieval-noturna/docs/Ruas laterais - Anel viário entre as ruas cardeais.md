---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, ruas, anel, casas, vila-circular]
---
# Ruas laterais - Anel viário entre as ruas cardeais
Índice: [[Jogos - Gerais]]

## Conceito
- No meio de cada uma das quatro ruas cardeais sai uma rua para cada lado, perpendicular a ela. As ruas laterais de ruas vizinhas se encontram numa curva em L, de modo que as oito meias ruas formam um anel viário quadrado de lado 400, ligando as quatro ruas cardeais entre si. As casas continuam nas duas margens, com os mesmos padrões das ruas cardeais (ver [[Casas das ruas - Fileiras variadas e luzes apagadas]]).

## Geometria
- `ANEL = 200`: distância do cruzamento ao centro, no meio entre a praça central (raio 58) e a muralha (346).
- Cruzamentos em (200, 0), (0, -200), (-200, 0) e (0, 200); curvas em (±200, ±200), a 283 do centro.
- Cada meia rua tem referencial próprio: origem no cruzamento com a rua cardeal `kc`, +X ao longo da lateral na direção `kd` (0 Leste, 1 Norte, 2 Oeste, 3 Sul), com `kd = kc + 1` ou `kc + 3` (módulo 4). A base é `CFrame.new(cruzamento) * CFrame.Angles(0, kd * pi / 2, 0)`.
- O lado interno é o que fica voltado para o centro da vila: o sinal do z local do ponto zero no referencial da meia rua.
- Nomes: `NOMES_DIR[kc] .. NOMES_DIR[kd]`, por exemplo `LesteNorte`.

## Pista, meios-fios e calçadas (referencial da meia rua)
- Pista de x = 10,2 a 210, com 20,4 de largura, em segmentos de cerca de 12,2 (peças `Rua`, topo em 0,5), como as ruas cardeais (ver [[Ruas - Quatro caminhos cardeais]]).
- Meios-fio (`MeioFioRua`) em z = ±10,5, a partir de x = 24,4 (antes disso a pista se abre para a calçada da rua cardeal). O meio-fio interno termina em x = 189,4 e o externo em 210,6, para que na curva eles se encontrem sem cruzar a pista da outra meia rua.
- Calçadas de 11,2 a 24,0 do eixo (lajes `Calcada`), com pedras de 11,7 a 23,5, a partir de x = 24,4.
- Para não duplicar pedras na curva, só a meia rua com `kd = kc + 1` leva a pista (pedras até 209,6) e as calçadas até o canto (interna até 188,8, externa até 224); a outra para antes (pedras da pista até 189,6, calçada interna até 176 e externa até 211,2).
- Pedras: campos de pedras individuais, a mesma técnica das ruas cardeais (ver [[Piso - Pedras individuais estilo cobblestone]]); cerca de 11.000 pedras no conjunto das oito meias ruas, todas com topo entre 0,65 e 1,1.
- Peças do piso novo levam o atributo `Anel = true` (para `limparAnel`).

## Casas
- Margem interna: x de 50 a 150 (começa depois das casas da rua cardeal, que chegam a 47,7 do eixo; termina antes das casas da outra meia rua na curva).
- Margem externa: x de 27 a 176.
- Total de 69 casas, em duas margens por meia rua, com nomes `CasaAnel<Cardeal><Lateral><A ou B><n>`. Níveis de envelhecimento: 36 intactas, 19 gastas, 12 decadentes e 2 em ruína total; parâmetros `tBase = 0,25`, `tSpan = 0,25`, `forcaRuina = 0`, `maxRuina = 1` por fileira.
- A função `fileiraRua` aceita um referencial livre (`cfg.base`), em vez de só a rotação da rua cardeal.

## Postes e pedregulhos
- Quatro postes por meia rua, em x = 52, 96, 140 e 184, alternando os lados a 12,2 do eixo, sem sombra (ver [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]).
- 150 pedregulhos por meia rua (1.033 no total), assentados nas lajes (ver [[Piso - Pedregulhos, rochas e musgo]]).

## Código
- `M.ruaLateral`, `M.anelPiso`, `M.anelCasas`, `M.anelPedregulhos` e `M.postesBase`: ver [[Módulo ConstrutorVilaGrande - Código parte 10 vila circular]].

## Relacionados
- [[Cruzamentos - Limpeza de casas, pedras e meios-fios]]
- [[Vila circular - Muralha de casas voltadas para o centro]]
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Ruas - Continuação e calçadas até as praças circulares]]
