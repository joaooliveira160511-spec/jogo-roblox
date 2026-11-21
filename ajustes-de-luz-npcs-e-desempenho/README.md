# Ajustes de luz, NPCs e desempenho da vila (Roblox Studio)

Ajustes feitos na Vila Medieval Noturna depois da construção da vila (ramificação `2-vila-medieval-noturna`): lampiões de luz mais fraca em alguns postes, retirada dos NPCs que ficariam no escuro por causa disso, diagnóstico do travamento e otimização do script `LuzesCliente`.

Esta pasta reúne **só o que foi criado neste chat**: o `LuzesCliente` otimizado (e o original, para reverter), as três ferramentas em Luau usadas no Studio e as três notas do cofre sobre o trabalho em `docs/`. Os demais scripts da vila continuam na ramificação 2 e no Studio.

## Estado desta versão

- **Scripts exportados do que foi aplicado no chat.** `LuzesCliente.lua` é o texto exato que está em `StarterPlayer.StarterPlayerScripts.LuzesCliente` no Studio; `LuzesCliente_v1.lua` é o original, igual ao `ServerStorage.LuzesCliente_v1`. As ferramentas em `ferramentas/` são os trechos que foram executados com `execute_luau`, com comentários explicando cada um.
- **Os lampiões enfraquecidos e os NPCs retirados não são arquivos.** São mudanças no lugar do Studio: 18 `PointLight` de postes com brilho e alcance menores (atributos `Fraca`, `BrilhoOriginal` e `AlcanceOriginal` na `Chama`) e 12 NPCs movidos de `Workspace.NPCs` para `ServerStorage.NPCsRetirados` (nenhum apagado). O script `aplicar_lampioes_fracos_e_retirar_npcs.lua` mostra como foram escolhidos e permite refazer o processo em outro lugar.
- **O lugar do Studio precisa ser salvo por quem o abre.** No fim do chat o lugar ainda não tinha sido salvo pelo Studio (as alterações estavam só no arquivo de recuperação automática). Salvar o lugar é o que torna as mudanças permanentes.
- **Mudança de NPCs posterior fora desta pasta.** Outra sessão moveu também o NPC `Teodoro` para `ServerStorage.NPCsRetirados`, por motivo de cenário e não de luz (13 retirados no total, 262 em `Workspace.NPCs`). A cópia da nota de NPCs em `docs/` é a do estado deste chat e não traz essa revisão.
- **Não testado fora do Studio.** Não há interpretador Lua instalado para checar a sintaxe deste repositório. Os scripts rodaram no Studio durante o chat.

## Estrutura

```
ajustes-de-luz-npcs-e-desempenho/
├── README.md
├── src/
│   └── StarterPlayerScripts/
│       ├── LuzesCliente.lua             versão otimizada (em uso)
│       └── LuzesCliente_v1.lua          versão original (para reverter)
├── ferramentas/
│   ├── aplicar_lampioes_fracos_e_retirar_npcs.lua   enfraquece postes e retira NPCs (modo Edit)
│   ├── medir_custo_luzes_heartbeat.lua              mede o custo do script de luz em Play
│   └── diagnostico_desempenho_cliente.lua           mede quadro e conta peças, sombras e luzes
└── docs/                                notas do cofre sobre este trabalho
    ├── Postes e lampiões - Lampiões de luz fraca.md
    ├── NPCs da vila - Retirada de NPCs sem luz suficiente.md
    └── Luzes - Otimização do LuzesCliente.md
```

## Onde cada arquivo vai no Studio

| Arquivo | Destino no Studio | Tipo |
|---|---|---|
| `src/StarterPlayerScripts/LuzesCliente.lua` | `StarterPlayer.StarterPlayerScripts.LuzesCliente` | LocalScript |
| `src/StarterPlayerScripts/LuzesCliente_v1.lua` | `ServerStorage.LuzesCliente_v1` | LocalScript com `Enabled = false` (cópia de segurança) |
| `ferramentas/*.lua` | não ficam no Studio; são colados em `execute_luau` | ver o cabeçalho de cada arquivo |

## O que cada ferramenta faz

- **`aplicar_lampioes_fracos_e_retirar_npcs.lua`** (datamodel Edit): escolhe até 22 postes ligados, com 38 studs de distância mínima entre si e semente fixa, e reduz brilho (x0,35 a x0,55) e alcance (x0,70 a x0,80). Em seguida retira os NPCs comuns que ficariam com iluminação no chão abaixo de 0,8 (a regra da vila), sem deixar nenhum dos 29 NPCs originais nem os que caminham nessa situação. Tem trava contra rodar duas vezes.
- **`medir_custo_luzes_heartbeat.lua`** (datamodel Client, em Play): mede o `Stats.HeartbeatTimeMs` com o script de luz ligado e desligado e confere o brilho de um poste normal, um fraco, um piscando e um apagado.
- **`diagnostico_desempenho_cliente.lua`** (datamodel Client, em Play): tempo de quadro, configuração de iluminação e contagem de peças, sombras, decals e luzes. Só lê.

## Medições

Custo de CPU do script de luz por quadro (`Stats.HeartbeatTimeMs`, média em Play no Studio, cerca de 13 fps):

| Condição | Média |
|---|---|
| Sem nenhum script de luz (referência) | 1,65 ms |
| `LuzesCliente` original | 5,19 ms |
| Versão fatiada, sem limite de 20 passadas por segundo | 3,63 ms |
| `LuzesCliente` atual | 3,23 ms |

Acima da referência, o custo do script caiu de cerca de 3,5 ms para cerca de 1,6 ms (redução de uns 55%).

## Como reverter

- **Luz:** desligar ou apagar o `LuzesCliente` atual, copiar `src/StarterPlayerScripts/LuzesCliente_v1.lua` (ou `ServerStorage.LuzesCliente_v1`) para `StarterPlayer.StarterPlayerScripts` com o nome `LuzesCliente` e `Enabled = true`.
- **Lampiões:** para cada `Chama` com o atributo `Fraca`, voltar `Brightness` ao valor de `BrilhoOriginal` e `Range` ao de `AlcanceOriginal`, e remover os três atributos.
- **NPCs:** mover o conteúdo de `ServerStorage.NPCsRetirados` de volta para `Workspace.NPCs`. Eles mantêm posição e atributos.

## Limites

- **O Studio limita o quadro a 15 fps (66,7 ms) nessa medição, mesmo com a cena esvaziada.** Por isso o FPS sozinho não mostra o custo de cada parte; o custo do script foi medido pelo `HeartbeatTimeMs`. O ganho a 60 fps não foi medido.
- **A otimização atinge só o script de luz.** A maior parte do custo restante está nas sombras (cerca de 66 mil peças com `CastShadow`) e no número de luzes ativas, que não foram alterados. Desligar `CastShadow` nas peças de piso (Pedras, Detalhes, Praca, Pracas) é a opção seguinte e não foi aplicada.
- **Itens a mais de 450 studs continuam sem animação**, como na versão anterior; um item longe da câmera demora até cerca de 0,4 s para voltar à atualização plena quando a câmera se aproxima de repente.
- **O repositório é público.** Nada aqui contém chaves, tokens ou dados pessoais.
