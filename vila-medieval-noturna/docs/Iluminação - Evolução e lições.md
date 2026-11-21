---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, iluminacao, historico]
---
# Iluminação - Evolução e lições
Índice: [[Jogos - Gerais]]

## Conceito
- A iluminação foi calibrada em etapas; as lições abaixo explicam por que os valores finais são extremos (ambiente zero).

## Etapas
1. **Campo noturno inicial**: ClockTime 19,8, Brightness 1,2 a 2,5, Ambient (28,34,66) a (62,72,125), OutdoorAmbient (52,64,112) a (88,102,165). Resultado: chão e grama quase pretos mesmo com valores azulados; a grama passou a Neon para ter cor controlada.
2. **Vila pequena**: luzes de janelas com Range 18 e Brightness 1,4 deixavam as paredes laranja; reduzidas para Range 10 e Brightness 0,5.
3. **Vila grande**: Brightness 2,6 a 3,5, Ambient (96,108,152), OutdoorAmbient (124,138,190), ExposureCompensation 1,3. Resultado: cena legível, mas de "noite azul clara".
4. **Lampiões fortes**: Range 56 e Brightness 2,8 estouraram a praça em laranja; reduzidos para 44 e 1,6, depois 1,25 com cor (255,184,108).
5. **Noite em breu**: Brightness 0, ambiente zero, EnvironmentDiffuseScale 0, atmosfera e neblina quase pretas, ColorCorrection sem tom azul.

## Lições
- Ambient e OutdoorAmbient claros sempre dão a impressão de "noite azul clara"; para breu, tudo precisa ser zero, inclusive a contribuição do céu (EnvironmentDiffuseScale).
- Bloom com limiar baixo transforma Neon laranja em amarelo; manter Threshold alto (1,2) e Intensity moderada (0,5).
- Em Play, a cena aparece mais escura do que em modo Edit; calibrar sempre olhando capturas de Play.
- O brilho direcional (Brightness) cria sombras duras da Lua; com Brightness 0, a Lua é só um elemento do céu.
- A cor da luz das PointLights tinge tudo; luz muito laranja faz pedras cinza parecerem bege, então esfriar a cor das pedras compensa.

## Relacionados
- [[Iluminação - Configuração final da noite]]
- [[Vila Medieval - Evolução das versões]]
