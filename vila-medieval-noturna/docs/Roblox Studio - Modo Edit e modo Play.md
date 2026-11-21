---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, edit, play]
---
# Roblox Studio - Modo Edit e modo Play
Índice: Jogos - Gerais

## Conceito
- O Studio tem dois estados. Em **Edit**, só existe o datamodel Edit, e alterações ficam gravadas no lugar. Em **Play**, existem os datamodels Client e Server, e o Edit fica indisponível; alterações feitas em Play são perdidas ao parar.
- `get_studio_state` informa o modo atual e quais datamodels existem.

## Consequências práticas
- Qualquer `execute_luau` ou `multi_edit` com Edit durante o Play falha com "Edit datamodel is not available in Play mode".
- Alterações em Client ou Server durante o Play servem só para testar (por exemplo, mover o personagem) e não persistem.
- Propriedades de Lighting, Terrain e Parts devem ser definidas em Edit.
- Scripts em StarterPlayerScripts e ServerScriptService só rodam em Play.
- O Play pode estar ligado sem aviso (iniciado por outra ação); a primeira providência quando uma edição falha é chamar `start_stop_play` com `is_start = false`.

## "Play Here" e a posição inicial
- O modo "Play Here" do Studio coloca o personagem onde está a câmera do editor, e não no SpawnLocation. Para garantir o nascimento na praça, o script NascerNaPraca reposiciona o personagem sempre (ver Nascimento do jogador - Script NascerNaPraca).

## Exceções e limites
- Peças criadas por scripts de cliente (como os vagalumes e a névoa da Lua) existem só no cliente e não aparecem em Edit.

## Relacionados
- Roblox Studio - Teste em Play e capturas de tela
- Roblox Studio via MCP - Ferramentas e fluxo de trabalho
