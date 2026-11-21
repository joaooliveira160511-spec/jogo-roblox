---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, streaming, neblina, pivo, erro]
---
# Carregamento por distância - Pivôs dos Models novos
Índice: [[Jogos - Gerais]]

## Conceito
- O script `NevoaDistante` guarda a posição de cada Model uma única vez, ao iniciar, com `m:GetPivot().Position`. Com `StreamingEnabled`, os Models distantes chegam ao cliente vazios e só depois recebem as peças. Um Model sem peças tem o pivô na origem, então a unidade era registrada como "perto do centro" e descarregada assim que o jogador se afastava da origem.

## Sintoma
- Com o jogador na praça circular do Leste (x = 266 em diante), todos os postes, as pedras e o mobiliário sumiam do cliente (contagens de filhos das pastas Lampioes, Pedras e Mobiliario iguais a 0), enquanto as casas apareciam. Com o jogador em x = 60, todos voltavam, inclusive os distantes.
- No servidor as contagens estavam corretas (80, 616 e 85); só o cliente perdia os Models.

## Causa
- As casas novas já têm `WorldPivot` definido por `M.casaVelha` (o Model inclina em torno do pivô do chão), por isso funcionavam. Os Models de postes, de pedras e de mobiliário não tinham `WorldPivot` explícito e o pivô vinha do centro da caixa envolvente das peças já chegadas.

## Correção
- Fixar `WorldPivot` de cada Model novo (em Edit) com o valor atual de `GetPivot()`, o que o torna independente de quantas peças já chegaram. A função `M.fixaPivos` faz isso para:
  - os postes cujo nome contém `Ext` ou `Circ`;
  - os Models de pedra com prefixo `RuaExt`, `Calc` ou `Circulo`;
  - os Models de `Mobiliario` que não são os originais (o poço e tudo a mais de 84 do centro).
- Não é preciso alterar o script `NevoaDistante`. Conferência: nenhum Model das pastas controladas ficou com o pivô a menos de 5 studs da origem; em Play, em x = 266, o cliente passou a ter 13 postes, 120 Models de pedra e 12 de mobiliário (os que ficam a menos de 140 da câmera).

## Regra para novas construções
- Todo Model novo nas pastas Casas, Lampioes, Mobiliario ou Pedras precisa de `WorldPivot` explícito antes do jogo (as casas o recebem em `M.casaVelha`). Rodar `fixaPivos` ao final da construção.

## Exceções e limites
- A lista de unidades do script é montada uma vez, então Models que chegam depois ao cliente e não estavam na lista simplesmente ficam sempre carregados; o problema só aparece com Models que já estão na lista com pivô errado.
- A grama tem controle próprio por células e não sofre desse problema (ver [[Grama - Script GramaViva]]).

## Vila circular
- Os Models novos da vila circular também recebem `WorldPivot` explícito, por `M.fixaPivos2`: postes com `Anel` ou `Muro` no nome, Models de pedra com prefixo `RuaAnel`, `CalcAnel` ou `Muralha`, o mobiliário a mais de 84 do centro e os Models `PedregulhosNovos`; as casas já o recebem em `M.casaVelha`. Foram fixados 872 Models, além dos 1.055 de `fixaPivos`. Ver [[Módulo ConstrutorVilaGrande - Código parte 10 vila circular]].

## Situação atual
- Com o `NevoaDistante` desativado, o problema dos pivôs deixou de se manifestar, pois nenhum Model é descarregado por posição; os `WorldPivot` fixados continuam válidos caso o script seja reativado.

## Relacionados
- [[Carregamento por distância - Script NevoaDistante]]
- [[Roblox Studio - Streaming e SurfaceGui à distância]]
- [[Vila Medieval - Erros comuns e como evitar]]
- [[Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção]]
