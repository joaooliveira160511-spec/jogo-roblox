# NPCs ampliados e reforço de luz nas ruas (Roblox Studio)

Trabalho feito na Vila Medieval Noturna depois da construção da vila (ramificação `2-vila-medieval-noturna`). Esta pasta reúne **só o que foi criado no chat**: o elenco ampliado de NPCs, as ferramentas em Luau que os geram e a cópia das notas do cofre que descrevem o trabalho.

## O que mudou

- **Elenco**: os 30 NPCs originais ganharam posições novas e rotas refeitas; o elenco sorteado cresceu com 39 NPCs com fala própria e personagens genéricos de 48 ofícios.
- **Diálogos**: `Dialogos` passou a ter falas para os 39 novos e conversas extras para os ofícios antigos (ver a nota de diálogos no cofre).
- **Visual**: novos adereços, coberturas de cabeça e armaduras em `ConstrutorNPCs`, e novas poses em `Poses`.
- **Luz das ruas**: 61 postes `PosteRua1` a `PosteRua61` acrescentados nas avenidas e nos anéis onde a iluminação ficava abaixo da meta (módulo `IluminarRuas`).
- **Distribuição**: o sorteio dos NPCs passou a usar cotas por zona (praça central, praças externas, anel, avenidas e bairros), para não concentrar o elenco nas áreas circulares.

## Estrutura

```
npcs-ampliados-e-reforco-de-ruas/
├── README.md
├── src/
│   ├── ServerStorage/
│   │   ├── ConstrutorNPCs.lua   monta o modelo de cada NPC (rig, roupas, itens, cabelo)
│   │   ├── ElencoNPCs.lua       os NPCs com posição, rota e itens
│   │   ├── GeradorNPCs.lua      cria as especificações (nomes, aparência) a partir do papel
│   │   ├── PapeisNPC.lua        os ofícios: pose, objetos de mão, área livre
│   │   └── PosicoesNPC.lua      posições sorteadas (saída do PosicionadorNPCs)
│   └── ReplicatedStorage/
│       ├── Dialogos.lua         falas dos NPCs
│       └── Poses.lua            animação procedural (cliente)
├── ferramentas/                 rotinas que geram ou conferem o conteúdo, rodadas no Studio
│   ├── IluminarRuas.lua         acrescenta os postes de reforço
│   ├── PosicionadorNPCs.lua     sorteia as posições dos NPCs parados
│   ├── RotasNPC.lua             escolhe as rotas dos caminhantes
│   └── ReconstruirNPCs.lua      recria os 275 modelos em Workspace.NPCs
└── docs/                        cópias das notas do cofre sobre este trabalho
    ├── NPCs da vila - Cotas por zona e espalhamento pelas ruas.md
    └── Postes e lampiões - Reforço nas ruas escuras.md
```

## Onde cada arquivo vai no Studio

| Arquivo | Destino no Studio |
|---|---|
| `src/ServerStorage/*.lua` | `ServerStorage` (ModuleScript, mesmo nome do arquivo) |
| `src/ReplicatedStorage/Dialogos.lua` | `ReplicatedStorage.NPCVila.Dialogos` |
| `src/ReplicatedStorage/Poses.lua` | `ReplicatedStorage.NPCVila.Poses` |
| `ferramentas/*.lua` | não ficam no Studio; são executados com `execute_luau` (cada um devolve uma função) |

Não entram nesta pasta: `ReplicatedStorage.NPCVila.Assets` (sem alteração neste trabalho), os scripts do cliente e os lampiões antigos.

## Ordem de uso das ferramentas

1. `IluminarRuas(true)` cria os postes de reforço. Ela apaga antes os `PosteRua*` de uma rodada anterior.
2. `PosicionadorNPCs(true)` grava `ServerStorage.PosicoesNPC`. Na primeira gravação guarda a lista anterior em `PosicoesNPCOriginal`.
3. `RotasNPC(0.45, 18, 11)` escolhe as rotas dos 18 caminhantes; elas são copiadas para `ElencoNPCs` (as sete rotas de `add` e as onze de `caminhante`).
4. `ReconstruirNPCs`: `preparar()`, depois `construir(1, #specs, true)` e `fim()`. Levou cerca de 6,4 s e não deu erro.

As sementes são fixas (posicionador `20261102`, rotas `11`, ordem dos ids `5`): com as mesmas luzes, o resultado é o mesmo.

## Números da última rodada

- 253 NPCs parados, todos com iluminação no chão de 0,80 ou mais na posição inicial (média de 1,33); nenhum em pista.
- Por zona: praça central 34, praças externas 40, anel 83, avenidas 75 e bairros 43 (contando os 18 caminhantes).
- Luzes com alcance de 16 ou mais e estado `ligada`: 166, das quais 61 são os postes de reforço.
- Só os 28 postes originais projetam sombra; os de reforço nascem sem sombra, por desempenho.

## Limitações e estado da versão

- **Estado da cópia.** Os módulos foram exportados do Studio no estado em que estavam quando o chat terminou. Outra sessão, posterior, mudou a vila: retirou 12 NPCs de `Workspace.NPCs` para `ServerStorage.NPCsRetirados` e reduziu o brilho de 18 postes (trabalho da ramificação `3-ajustes-de-luz-npcs-e-desempenho`). Essas mudanças estão em outro lugar e não são repetidas aqui.
- **Estado do Studio.** O lugar ainda não tinha sido salvo pelo Studio no fim do chat. Salvar o lugar é o que torna as mudanças permanentes.
- **Não testado fora do Studio.** Não há interpretador Lua instalado para checar a sintaxe. Os módulos rodaram no Studio durante o chat.
- **FPS não medido.** O custo do elenco completo não foi medido em Play.
- **Falas não lidas uma a uma em Play.** Foram testadas a abertura da caixa, a paginação e a existência de fala para todos os NPCs que conversam.
- **Coberturas e poses pouco vistas.** Algumas poses (`ler`, `cantar`, `cambaleante`) e as armaduras não foram conferidas de perto.
- **Dependência.** `ConstrutorNPCs` depende de `ReplicatedStorage.NPCVila.Assets` (rostos, sujeira e pergaminho), que não está nesta pasta.
