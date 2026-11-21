---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, adercos, barracas]
---
# Adereços - Carroças, feno, cercas e barracas
Índice: Jogos - Gerais

## Conceito
- A função `aderecos` do módulo cria a pasta `Workspace.Vila.Aderecos` (308 partes em 188 filhos) com itens que dão vida de vila antiga: carroças, fenos, cercas e barracas de feira.

## Carroça (uma por rua, 4 no total)
- Posição: `rot * CFrame.new(70 a 76, 0.5, ±14.5)` com a rotação de cada rua e uma guinada de ±0,5 rad; lados alternados entre as ruas.
- Peças: estrado de 7 x 0,5 x 4, laterais e fundo de WoodPlanks, carga de feno (Fabric (150,126,70)), duas rodas de cilindro de 3,2 de diâmetro, eixo e dois timões.

## Fenos (três por rua)
- Cilindros deitados (eixo horizontal) de 2,8 x 2,6 x 2,6, Fabric (148,122,66), com guinada aleatória, em x de 66 a 84 e |z| de 13,5 a 17.

## Cercas
- Em cada lado de cada rua (z = ±15,2), nos trechos x de 88 a 104, 124 a 140 e 160 a 178: mourões de 0,5 x 3,8 x 0,5 a cada 4 studs e dois trilhos de 0,38 de espessura nas alturas 1,4 e 2,8.

## Barracas de feira (quatro)
- Posição: r = 47, ângulos de 45 + k*90 graus, voltadas para o centro (CFrame.lookAt e rotação de pi).
- Peças: quatro postes de 7,2 de altura, balcão de 6,6 x 0,5 x 3,4 com frente de tábuas, toldo de seis faixas alternando vermelho (128,44,38) e creme (196,176,138) em Fabric, nove frutas esféricas em três cores, e uma lanterna de barraca (PointLight de Range 30 e Brightness 0,8, tag Luz, estado ligada, grupo "barraca0" a "barraca3").

## Exceções e limites
- As barracas e os fenos não são controlados pelo culling por distância (ver Carregamento por distância - Script NevoaDistante).
- A madeira usada tende a laranja; manter as cores escuras (ver Casa - Paredes lisas de madeira).

## Revisão - cerca diante da casa da rua Norte
- A porta da casa nova do lote da rua Norte ficou centrada em x = 100, diante do trecho de cerca de x 88 a 104 (z = 15,2). Para abrir o acesso, os dois trilhos desse trecho foram encurtados para x de 88 a 96 e os mourões de x = 100 e x = 104 foram removidos; ficam os mourões de 88, 92 e 96 (ver Casa da cobertura - Casa com interior e terraço na rua Norte).
- O trecho original (mourões e trilhos) está guardado em `ServerStorage.CasasSubstituidas.CercaNorteFrenteOriginal`, com o atributo `PosicaoOriginal = "Workspace.Vila.Aderecos"`.

## Relacionados
- Mobiliário - Barris, caixas e bancos removidos
- Módulo ConstrutorVilaGrande - Código parte 5 adereços
