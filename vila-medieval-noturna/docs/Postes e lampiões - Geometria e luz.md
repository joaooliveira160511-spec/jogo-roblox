---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, postes, lampioes]
---
# Postes e lampiões - Geometria e luz
Índice: Jogos - Gerais

## Conceito
- Postes altos de madeira com um lampião pequeno pendurado em um braço de ferro, como nas vilas medievais. São 28 postes na pasta `Workspace.Vila.Lampioes`: 12 na borda da praça e 16 ao longo das ruas.

## Geometria (função `poste`, referência local: base no chão, braço para +X)
- Base de pedra 2,4 x 1,8 x 2,4; pedestal cilíndrico de raio 1,0 e altura 2,4 em y = 3,0.
- Poste cilíndrico de raio 0,42 e altura 12,4 em y = 10,4 (topo em 16,6), madeira (26,21,18); três aros de ferro em y = 5,4, 9,5 e 14,6.
- Braço de ferro horizontal de 4,4 em y = 15,2, escora diagonal a 48 graus e um aro de enfeite.
- Corrente de 1,2 e lampião pequeno em x = 3,9: topo, ponta, base e quatro quinas de ferro em torno de uma chama de vidro de 0,68 x 1,0 x 0,68 em y = 13,0.
- Altura total do conjunto: cerca de 15 studs, três vezes a altura de um personagem.

## Luz
- PointLight na "Chama": Range 44, Brightness 1,25, Color (255,184,108), Shadows = true.
- Valores anteriores testados: Range 56 e Brightness 2,8 estouravam a cena em laranja; Range 44 e Brightness 1,6 ainda eram fortes demais com a noite clara; 1,25 ficou equilibrado para a noite em breu.
- Neon de cor (255,112,28) na chama quando ligada; Glass escuro quando apagada.

## Posicionamento
- Borda da praça: r = 54,5, nos ângulos das casas (22,7, 45 e 67,3 mais q*90), com o braço voltado para o centro: `CFrame.lookAt(pos, centro) * CFrame.Angles(0, -pi/2, 0)`.
- Ruas: x = 76, 112, 148 e 184, alternando os lados em z = ±12,2, com o braço sobre a pista (guinada de ±pi/2).
- Estados: 55% ligada, 25% piscando, 20% apagada (Random 777).

## Exceções e limites
- A Shadows = true só tem efeito sob a iluminação Future.
- 28 luzes com sombra podem pesar em hardware modesto; se necessário, desativar Shadows nos postes das ruas.

## Continuação posterior
- A sequência de postes continua nas ruas (x = 220) e ganha doze postes em cada praça circular, com 45% ligados, 25% piscando e 30% apagados (ver Postes e lampiões - Continuação nas ruas e nas praças circulares). Os postes das ruas originais fora do piso, em x = 112, 148 e 184, passam a ficar sobre a calçada nova (ver Ruas - Continuação e calçadas até as praças circulares).

## Revisão - clones do poste nas fazendas
- O `Poste1` (a mesma geometria acima) é clonado nas quatro fazendas dos quarteirões, reduzido a 0,85 com `ScaleTo`, com a chama em alcance 30 e brilho 0,8 e sem sombra; o braço aponta para o caminho. O estado e o grupo vêm da estaca que o poste substitui (ver a nota da camada de detalhes das fazendas, em Relacionados).

## Relacionados
- Luzes - Sistema de estados
- Luzes das casas - Tons e intensidades
- Módulo ConstrutorVilaGrande - Código parte 3 poste e objetos
- Fazendas dos quarteirões - Detalhes e postes da vila
