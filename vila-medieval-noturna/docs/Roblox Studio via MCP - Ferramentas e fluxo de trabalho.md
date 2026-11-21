---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, mcp, ferramentas]
---
# Roblox Studio via MCP - Ferramentas e fluxo de trabalho
Índice: Jogos - Gerais

## Conceito
- O Roblox Studio é controlado por um servidor MCP que expõe ferramentas a um assistente de IA com acesso a ferramentas. Todas exigem o parâmetro `studio_id`, obtido com `list_roblox_studios` (no projeto, o lugar aparece com o nome "Place1").
- As ferramentas usadas e para que servem:
  - `list_roblox_studios`: lista as instâncias do Studio e seus ids.
  - `get_studio_state`: informa o modo atual (Edit ou Play) e os datamodels disponíveis.
  - `execute_luau`: executa código Luau; exige `datamodel_type` (Edit, Client ou Server).
  - `multi_edit`: cria ou edita scripts por substituição de trechos; só funciona no datamodel Edit.
  - `script_read`: lê o código de um script com números de linha, inteiro ou por faixa de linhas.
  - `script_grep`, `script_search` e `search_game_tree`/`inspect_instance`: exploram scripts e a hierarquia.
  - `start_stop_play`: liga e desliga o Play.
  - `screen_capture`: devolve uma imagem do viewport.
  - `get_console_output`: devolve a saída do Output.
  - `generate_material`: cria MaterialVariant por IA (ver Roblox - Materiais PBR gerados no MaterialService).
  - `upload_image`: envia imagens servidas por HTTP (ver Roblox - Imagens geradas por Python e enviadas ao Roblox).
  - `search_asset`/`insert_asset`: banco de assets da Creator Store.

## Fluxo de trabalho adotado
1. Construir em Edit por chamadas de `execute_luau`, uma etapa por chamada, com `task.wait()` entre blocos grandes para não congelar o Studio.
2. Para scripts persistentes, usar `multi_edit` com `className` na criação, ou atribuir `Source` por `execute_luau`.
3. Testar em Play com `start_stop_play`, executar teletransportes no datamodel Client e capturar a tela (ver Roblox Studio - Teste em Play e capturas de tela).
4. Parar o Play e voltar a Edit antes da próxima alteração (ver Roblox Studio - Modo Edit e modo Play).
5. Verificar com contagens e leituras por script, não apenas pela imagem.

## Boas práticas
- Criar peças grandes em lotes e só parentear no Workspace ao final do lote.
- Não deixar `while true do` sem `task.wait()` em `execute_luau`: o Studio congela.
- Registrar tudo que for persistente em scripts, não em estado da sessão.

## Exceções e limites
- A fonte de informações de uma chamada é apenas o retorno do `execute_luau`; propriedades protegidas retornam erro de capacidade (ver Roblox Studio via MCP - Limitações de permissão).

## Relacionados
- Roblox Studio - ModuleScript, require e cache
- Vila Medieval - Ordem de reconstrução passo a passo
