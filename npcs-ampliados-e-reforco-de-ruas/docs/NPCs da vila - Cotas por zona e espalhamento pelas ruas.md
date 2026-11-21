---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, npcs, distribuicao, zonas, ruas]
---
# NPCs da vila - Cotas por zona e espalhamento pelas ruas
Índice: [[Jogos - Gerais]]

## Conceito
- A primeira distribuição por iluminação (ver [[NPCs da vila - Regra de iluminação e escolha das posições]]) concentrava o elenco nas áreas circulares: dos 253 NPCs parados, 105 ficavam nas quatro praças externas (41%), 44 na praça central, 51 nos bairros, 31 nas avenidas e só 22 nos anéis. A causa era o critério: as posições eram sorteadas entre as células iluminadas, e as praças concentravam postes enquanto as ruas eram escuras.
- Com os postes de reforço (ver [[Postes e lampiões - Reforço nas ruas escuras]]) as calçadas das ruas passaram a ser iluminadas, e a escolha passou a ter cotas por zona.

## Zonas
- Teste em ordem (função `zonaDe` do posicionador):

| Zona | Critério |
|---|---|
| central | a menos de 62 do centro |
| sat (praças externas) | a menos de 56 do centro de uma das quatro praças, em (±296,8; 0) e (0; ±296,8) |
| anel | a menos de 26 de `x = ±200` (para `z` até 226) ou de `z = ±200` (para `x` até 226) |
| avenida | a menos de 26 do eixo de uma rua cardeal, a mais de 56 do centro |
| bairro | o que sobra |

## Cotas
- Fração dos NPCs parados sorteados: central 12%, praças externas 16%, anel 28%, avenida 28% e bairro 16%; o arredondamento sobra para o bairro. Para os 253 sorteados saem 30, 40, 70, 70 e 43. Com os quatro fixos da praça central (Cássio e os três feirantes), a praça central fica com 34.

## Afinidade por papel
- A chance de uma zona é a cota restante multiplicada por um peso do papel:

| Grupo de papéis | Central | Praças | Anel e avenida | Bairro |
|---|---|---|---|---|
| Rua: acendedor, lanterneira, sentinela, guarda, soldado, mensageiro, peregrino, vigia, menestrel, cantora, bêbado, mendigo, vendedora de velas, caçador, médico da peste | 0,6 | 0,5 | 2 | 0,6 |
| Casa e ofício: carpinteiro, oleiro, copista, costureira, lavadeira, lavrador, lenhador, padeiro, padeira, herbalista, pedreiro, viúva, mãe, doente, escrivão, pastor, coveiro, rezadeira, varredora, camponesa, monge, velho | 0,7 | 0,8 | 1,2 | 2,2 |
| Crianças (com vela, lanterna, pão, livro, desenhando, com boneca) | 1 | 1,5 | 1 | 1,5 |

- Os demais papéis têm peso 1 em todas as zonas.

## Escolha da posição
1. Cada NPC (na ordem de antes: maior pegada primeiro) recebe as cinco zonas em ordem sorteada sem reposição, com peso igual à cota restante (no mínimo 0,05) vezes a afinidade; zona esgotada tende a ficar por último.
2. Dentro da zona, 24 candidatas válidas (iluminação de pelo menos T, fora da pista, pegada livre e espaçamento), em até 900 tentativas. Pontuação: distância ao NPC mais próximo, limitada a 45, mais metade da distância ao mais próximo do mesmo papel, limitada a 70, mais um acréscimo aleatório de 0 a 6. O termo do mesmo papel evita agrupar ofícios iguais.
3. T desce de 0,8 para 0,65 e 0,55 dentro da mesma zona antes de passar à zona seguinte.
4. Todos os NPCs são sorteados de novo, inclusive os 109 antigos, com semente `20261102`: o ramo "célula mais próxima da posição antiga" deixou de existir. O registro mantém a faixa original (`banda`) dos antigos, então a chance de conversar deles não muda.

## Poços
- Só as chamas de poços acesos contam como poço. O código anterior somava de novo todas as `PointLight` de alcance 30 ou mais do mobiliário, o que duplicava as chamas e aceitava um poço apagado.

## Resultado
- 253 posicionados e nenhuma falha; os 275 NPCs ficam em iluminação de 0,80 ou mais na posição inicial, com média de 1,33.
- Por zona (275, contando os 18 caminhantes): praça central 34, praças externas 40, anel 83, avenidas 75 e bairros 43.
- Faixas pelo raio dos 253 parados: P 30, A 37, B 80, C 54 e D 52.
- Em Play, as calçadas do anel leste, da avenida leste e do anel norte aparecem com NPCs dos dois lados da rua.

## Exceções e limites
- Os NPCs parados ficam nas calçadas, nunca na pista: a pista é o caminho dos caminhantes e do jogador.
- O resultado é de uma rodada com semente fixa; trocar a semente muda os lugares, não as cotas.
- Falas e papéis não mudaram; a chance de conversar continua dependendo do papel e da faixa (ver [[NPCs da vila - Diálogos do elenco ampliado]]).
- A tabela de capacidade da nota de regra de iluminação não foi recalculada com os postes novos.

## Relacionados
- [[NPCs da vila - Elenco ampliado e distribuição pela vila]]
- [[NPCs da vila - Ferramentas de posicionamento e reconstrução]]
- [[NPCs da vila - Caminhantes em trechos iluminados]]
- [[NPCs da vila - Novos ofícios do elenco ampliado]]
- [[Postes e lampiões - Reforço nas ruas escuras]]
- [[NPCs da vila - Retirada de NPCs sem luz suficiente]]
