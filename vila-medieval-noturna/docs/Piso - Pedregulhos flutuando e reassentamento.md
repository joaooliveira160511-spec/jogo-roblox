---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, piso, pedregulhos, raycast, erro]
---
# Piso - Pedregulhos flutuando e reassentamento
Índice: [[Jogos - Gerais]]

## Conceito
- Os pedregulhos criados por `detalhes` ficaram suspensos acima das lajes. A causa era o raycast usado para assentá-los; a correção reposiciona cada um sobre a laje abaixo, sem consultar o terreno.

## Causa
- A função `detalhes` achava o topo da laje com um raycast de y = 4 para baixo, sem filtro. Na época a superfície do terreno ficava em y = 2,0 (antes da correção da camada superior, ver [[Terreno - Material Ground e altura real da superfície]]), então o raio acertava o Terrain e os pedregulhos eram colocados em y = topo + s*0,12, cerca de 2,05.
- Depois que o terreno foi rebaixado (superfície em y = -0,2), as lajes ficaram com topo entre 0,65 e 0,95 e os pedregulhos permaneceram no alto.
- Medida: dos 1.500 pedregulhos, 1.476 ficavam a mais de 0,3 stud sobre a laje (folga típica de 0,9 a 1,3).

## Correção
- Raycast de y = 6 para baixo com `FilterType = Include` apenas em `Workspace.Vila.Pedras` e `Workspace.Vila.Praca` (depois também `Pracas`), e nunca no Terrain.
- A peça é recolocada em `topo + meioY * 0,8`, em que `meioY = 0,5 * (|RightVector.Y|*X + |UpVector.Y|*Y + |LookVector.Y|*Z)` é a meia altura da caixa girada; o fator 0,8 enterra 20% do pedregulho na laje para que não haja fresta.
- A posição horizontal e a rotação não mudam. A descida máxima foi de 3,13 studs.
- Verificação: depois da correção, 0 pedregulhos a mais de 0,15 stud sobre a superfície (nos 3.239 pedregulhos da cena).

## Regra para novas peças
- Toda peça pequena que deva repousar no piso é assentada pela função `assenta` (raycast só contra o piso), com afundamento de 20% a 30%. Pedregulhos novos, entulho de ruínas e adereços de calçada usam essa função.
- Peças sem piso embaixo (por exemplo, sob uma casa) são descartadas, não deixadas no ar.

## Relacionados
- [[Piso - Pedregulhos, rochas e musgo]]
- [[Vila Medieval - Erros comuns e como evitar]]
- [[Casas em ruína - Níveis de envelhecimento]]
- [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]]
