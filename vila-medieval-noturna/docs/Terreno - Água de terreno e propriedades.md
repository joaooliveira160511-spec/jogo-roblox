---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, terreno, agua]
---
# Terreno - Água de terreno e propriedades
Índice: Jogos - Gerais

## Conceito
- A água da fonte é água de terreno (Enum.Material.Water), não uma peça. Ela tem reflexo do céu e da Lua, ondulação e transparência, o que uma peça de vidro não oferece sem a iluminação Future.

## Propriedades do Terrain na cena final
- WaterColor = (22, 52, 72)
- WaterTransparency = 0,5
- WaterReflectance = 1
- WaterWaveSize = 0,12
- WaterWaveSpeed = 8
- Valores originais do Studio: cor (12, 84, 92), reflexo 1, transparência 0,3, tamanho de onda 0,15, velocidade 10.

## Preenchimento
- Cada bacia é preenchida com `Terrain:FillCylinder(CFrame, altura, raio, Enum.Material.Water)`; o cilindro tem o eixo no Y do CFrame.
- A água fica em voxels de 4 studs; o contorno é serrilhado, mas fica escondido atrás das bordas de pedra.
- Parâmetros por nível (b = altura do piso = 0,5): ver Fonte - Bacias e água de terreno.

## Exceções e limites
- A água de terreno não flui; é estática.
- A água dentro de bacias elevadas (níveis 1 a 3) existe no ar por voxels, o que é permitido.
- A água de terreno é desenhada mesmo em modo Edit.

## Relacionados
- Terreno - Material Ground e altura real da superfície
- Fonte - Estrutura em níveis
