---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, assets, ids]
---
# Roblox - Assets enviados e identificadores
Índice: Jogos - Gerais

## Conceito
- Registro de todos os assets enviados ao Roblox para o projeto, com seu uso atual.

## Imagens
| Identificador | Conteúdo | Situação |
|---|---|---|
| rbxassetid://128342251593093 | Lua desenhada 512x512, disco opaco e halo | Em uso em `Sky.MoonTextureId` |
| rbxassetid://76948571977736 | Brilho de vela radial, versão 1 (vermelho-alaranjado) | Descartado |
| rbxassetid://138720177802588 | Brilho de vela radial, versão 2 (amarelo-alaranjado) | Descartado |
| rbxassetid://124780722048553 | Vidro quadriculado 192x256, 6 colunas por 8 linhas | Em uso no Decal "Vela" das janelas |
| rbxassetid://131079031512133 | Pergaminho 1800x560 (rolo e cauda entalhada), primeira versão | Substituído |
| rbxassetid://75609649066026 | Pergaminho 1800x600 com rolo sombreado, tampa em espiral e varetas | Em uso na caixa de diálogo dos NPCs |
| rbxassetid://135988905753487 | Pergaminho envelhecido 1800x600 (mesma geometria do pergaminho dos NPCs; papel manchado, vincado, rasgado e queimado, rolo de madeira rachada) | Substituído pelo pergaminho realista (abaixo) |
| rbxassetid://125679406697683 | Pergaminho realista 1800x600 (papel com fibras, relevo e manchas de umidade, bordas rasgadas, dois rolos com varetas de madeira; mesma geometria do dos NPCs) | Em uso na caixa de fala do ancião |
| rbxassetid://70925000086204, 135573125080527, 94598767415413, 107905101613781, 104915428537102 | Rostos de homem (1 a 4) e de idoso, primeira versão | Substituídos |
| rbxassetid://103262115416229, 92527580688712, 113140509896953, 107351491893594, 124445591904748 | Rostos de mulher (1 a 4) e de idosa, primeira versão | Substituídos |
| rbxassetid://140598243833248, 119546065912387, 108633861705622, 81904059059465 | Rostos de criança (1 a 4), primeira versão | Substituídos |
| rbxassetid://129301016199119, 139581197084930, 84478788707754, 97185488415949 | Sujeira de roupa, primeira versão (tronco 1, tronco 2, perna, braço) | Substituídos |
| rbxassetid://115576799641801, 87530062892124, 73170334059708, 72818820230242, 135243222276380, 100475936501835, 76354304887776, 94326319016541 | Rostos de homem h1 a h8 | Em uso nos NPCs |
| rbxassetid://108564884155140, 90741139163410, 72756756101468, 112924491574876, 84524270409117, 109437365290827, 81144261806807, 82592588819368 | Rostos de mulher m1 a m8 | Em uso nos NPCs |
| rbxassetid://126333462810542, 123071464252480, 140655909740792, 78647446677923, 87981538160480, 114869389085678, 137571315939593, 110137656785129 | Rostos de criança c1 a c8 | Em uso nos NPCs |
| rbxassetid://103588316791675, 102012615616348 | Rostos de idoso i1 e i2 | Em uso nos NPCs |
| rbxassetid://72469827096834, 86535230586274, 81787181138404, 84420556999216 | Sujeira de roupa, segunda versão: tronco 1, tronco 2, perna, braço | Em uso nos NPCs |

## Texturas de partículas do próprio Roblox (sem envio)
- `rbxasset://textures/particles/sparkles_main.dds`: gotas da fonte.
- `rbxasset://textures/particles/smoke_main.dds`: fumaça das chaminés, névoa da fonte e névoa da Lua.

## Materiais gerados
- Ver Roblox - Materiais PBR gerados no MaterialService.

## Onde o identificador é usado
- Lua: `Lighting.Sky.MoonTextureId` (ver Lua - Textura no Sky).
- Vidro: criação do Decal "Vela" na função `janela` do módulo e script de atualização dos Decals existentes (ver Janelas - Brilho de vela quadriculado).
- Pergaminho envelhecido: constante `PERGAMINHO_VELHO` do módulo `CenaVaranda`, usada na caixa de fala do ancião e no pré-carregamento (ver Pergaminho do ancião - Folha envelhecida e caixa de fala); gerador em Imagem do pergaminho realista - Código gerador em Python (a versão anterior, em Imagem do pergaminho velho - Código gerador em Python).

## Exceções e limites
- Se um asset for reenviado, o id muda; é preciso atualizar o Sky, os Decals existentes (percorrendo `Workspace.Vila.Casas`) e o módulo.

## Relacionados
- Roblox - Imagens geradas por Python e enviadas ao Roblox
- Janelas - Evolução do vidro
