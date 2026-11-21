---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, ceu, atmosfera, bloom]
---
# Céu - Estrelas, atmosfera e pós-processamento
Índice: Jogos - Gerais

## Conceito
- O céu é o Sky padrão do Studio com estrelas e a textura da Lua trocada; o Atmosphere, o Bloom e o ColorCorrection completam o clima escuro.

## Sky
- StarCount = 4000.
- MoonTextureId = rbxassetid://128342251593093; MoonAngularSize = 18 (grande, mas dentro do limite do Roblox).
- SunAngularSize = 0 (o Sol não aparece).
- CelestialBodiesShown = true.

## Atmosphere (quase preta)
- Density = 0,3; Offset = 0; Glare = 0; Haze = 0,3.
- Color = (8, 10, 16); Decay = (2, 3, 6).
- Objetivo: remover a faixa azul clara do horizonte, que dava a impressão de "noite azul".

## BloomEffect
- Intensity = 0,5; Size = 24; Threshold = 1,2.

## ColorCorrectionEffect "CorNoite"
- TintColor = (255, 250, 244) (neutro levemente quente), Saturation = 0, Contrast = 0,2, Brightness = -0,04.

## Outros efeitos
- SunRaysEffect com Intensity 0 e Spread 0.
- DepthOfFieldEffect desativado (Enabled = false).

## Exceções e limites
- O Sky aparece mesmo em modo Edit; a imagem da Lua pode levar alguns instantes para processar após o envio.
- Valores do Atmosphere acima de 0,3 de Haze reintroduzem o brilho azul no horizonte.

## Relacionados
- Iluminação - Configuração final da noite
- Lua - Textura no Sky
- Neblina - Parâmetros e comportamento
