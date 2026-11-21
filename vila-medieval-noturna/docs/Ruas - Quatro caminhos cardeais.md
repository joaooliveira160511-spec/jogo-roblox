---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, ruas, praca]
---
# Ruas - Quatro caminhos cardeais
Índice: Jogos - Gerais

## Conceito
- Saem da praça quatro ruas, uma para cada ponto cardeal. O Norte (-Z) é o caminho principal, aquele para o qual o jogador nasce voltado.

## Geometria
- Largura 20,4 studs, com meio-fio (altura 1,0, largura 1,4) em z = ±10,5 do eixo (centro em y = 0,75).
- Comprimento: 13 segmentos de 12,2 studs (12,4 de peça com sobreposição), começando em x = 57 + 6,1 e terminando em torno de 216 studs do centro.
- Cada rua é construída ao longo de +X e rotacionada por `CFrame.Angles(0, k * pi / 2, 0)` para k de 0 a 3 (0 = Leste, 1 = Norte, 2 = Oeste, 3 = Sul, no sentido da rotação positiva em Y).
- Segmentos: cor-base (46, 45, 46), Cobblestone; meios-fios alternam (122,116,106) e (96,92,86).
- Pedras individuais sobre cada rua: x de 58,6 a 214 em passos de 2,4; z de -9,4 a 9,45 em passos de 2,35 (ver Piso - Pedras individuais estilo cobblestone).

## Elementos ao longo das ruas
- Quatro postes por rua em x = 76, 112, 148 e 184, alternando os lados em z = ±12,2 (ver Postes e lampiões - Geometria e luz).
- Cercas de madeira em z = ±15,2, nos trechos x 88 a 104, 124 a 140 e 160 a 178.
- Uma carroça e três fenos por rua (ver Adereços - Carroças, feno, cercas e barracas).
- Rochas e pedregulhos junto às margens (ver Piso - Pedregulhos, rochas e musgo).

## Exceções e limites
- As casas da praça deixam livre a boca da rua, com meia largura de 10 studs mais o meio-fio; nenhuma casa pode invadir a faixa |z| < 11,3 perto da praça.
- Com FogEnd = 135, só a primeira metade da rua é visível a partir do centro.

## Prolongamento posterior
- As quatro ruas foram prolongadas de x = 216 até x = 250,4, onde desembocam em uma praça circular, e ganharam calçadas de pedra e fileiras de casas (ver Ruas - Continuação e calçadas até as praças circulares, Casas das ruas - Fileiras variadas e luzes apagadas e Vila Medieval - Expansão pelas quatro direções). Os postes das ruas continuam em x = 220 (ver Postes e lampiões - Continuação nas ruas e nas praças circulares).

## Casa singular na rua Norte
- No lado Leste da rua Norte, em x = 100, o lote da primeira casa da fileira abriga uma casa diferente das demais, com interior em três níveis que o jogador pode percorrer, escadas internas e um terraço de pedra no topo, onde fica uma cadeira de balanço voltada para a rua (ver Casa da cobertura - Casa com interior e terraço na rua Norte; a casa com varanda que ocupou o lote antes está em Casa da varanda - Cottage com varanda na rua Norte). O Norte é o caminho principal, aquele para o qual o jogador nasce voltado.

## Relacionados
- Praça - Geometria e raios
- Carregamento por distância - Script NevoaDistante
