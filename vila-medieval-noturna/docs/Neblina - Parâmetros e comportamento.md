---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, neblina, fog]
---
# Neblina - Parâmetros e comportamento
Índice: Jogos - Gerais

## Conceito
- A neblina do projeto usa o fog nativo do Lighting: a cor dos objetos vai se aproximando da cor da neblina com a distância da câmera, em todas as direções, e a câmera é a origem, então a neblina acompanha o jogador sem script.
- Complementa o fog um descarregamento por distância, para que partes do mapa envolvidas por neblina espessa deixem de existir no cliente e voltem quando o jogador caminhar até elas (ver Carregamento por distância - Script NevoaDistante).

## Parâmetros
- FogColor = (8, 9, 13); FogStart = 12; FogEnd = 135.
- Atmosphere com Density 0,3, Haze 0,3, Color (8,10,16) e Decay (2,3,6) (ver Céu - Estrelas, atmosfera e pós-processamento).
- Distâncias de descarregamento: LOAD = 140 e UNLOAD = 160, com histerese de 20 studs para evitar que objetos liguem e desliguem na borda.

## Evolução dos parâmetros
- Primeira versão: FogStart 15 e FogEnd 150, cor azul-marinho (30,40,76).
- Vila grande: FogStart 60 e FogEnd 320, cor (26,34,64) a (38,50,86); o fog quase não aparecia dentro da praça.
- Versão final: FogStart 12, FogEnd 135 e cor quase preta, coerente com a noite em breu.

## Exceções e limites
- O fog não afeta o Sky; por isso a Lua não é coberta por ele. A nuvem fina sobre a Lua é feita à parte (ver Neblina da Lua - Script NeblinaLua).
- A cor do fog deve acompanhar a cor da atmosfera; um fog cinza sobre um céu escuro cria uma faixa visível no horizonte.
- Com o fog fechando em 135 studs, as ruas somem em cerca de metade do comprimento delas; o resto fica descarregado até o jogador se aproximar.

## Revisão - neblina removida
- A neblina nativa foi desligada: `FogStart = 100000` e `FogEnd = 100000` (antes 12 e 135, cor (8, 9, 13), que continua igual). O descarregamento por distância também foi desligado, o `StreamingEnabled` do Workspace passou a `false` e o mapa inteiro é carregado de uma vez no cliente (124.989 partes de `Workspace.Vila`).
- Motivo: a neblina densa e o descarregamento ligavam e desligavam Models com luzes, o que contribuía para as falhas de iluminação (ver Luzes - Animação no cliente e falhas de carregamento).
- Efeito visual: as ruas e os postes distantes passam a aparecer até o fundo; a `Atmosphere` (Density 0,3 e Haze 0,3) e a nuvem fina sobre a Lua continuam ligadas.
- Para voltar ao estado anterior: FogStart 12, FogEnd 135, `NevoaDistante.Enabled = true`, `StreamingEnabled = true` e, no `GramaViva`, `LOAD_DIST, UNLOAD_DIST = 140, 160`.

## Relacionados
- Iluminação - Configuração final da noite
- Lua - Textura no Sky
