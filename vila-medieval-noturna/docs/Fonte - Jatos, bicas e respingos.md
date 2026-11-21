---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, fonte, particulas]
---
# Fonte - Jatos, bicas e respingos
Índice: Jogos - Gerais

## Conceito
- A água em movimento é simulada com ParticleEmitters. Cada emissor tem o atributo `Nivel` (0 a 3), usado pelo script de falhas para agrupar o que liga e desliga junto (ver Fonte - Falhas periódicas).

## Emissor padrão (função `emissor`)
- Texture = `rbxasset://textures/particles/sparkles_main.dds`.
- Lifetime = vida ±10%; Speed = velocidade ±8%; SpreadAngle (spread, spread).
- Acceleration = (0, -30, 0); Color (205, 228, 255); Size de `tam` a `0,6*tam`; Transparency de 0,2 a 0,45 e depois 1; LightEmission 0,5; LightInfluence 0,2.

## Jato central (Nivel 0)
- Peça invisível "Jato" em b+51,4; Rate 240, Speed 30, Spread 5, Lifetime 2,3, Size 0,65. Sobe cerca de 15 studs e cai na bacia do nível 3.

## Bicas (gárgulas)
- Cada bica tem uma gárgula de pedra (bloco de 1,1 x 1,1 x 2,4) e um emissor invisível apontando para fora com `EmissionDirection = Front` (a peça é orientada com `CFrame.lookAt` para a direção radial).
- Nível 3: 4 bicas em r = 6,6, y = b+42,9; velocidade 2,2; vida 0,9; taxa 70; tamanho 0,5; ângulos iniciais de 45 graus.
- Nível 2: 6 bicas em r = 11, y = b+32,4; velocidade 2,6; vida 0,95; taxa 80; tamanho 0,55.
- Nível 1: 8 bicas em r = 16,5, y = b+19,7; velocidade 4,8; vida 1,05; taxa 110; tamanho 0,6; deslocamento angular de 22,5 graus.
- As velocidades foram calculadas para que o arco de queda pouse dentro da bacia de baixo (queda com gravidade 30).

## Respingos (onde a água cai)
- Emissores invisíveis em anéis: nível 0, 3 em r = 2, y = b+42,4, taxa 22; nível 3, 4 em r = 8,5, y = b+31,9, taxa 14; nível 2, 6 em r = 13,4, y = b+19,3, taxa 16; nível 1, 12 em r = 21,5, y = b+4,4, taxa 20. Velocidade 5, spread 80, vida 0,55, tamanho 0,7, aceleração (0, -26, 0).

## Névoa baixa
- Um emissor de fumaça em b+5,5 (Nivel 1), taxa 6, vida 7 a 10, spread 180, tamanho de 12 a 26, transparência de 0,9 a 0,94, cor (150, 170, 210), para dar sensação de vapor sobre a água.

## Relacionados
- Fonte - Estrutura em níveis
- Módulo ConstrutorVilaGrande - Código parte 6 fonte
