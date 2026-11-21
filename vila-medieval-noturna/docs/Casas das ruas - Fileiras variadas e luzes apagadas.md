---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, ruas, variacao]
---
# Casas das ruas - Fileiras variadas e luzes apagadas
Índice: [[Jogos - Gerais]]

## Conceito
- Ao longo de cada rua cardeal, depois do anel da praça central, as casas continuam em duas fileiras (uma de cada lado). Usam a mesma função `casa` das casas originais, mas com dimensões, alturas, cores e estados de luz mais variados, e com o envelhecimento aumentando com a distância.

## Posição
- Faixa de x de 90 a 214 no referencial da rua. As primeiras casas ficam em x = 90 porque as casas do anel original nos ângulos de 22,7 e 67,3 graus projetam seus cantos até cerca de x = 86 (um início em 86 gerou sobreposição de caixas entre `Casa10` e `CasaSulB1`, e entre `Casa6` e `CasaOesteA1`).
- Fim em x = 214, porque as casas do círculo vizinhas à entrada avançam para trás sobre essa faixa (ver [[Praça circular - Anel de casas voltadas para dentro]]).
- Resultado: 4 ou 5 casas por lado, ou seja 8 a 10 por rua.
- A parede térrea fica a `Fz` do eixo da rua, com `Fz = 22,5` mais um deslocamento aleatório de -1,0 a +1,2. Os degraus (6,2 de comprimento) terminam entre 15,3 e 17,5 do eixo, junto das cercas existentes em z = 15,2.
- Lado +1: `CFrame.new(xc, 0, Fz + d/2)` com a frente (-Z local) voltada para o eixo. Lado -1: o mesmo com z negativo e giro de pi em Y. Guinada aleatória de ±0,035 rad. A orientação final é `rot * cfLocal`, com `rot = CFrame.Angles(0, k*pi/2, 0)`.

## Dimensões e variação
- Largura w de 19 a 25 e profundidade d de 16 a 24 (inteiros).
- Andares superiores sorteados na lista {1, 1, 2, 2, 2, 3, 3}, o que dá mais casas baixas do que no anel original (2 a 3 andares).
- Empena de frente (`gableFront`) com 35% de probabilidade.
- Cor-base da parede entre as seis de `M.plasters`, depois escurecida em direção a (58,54,48) por `0,12 * nivel + 0,04 * t`, em que `t` vai de 0 (perto da praça) a 1 (longe) (ver [[Casa - Paredes lisas de madeira]]).
- Espaço entre casas: 1,8 a 4,0 studs entre as caixas dos andares; em 12% dos casos, um lote vazio de 6 a 10 studs.
- Semente de cada fileira: `Random.new(900 + k*10 + 1)` para o lado +1 e `+ 2` para o lado -1; semente de cada casa `2000 + k*200 + (0 ou 100) + i`.

## Luzes: mais apagadas com a distância
- Estado sorteado por casa: ligada com probabilidade `0,20 - 0,10*t`, piscando `0,16` e apagada no restante, ou seja, de 64% a 74% apagadas.
- A partir do nível de ruína 2 a casa fica sempre apagada.
- O restante do sistema é o das casas originais (ver [[Luzes - Sistema de estados]]); cada casa recebe grupo próprio (`CasaLesteA1`, `CasaCircNorte3` e assim por diante).

## Fundação e adereços
- Toda casa nova leva uma peça `Fundacao` (w+0,8 por d+0,8, 3,2 de altura, topo em y = 0, sem colisão), escondida sob a base, para que a casa não flutue sobre o terreno (cuja superfície está em y = -0,2) nem deixe vãos quando inclina.
- Na calçada, junto às casas, entram uma pilha de lenha (35%), de 0 a 2 barris e uma caixa (30%), sempre a mais de 6,2 do eixo da porta para não ocupar os degraus; vão para `Workspace.Vila.Mobiliario` (ver [[Mobiliário - Barris, caixas e bancos removidos]]). O entulho das casas em ruína é outro assunto (ver [[Casas em ruína - Níveis de envelhecimento]]).

## Código
- `M.fileiraRua`, `M.casaVelha` e funções auxiliares: ver [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]].

## Revisão - mais luzes e ruas laterais
- As probabilidades de luz mudaram: ligada `0,12 - 0,05*t`, piscando `0,30 - 0,03*t` e apagada no restante (58% a 66% apagadas); as luzes piscando são fracas e animadas no cliente (ver [[Luzes - Animação no cliente e falhas de carregamento]]). As casas antigas das ruas cardeais foram sorteadas de novo com essas probabilidades, sem alterar as em ruína.
- Das fileiras originais saíram as casas que invadiam o corredor das ruas laterais: cada fileira termina agora em x = 166,5 no máximo (ver [[Cruzamentos - Limpeza de casas, pedras e meios-fios]]).
- A mesma função `fileiraRua`, com um referencial livre (`cfg.base`), constrói as casas das ruas laterais (ver [[Ruas laterais - Anel viário entre as ruas cardeais]]).

## Revisão - casa da varanda
- A `CasaNorteA1`, primeira casa do lado A da rua Norte e toda apagada, foi trocada por uma casa singular: um chalé baixo, com varanda coberta e cadeira de balanço, no mesmo lote (ver [[Casa da varanda - Cottage com varanda na rua Norte]]). A original ficou guardada em `ServerStorage.CasasSubstituidas`.
- A fileira A da rua Norte passou a ter `CasaNorteVaranda`, `CasaNorteA2` e `CasaNorteA3`; a primeira foi trocada depois, como descrito a seguir.

## Revisão - casa da cobertura
- A casa da varanda foi removida por inteiro e, no mesmo lote, construiu-se uma casa de pedra e enxaimel com interior em três níveis, escadas internas e um terraço no topo com a cadeira de balanço (ver [[Casa da cobertura - Casa com interior e terraço na rua Norte]]).
- A fileira A da rua Norte passa a ter `CasaNorteCobertura`, `CasaNorteA2` e `CasaNorteA3`. A pasta `Casas` continua com 189 Models.

## Relacionados
- [[Casas - Posicionamento no anel da praça]]
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Casa - Hera e envelhecimento]]
- [[Ruas - Continuação e calçadas até as praças circulares]]
