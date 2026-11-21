# Terraço sem pulo, idoso na cadeira e Teodoro retirado

Ramificação 4 do repositório `jogo-roblox`: trabalho da Vila Medieval Noturna feito no Roblox Studio.

## Conteúdo

| Arquivo | Tipo no Studio | Função |
|---|---|---|
| `src/StarterPlayerScripts/TerracoSemPulo.lua` | LocalScript em `StarterPlayer.StarterPlayerScripts` | Desliga o pulo enquanto o personagem está na caixa do terraço da `CasaNorteCobertura`. |
| `src/ServerStorage/IdosoCadeira.lua` | ModuleScript em `ServerStorage` | Constrói o idoso sentado na cadeira de balanço, com banquinho de pés, almofada de encosto e bengala. |
| `src/alteracoes/NPCsVila-tag-NPCVila.lua` | Trecho para o LocalScript `NPCsVila` | Registra também os NPCs com a tag `NPCVila`. Não é o script inteiro: o restante já está no seu projeto. |
| `src/alteracoes/Poses-sentado_cadeira.lua` | Trecho para o ModuleScript `NPCVila.Poses` | Acrescenta a pose `sentado_cadeira`. Não é o módulo inteiro. |

## Como usar

1. Colocar cada arquivo na pasta `StarterPlayerScripts` ou `ServerStorage` indicada na tabela. Os trechos de `alteracoes/` são colados nos scripts que já existem, nos lugares indicados em cada arquivo.
2. Em Edit, para construir o idoso (usar uma cópia do módulo, porque o `require` guarda o código em cache):

```lua
require(game.ServerStorage.IdosoCadeira:Clone()).construir(workspace.Vila.Casas.CasaNorteCobertura)
```

3. Refazer a fachada pelo `ConstrutorCasaFachada` apaga o idoso. Nesse caso, rodar o comando acima de novo.

## Estado da versão

- Pulo travado no terraço: testado em Play. Em oito tentativas no terraço a variação de altura foi 0,00; na rua, o pulo voltou ao normal (7,22).
- Idoso: validado por números (posição dos pés, dos antebraços e da cabeça); a aparência não foi conferida em imagem.
- Banquinho de pés sem colisão, de propósito: com colisão, ele empurrava para cima o jogador parado à frente, a cada balanço.
- Teodoro: retirado de `Workspace.NPCs` e movido para `ServerStorage.NPCsRetirados`. Mudança de posição no Studio, sem script.

## Limitações

- Esta ramificação traz só o que foi criado ou alterado no chat que a gerou. O Studio pode ter versões mais novas de `TerracoSemPulo`, `IdosoCadeira` e `NPCsVila` (de outros trabalhos); essas versões não entram aqui. Se um script mudar no Studio e não for exportado de novo, esta ramificação fica desatualizada.
- `ReconstruirNPCs` traz o Teodoro de volta, porque ele continua em `PosicoesNPC`.
