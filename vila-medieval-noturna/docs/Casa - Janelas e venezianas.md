---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, janelas]
---
# Casa - Janelas e venezianas
Índice: Jogos - Gerais

## Conceito
- Cada janela é construída por `janela(parent, cf, estado, grupo, esc, luz, rng, venezianas)`, onde `cf` tem o +Z local apontando para fora. A janela tem moldura, vidro com Decal de vela, travessas, peitoril de pedra, verga de madeira e, opcionalmente, venezianas.

## Peças
- Tamanho base: W = 3,2 x esc, H = 4,4 x esc (a escala é 1 nas janelas dos andares, 0,8 no térreo, 0,9 na empena, 1 nas trapeiras).
- Moldura de madeira escura de (W+1,1) x (H+1,1) x 0,5, atrás do vidro.
- Vidro: peça "Vidro" de W x H x 0,2, material Glass, cor (16,20,28), Reflectance 0,25, sem sombra, com um Decal "Vela" na face Back (o lado que olha para fora) e uma PointLight opcional.
- Travessas: uma vertical (0,22 x H) e uma horizontal (W x 0,22) a 0,3*esc acima do centro.
- Peitoril: (W+1,8) x 0,55 x 1,2 em pedra clara, abaixo da janela; verga de madeira (W+1,6) x 0,7 x 0,8 acima.
- Venezianas (só nas janelas de frente dos andares, empena e trapeiras): duas folhas de W/2 x (H+0,4) x 0,28 em WoodPlanks verde-acinzentado (52,66,56); 18% delas ficam fechadas (cobrindo metade da janela), as demais ficam abertas, abertas ao lado da janela com um giro aleatório de -0,15 a 0,1 rad.

## Luz da janela
- PointLight no vidro só em algumas janelas: a segunda janela da frente de cada andar e uma janela do térreo; Range 13 e Brightness 0,3 na construção atual, cor final (255,176,84), Shadows desativado.
- O vidro recebe a tag Luz e os atributos Estado e Grupo (ver Luzes - Sistema de estados).
- Para `apagada`: Decal.Transparency = 1; para ligadas: Decal.Transparency = 0,4 (mais escuro).

## Exceções e limites
- O Decal precisa estar na face Back da peça orientada com +Z para fora; na face errada o brilho aparece para dentro.
- O vidro continua Glass mesmo aceso; antes, as janelas acesas viravam Neon e ficavam amarelas demais (ver Janelas - Evolução do vidro).

## Relacionados
- Janelas - Brilho de vela quadriculado
- Casa - Andares, balanço e enxaimel
