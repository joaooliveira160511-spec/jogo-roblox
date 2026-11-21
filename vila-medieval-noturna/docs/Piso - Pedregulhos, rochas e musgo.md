---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, piso, pedregulhos]
---
# Piso - Pedregulhos, rochas e musgo
Índice: Jogos - Gerais

## Conceito
- Sobre as lajes ficam pequenos pedregulhos e, ao longo das ruas, rochas maiores. Eles criam o aspecto de pedregulho e dão sombras e relevo ao piso. A função `detalhes` do módulo gera tudo em `Workspace.Vila.Detalhes`.

## Pedregulhos (1.500)
- Posição: 55% na praça (r de 34 a 57) e 45% nas ruas (x de 59 a 205, z de -9,4 a 9,4).
- Assentamento: raycast de cima para baixo (de y = 4) para achar o topo da laje e colocar o pedregulho a `topo + s*0,12`.
- Tamanho: s de 0,2 a 0,75, com escalas independentes por eixo (0,8 a 1,6 / 0,5 a 1,0 / 0,8 a 1,4) e rotação aleatória.
- Material Rock; cor final (v, v-2, v-4) com v entre 46 e 96 (inicialmente 70 a 140, que ficava branco-rosado sob a luz dos lampiões). Sem colisão.

## Rochas (70)
- Ficam junto às margens das ruas: x de 62 a 205 e |z| de 11,8 a 15, tamanho s de 1,5 a 3,4, cor (v, v-2, v-4) com v de 60 a 100, com colisão.

## Musgo (removido)
- Foram criados 220 discos achatados (raio de 0,7 a 2,0 e altura 0,08, material Grass); pareciam folhas de vitória-régia e foram removidos. O musgo continua representado pela cor esverdeada de parte das pedras e pela hera nas casas.

## Poças (removidas)
- Ver Piso - Poças e círculos pretos removidos.

## Exceções e limites
- Os raycasts consideram o Terreno e todas as peças consultáveis; as pedras precisam existir antes de rodar `detalhes`.
- Em Models grandes (1.500 peças), o culling do NevoaDistante não atua; o modelo é fixo.

## Correção posterior de assentamento
- O raycast descrito acima acertava o terreno (então em y = 2,0) e deixou 1.476 dos 1.500 pedregulhos cerca de um stud acima das lajes. Eles foram reassentados por raycast que só enxerga as pedras e o piso (ver Piso - Pedregulhos flutuando e reassentamento). Os pedregulhos novos da expansão usam a mesma regra (ver Vila Medieval - Expansão pelas quatro direções).

## Relacionados
- Piso - Pedras individuais estilo cobblestone
- Ruas - Quatro caminhos cardeais
