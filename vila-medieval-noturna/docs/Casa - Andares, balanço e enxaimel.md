---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, enxaimel]
---
# Casa - Andares, balanço e enxaimel
Índice: Jogos - Gerais

## Conceito
- Sobre o térreo de pedra ficam de 2 a 3 andares de madeira com balanço na frente (jetty) de 2,4 studs, estrutura típica das casas de enxaimel alemãs. A moldura de vigas escuras (postes, vigas horizontais e escoras diagonais) fica em relevo sobre a parede lisa, projetando sombra.

## Dimensões
- Altura do andar fh = 8,5; primeiro andar começa em y = hb = 9.
- Volume de cada andar: largura ww = w + 0,6 e profundidade dd = d + 2,4, centrado em z = -jet/2 (o balanço avança para a frente).
- Material da parede: SmoothPlastic com cor de madeira pintada (ver Casa - Paredes lisas de madeira).

## Moldura (função `faceEnxaimel`)
- Faces tratadas: frente, fundos e as duas laterais; cada uma recebe o mesmo desenho.
- `n = max(3, round(largura / 4,6))` células; `cel = largura / n`.
- Vigas superior e inferior de largura+0,4 x 1,0 x 0,8, e `n+1` postes de 0,9 x altura x 0,7, todos em relevo de cerca de 0,3 a 0,6 stud sobre a parede.
- Nas células ímpares (1, 3, 5...) entram janelas; nas pares, escoras diagonais de 0,7 x comprimento x 0,55, com ângulo alternado conforme `i % 4`.
- Janelas por face: frente (sem limite), fundos (até 2), laterais (até 1).
- A segunda janela da frente de cada andar recebe uma PointLight (ver Casa - Janelas e venezianas).
- Cores: vigas (36,30,26) com variação de 0 a 8 em cada canal; madeira dos esqueletos em Wood padrão, sem variante.

## Sustentação do balanço
- Viga de balanço de ww+0,6 x 0,9 x jet+0,4 sob a frente do primeiro andar e `nc+1` mãos-francesas de 0,8 x 0,8 x jet*1,45 inclinadas a 45 graus, espaçadas por ww/4,2.

## Exceções e limites
- As manchas de reboco que existiam foram desativadas (laço de zero iterações).
- Há seis cores de parede em `M.plasters`: (116,92,68), (98,80,62), (86,72,58), (128,106,80), (80,84,68) e (104,84,72).

## Relacionados
- Casa - Base de pedra, porta e degraus
- Casa - Telhado em fiadas de telhas
- Módulo ConstrutorVilaGrande - Código parte 2 casa
