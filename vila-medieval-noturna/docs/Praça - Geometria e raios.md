---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, praca, geometria]
---
# Praça - Geometria e raios
Índice: Jogos - Gerais

## Conceito
- A praça é um círculo centrado na origem (0, 0, 0). O topo do piso-base é y = 0,5; sobre ele ficam as pedras individuais (topo entre 0,65 e 0,95). A origem do sistema de coordenadas é o centro da fonte.
- Convenções: Norte = -Z, Sul = +Z, Leste = +X, Oeste = -X.

## Anéis e raios
- Fonte (degrau externo): raio 30,6 mais metade da largura do degrau, cerca de 32.
- Pedras individuais: de r = 33,8 a r = 57,2 (ver Piso - Pedras individuais estilo cobblestone).
- Piso-base, em discos empilhados (cilindros de eixo vertical, espessura 1,0 a 1,06, centro em y = 0):
  - Piso: raio 58, cor (46, 45, 46), Cobblestone.
  - PisoAnel1: raio 50, (46, 45, 46).
  - PisoAnel2: raio 42, (46, 45, 46).
  - PisoAnel3: raio 34, (44, 44, 48), Slate.
- Meio-fio: 96 blocos de 4,0 x 1,3 x 1,7 em r = 58,8, y = 0,95, voltados para o centro, cores alternadas (122,116,106) e (96,92,86). Ficam de fora os blocos cujo ângulo está a menos de 10,8 graus de um eixo cardeal, deixando abertas as bocas das quatro ruas.
- Postes da borda: r = 54,5.
- Barracas de feira: r = 47, nos ângulos de 45 graus mais múltiplos de 90.
- Barris e caixas: r = 56,2 a 57,4.
- Fachadas das casas: início em r = 62 (frente dos andares superiores).

## Motivo do raio 58
- Raio menor deixa as casas coladas em fachada contínua; com larguras de 22 a 24 studs e três casas por quadrante, os cantos frontais das casas se encontram em r = 62.
- A faixa livre entre a fonte (cerca de 32) e as casas (62) tem cerca de 30 studs de largura.

## Exceções e limites
- A versão anterior da praça tinha raio 80, com meio-fio em 80,8; o módulo ainda contém essas definições antigas, substituídas mais abaixo no arquivo (ver Roblox Studio - ModuleScript, require e cache).
- Mudar o raio da praça exige refazer: meio-fio, anéis, pedras, ruas (início), casas (rf), postes da borda, barracas e barris.

## Relacionados
- Ruas - Quatro caminhos cardeais
- Casas - Posicionamento no anel da praça
- Módulo ConstrutorVilaGrande - Código parte 4 praça, pedras e detalhes
