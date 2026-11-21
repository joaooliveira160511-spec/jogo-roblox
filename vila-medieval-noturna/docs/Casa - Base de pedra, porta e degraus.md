---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, base]
---
# Casa - Base de pedra, porta e degraus
Índice: Jogos - Gerais

## Conceito
- O térreo de cada casa é um volume de pedra (Cobblestone) de 9 studs de altura, que contém a porta, duas janelas gradeadas e um lampião de parede. Referência local da função `casa`: centro da casa no nível do chão (y = 0), frente em -Z.

## Elementos
- **Base**: bloco de w x 10 x d (altura hb+1 com hb = 9), centro em y = 4, cor (96,92,86); parte dele fica abaixo do chão (de y = -1).
- **Soco**: bloco de w+1,2 x 1,6 x d+1,2 em y = 0,8, cor (66,64,62).
- **Faixa superior**: bloco de w+1,2 x 0,9 x d+1,2 em y = hb-0,2, cor (122,116,106).
- **Cantoneiras**: nos quatro cantos, cinco blocos alternados de 2,8 x 1,35 x 0,7 (frente/fundo) e 0,7 x 1,35 x 2,8 (laterais), de y = 2,4 a 8,4 em passos de 1,5, cor (122,116,106).
- **Porta**: duas folhas de WoodPlanks (46,32,22) de 2,75 x 8,0 x 0,5 em x = ±1,4; três ferragens metálicas por folha em y = 1,6, 4,5 e 7,2; duas argolas; batentes de pedra de 1,0 x 8,6 x 1,3 em x = ±3,6; verga de 8,2 x 1,3 x 1,5 em y = 9,2; fecho de 1,4 x 1,9 x 1,7.
- **Degraus**: três degraus de largura 9,5-0,8i, altura 0,55*(3-i)+0,3 e profundidade 2,2, avançando 2,0 a cada degrau, cor (66,64,62).
- **Janelas do térreo**: duas janelas de escala 0,8 em x = ±0,3w, y = 5,4, com cinco barras verticais de grade (0,16 x 3,9 x 0,16) em cada.
- **Lanterna de porta**: só para casas não apagadas; peça de vidro de 1,0 x 1,5 x 1,0 em (-6,6; 6,8; frente), com suporte metálico, PointLight de Range 22 e Brightness 0,5, tag Luz do grupo da casa.

## Materiais
- Cobblestone com a variante vila_paralelepipedo nas casas construídas antes de ela ser desligada (ver Roblox - Materiais PBR gerados no MaterialService).

## Exceções e limites
- A porta é decorativa (sem colisão); a base é um bloco maciço, então não há interior.
- O balanço dos andares superiores cobre a parte da frente da base; os degraus saem até cerca de 6 studs da fachada e entram na faixa de piso da praça (por isso a frente da base fica a 62 + 2,4 do centro).

## Relacionados
- Casas - Posicionamento no anel da praça
- Casa - Andares, balanço e enxaimel
- Módulo ConstrutorVilaGrande - Código parte 2 casa
