---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, casas, ruina, telhado, cframe]
---
# Casas em ruína - Reparo de telhado por espelhamento da água
Índice: [[Jogos - Gerais]]

## Conceito
- Quando uma água do telhado de uma casa em ruína está errada ou incompleta, e a outra está certa, o reparo mais seguro é refazer a errada como espelho da certa em relação ao plano da cumeeira. Assim as duas águas têm a mesma geometria (mesmo ângulo, mesmas fiadas de telhas, mesmos beirais e tabeiras), e os efeitos da ruína (telhas faltando, caibros quebrados) são refeitos depois, com sorteio fixo.
- Aplicado em `Workspace.Vila.Casas.CasaOesteB3`.

## Como se espelha
- O plano de espelho é o plano vertical que passa pela peça `Cumeeira` e é perpendicular ao eixo transversal do telhado. No referencial local da casa, uma peça em `z` vai para `2·zr − z`, em que `zr` é a posição da cumeeira nesse eixo.
- O `CFrame` também é refletido: a posição local ganha a nova coordenada `z`, e na rotação o sinal dos componentes que dependem de `z` é invertido (inclinações de água, rolagens das telhas). Tamanhos (`Size`) não mudam, porque o espelho de uma caixa é uma caixa do mesmo tamanho. Faz-se o cálculo no referencial local da casa e só então se volta ao mundo.
- Peças espelhadas: `Telha`, `Caibro`, `Subtelhado`, `Beiral` e `Tabeira` da água de trás. Os `CaibroQuebrado` da água errada foram removidos antes (6 peças).
- A empena do lado leste (`EmpenaE`, cunhas) foi clonada e deslocada 24,8 studs em X.

## Ruína refeita
- Depois do espelhamento foram retiradas 25 telhas e 2 caibros, com sorteio de semente `8801`, para deixar buracos coerentes com os níveis de envelhecimento das outras casas.
- Contagem final de peças da casa: `Telha` 107, `Caibro` 16, `Beiral` 2, `Subtelhado` 2, `Tabeira` 4, `EmpenaD` 2, `EmpenaE` 2.

## Exceções e limites
- O reparo depende de a água de referência estar correta; se as duas estiverem erradas, é preciso reconstruir o telhado pelo módulo da casa.
- Peças decorativas com `CanQuery` falso não aparecem em consultas espaciais; para listar ou contar as telhas de um telhado, varra os descendentes da casa e não use `GetPartBoundsInBox`.

## Relacionados
- [[Casas em ruína - Níveis de envelhecimento]]
- [[Casa - Telhado em fiadas de telhas]]
- [[Casa - Empenas, trapeiras e chaminés]]
- [[Roblox - Convenções de orientação, CFrame e formas]]
