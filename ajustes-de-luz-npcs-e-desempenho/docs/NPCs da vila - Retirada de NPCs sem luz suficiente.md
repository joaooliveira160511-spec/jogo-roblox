---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, npcs, iluminacao, retirada]
---
# NPCs da vila - Retirada de NPCs sem luz suficiente
Índice: [[Jogos - Gerais]]

## Conceito
- Depois de enfraquecer alguns lampiões (ver [[Postes e lampiões - Lampiões de luz fraca]]), os NPCs comuns que ficaram abaixo da iluminação mínima de 0,8 foram retirados do mundo, para manter a regra de que todo NPC parado fica em local iluminado (ver [[NPCs da vila - Regra de iluminação e escolha das posições]]). Foram 12 dos 275: `Workspace.NPCs` passou a ter 263 modelos.

## Critério
- A iluminação de cada NPC é a mesma conta da regra: soma de brilho * (1 - distância / alcance) das luzes `ligada` de alcance 16 ou mais, a partir de um ponto 1,5 studs acima do chão (altura da raiz menos `AlturaRaiz`, mais 1,5).
- Ficam de fora da retirada os 29 NPCs originais e os caminhantes (os que têm o atributo `Rota`). Os postes a enfraquecer foram escolhidos de modo que nenhum original caísse abaixo de 0,8 e que no máximo 12 comuns caíssem.

## Retirados
| Modelo | Título |
|---|---|
| NPC_claudio | Escrivão |
| NPC_crispim | Velho |
| NPC_ezequiel | Acendedor de lampiões |
| NPC_feliciano | Doente |
| NPC_gB3 | Lavrador |
| NPC_gC18 | Frade |
| NPC_lucinda | Costureira |
| NPC_maricota | Menina |
| NPC_ncoveiro1 | Coveiro |
| NPC_nherbalista2 | Herbalista |
| NPC_nperegrino3 | Peregrino |
| NPC_silvestre | Lenhador |

## Onde estão
- Os modelos não foram apagados: foram movidos para `ServerStorage.NPCsRetirados`, de onde não replicam para os clientes. Para devolver um NPC, basta mover o modelo de volta para `Workspace.NPCs`.

## Exceções e limites
- Os dados do elenco (`ElencoNPCs`, `PosicoesNPC`) não foram alterados. Rodar `ReconstruirNPCs` recria os 275 modelos e traz os 12 de volta; para retirá-los de vez, é preciso também tirá-los do elenco (ver [[NPCs da vila - Ferramentas de posicionamento e reconstrução]]).
- Depois da mudança, o único NPC parado abaixo de 0,8 é `NPC_noleiro3` (0,7954; antes 0,7960), que já estava no limite.
- Os caminhantes não entram na conta: eles seguem as rotas e atravessam trechos mais escuros sem violar a regra de posição inicial (ver [[NPCs da vila - Caminhantes em trechos iluminados]]).

## Relacionados
- [[NPCs da vila - Elenco ampliado e distribuição pela vila]]
- [[NPCs da vila - Cotas por zona e espalhamento pelas ruas]]
- [[NPCs da vila - Visão geral e elenco]]
- [[Postes e lampiões - Lampiões de luz fraca]]
