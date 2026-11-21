---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, ruina, envelhecimento]
---
# Casas em ruína - Níveis de envelhecimento
Índice: [[Jogos - Gerais]]

## Conceito
- As casas novas são construídas inteiras por `M.casa` e depois envelhecidas por pós-processamento, no próprio Model, de acordo com um nível de 0 a 3. O envelhecimento não altera a função `casa`: age sobre as peças pelo nome.

## Níveis
| Nível | Nome | O que acontece |
|---|---|---|
| 0 | intacta | casa como as originais |
| 1 | gasta | 4% das telhas somem, algumas venezianas tortas, 3 placas de hera extra, inclinação de até 0,006 rad, parede um pouco mais escura |
| 2 | decadente | 7% das telhas somem e 2 buracos no telhado (raio de 3,2 a 5,4, que levam também os caibros próximos), 30% dos vidros viram vãos escuros, 30% das escoras do enxaimel e 5% dos postes faltam, escoras tortas, 6 placas de hera, inclinação de até 0,02 rad, luz sempre apagada, de 10 a 16 peças de entulho |
| 3 | caindo aos pedaços | 10% das telhas somem e 3 buracos, uma água inteira do telhado cai (telhas, subtelhado, caibros, beiral, tabeiras, trapeiras e parte das vigas da empena) deixando caibros quebrados, 50% dos vidros viram vãos, 48% das escoras e 10% dos postes faltam, um canto do último andar é aberto por subtração, portas tortas, 10 placas de hera, inclinação de até 0,04 rad, luz sempre apagada, de 26 a 40 peças de entulho |

## Operações
- **Telhas e buracos**: as telhas são escolhidas por nome (`Telha`); um buraco destrói as telhas e caibros a menos do raio escolhido em torno de uma telha sorteada.
- **Água do telhado caída**: o lado do telhado de cada peça é o sinal do Z no referencial do telhado, `roofCF = cf * CFrame.new(0, yTop, -jet/2) * rot`, em que o cume corre ao longo de X mesmo quando a empena é de frente.
- **Caibros quebrados**: vigas de 0,5 x 0,6 com comprimento de 25% a 80% do caibro, descendo da cumeeira (75%) ou subindo do beiral, com pequena rotação em X.
- **Janelas**: o `Vidro` é destruído e substituído por uma peça escura (5,5,7) do mesmo tamanho, `JanelaVazia`. As venezianas giram em torno do eixo de visada de 0,25 a 0,75 rad.
- **Canto aberto (CSG)**: um bloco de recorte posicionado no canto superior do último andar (com rotações aleatórias de até 0,3 e 0,4 rad) é subtraído do `AndarN` por `SubtractAsync`, que devolve um UnionOperation. Antes disso são destruídos o enxaimel, as janelas e a hera dentro da região, e a empena e a viga de base da empena sobre o canto.
- **Inclinação**: o Model tem `WorldPivot` igual ao `cf` (nível do chão, centro da casa) e é girado em torno dele, para que a casa incline sem deslocar-se.
- **Entulho** (`M.entulho`): tábuas, vigas caídas, pedras e telhas no entorno da casa, assentadas no piso por raycast que só enxerga as pedras e a praça (ver [[Piso - Pedregulhos flutuando e reassentamento]]); peças sem piso embaixo, como sob a própria casa, são descartadas.
- **Hera extra**: com as mesmas regras das hera originais (ver [[Casa - Hera e envelhecimento]]).

## Quantidade por conjunto
- Cada fileira de rua leva exatamente 1 casa em ruína total; cada círculo leva de 1 a 2 (o excedente passa a nível 2, por `limitaRuina`). Sem o limite, o sorteio chegou a produzir de 5 a 7 casas em ruína total por direção, o que descaracterizava o conjunto.
- A ruína tende a aumentar com a distância (probabilidade de nível 3 de 3% a 17% e de nível 2 de 10% a 28%, mais as casas forçadas).
- Resultado da cena: 15 casas em ruína total entre as 77 novas (ver [[Vila Medieval - Expansão pelas quatro direções]]).

## Exceções e limites
- O recorte por subtração funciona no contexto de plugin do Studio, e o resultado é um UnionOperation que mantém a cor e o material da peça original; fica gravado no lugar como qualquer outra peça.
- As peças são identificadas pelo nome, e a ordem das chamadas ao gerador aleatório define o resultado; alterar essa ordem muda quais peças somem.
- Duas casas vizinhas podem se tocar pelo beiral do telhado (uma sobreposição de uma peça foi aceita entre `CasaLesteA1` e `CasaLesteA2`).

## Código
- `envelhece`, `heraExtra`, `M.entulho`, `M.casaVelha` e `limitaRuina`: ver [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]].

## Revisão - muralha e ruas laterais
- Na muralha, `t` é sorteado entre 0,35 e 0,8 e há no máximo 8 casas em ruína total; o resultado é 32 intactas, 18 gastas, 26 decadentes e 8 em ruína total. As casas das ruas laterais usam `tBase = 0,25`, `tSpan = 0,25` e no máximo 1 ruína total por fileira (36 intactas, 19 gastas, 12 decadentes e 2 em ruína total). Ver [[Vila circular - Muralha de casas voltadas para o centro]] e [[Ruas laterais - Anel viário entre as ruas cardeais]].
- Quando `limitaRuina` rebaixa casas de ruína total para o nível 2, o número de decadentes sobe acima do que a probabilidade daria (26 de 84 na muralha).

## Revisão - reparo de um telhado
- Uma casa em ruína (`CasaOesteB3`) teve a água de trás do telhado refeita como espelho da água da frente, com as telhas e os caibros quebrados sorteados de novo depois (25 telhas e 2 caibros retirados, semente 8801). O método e as contagens estão na nota do reparo por espelhamento, em Relacionados.

## Relacionados
- [[Casas das ruas - Fileiras variadas e luzes apagadas]]
- [[Casa - Telhado em fiadas de telhas]]
- [[Casa - Janelas e venezianas]]
- [[Casa - Empenas, trapeiras e chaminés]]
- [[Casas em ruína - Reparo de telhado por espelhamento da água]]
