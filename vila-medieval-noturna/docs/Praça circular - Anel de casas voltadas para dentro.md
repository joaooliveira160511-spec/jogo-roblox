---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, praca, circulo, casas]
---
# Praça circular - Anel de casas voltadas para dentro
Índice: [[Jogos - Gerais]]

## Conceito
- No fim de cada rua cardeal há uma praça circular menor, construída como a praça central: piso de pedras, meio-fio e um anel de casas com as portas voltadas para o centro. Não saem novas ruas dela; a única abertura é a entrada pela rua que chega.

## Posição e referencial
- Centro em x = 296 no referencial da rua (Leste (296, 0, 0), Norte (0, 0, -296), Oeste (-296, 0, 0), Sul (0, 0, 296)).
- Raio do piso: R = 46. O referencial do círculo é o da rua: a entrada fica em -X local (o lado que volta para a vila).

## Piso
- Discos empilhados como na praça central: `Piso` (raio 46, espessura 1,0), `PisoAnel1` (raio 38, 1,02), `PisoAnel2` (raio 30, 1,04) e `PisoAnel3` (raio 14, 1,06, ardósia (44,44,48)); cor-base (46,45,46), Cobblestone.
- Pedras individuais em anéis concêntricos de r = 7,0 a 45,2 em passos de 2,4 (17 anéis, cerca de 1.100 pedras por praça), cada pedra voltada para o centro; o centro fica livre para o poço (ver [[Poço - Centro da praça circular]]).
- Meio-fio: blocos de 4,0 x 1,3 x 1,7 em r = 46,8, em número de `floor(2*pi*46,8 / 3,85 + 0,5)`, cores alternadas (122,116,106) e (96,92,86). Ficam de fora os blocos da boca de entrada (lado -X com |z| < 11,6) e os que estão a menos de 5,6 studs do eixo de uma porta, para não cruzar os degraus.

## Casas
- Doze posições, uma a cada 30 graus (ângulo local medido do +X, posição `(cos, 0, -sin)`); a de 180 graus, a entrada, fica vazia, o que dá 11 casas.
- Frente dos andares superiores em rf = R + 4 = 50; a parede térrea fica 2,4 mais afastada (o balanço), em 52,4; centro da casa em `rc = rf + d/2 + 2,4`; orientação `CFrame.lookAt(centro da casa, centro da praça)`.
- Dimensões: w de 19 a 23, d de 16 a 24; deslocamento angular aleatório de ±0,6 grau e guinada de ±0,03 rad.
- Detalhes de sorteio de andares, ruína e luzes: ver [[Casas das ruas - Fileiras variadas e luzes apagadas]] e [[Casas em ruína - Níveis de envelhecimento]]; a ruína aumenta com a distância da entrada.

## Por que 30 graus
- Duas casas vizinhas se encostam pela frente quando o ângulo entre elas é `2 * atan(ww / (2 * rf))`, com `ww = w + 0,6`. Para a largura máxima de 23 (ww = 23,6) e rf = 50 isso dá cerca de 26,6 graus; 30 graus deixa uma fresta de 2 a 4 studs, como no anel da praça central.
- As casas vizinhas à entrada ficam em ±30 graus; seus cantos mais próximos do eixo da rua ficam a cerca de 14,5 do eixo, fora da faixa da rua e do meio-fio (11,2).

## Extensão no terreno
- Os fundos das casas chegam a r = 77 em relação ao centro da praça; com o centro em 296, o limite fica em cerca de 373, dentro dos 384 do terreno.
- A casa vizinha à entrada avança para trás (em direção à vila) sobre a faixa da rua, por isso as fileiras ao longo da rua terminam em x = 214.

## Postes
- Doze postes por praça, entre as portas (ver [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]).

## Código
- `M.pracaCirculo`, `M.pedrasAneis` e `M.circuloCasas`: ver [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]] e [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]].

## Revisão - praça do portão
- As 44 casas deste anel foram removidas: o círculo de casas voltadas para dentro passou a ser uma muralha contínua que envolve a vila inteira (ver [[Vila circular - Muralha de casas voltadas para o centro]]). A praça de raio 46 continua, com piso, anéis de pedras, poço e doze postes, e passou a ser a praça diante de uma casa da muralha, no fim de cada rua cardeal.
- O meio-fio que ficava de fora junto das portas das casas foi completado (132 blocos); só a boca de entrada, de 11,6 de cada lado do eixo, continua sem meio-fio (ver [[Passeio da muralha - Lajes, pedras e postes]]).
- As partes desta nota sobre casas (posição, "Por que 30 graus" e extensão no terreno) descrevem o anel removido; a posição das casas atuais está na nota da muralha.

## Relacionados
- [[Praça - Geometria e raios]]
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Casas - Posicionamento no anel da praça]]
- [[Ruas - Continuação e calçadas até as praças circulares]]
