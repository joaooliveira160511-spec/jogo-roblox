---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, mcp, permissoes]
---
# Roblox Studio via MCP - Limitações de permissão
Índice: Jogos - Gerais

## Conceito
- O código de `execute_luau` roda com a identidade de plugin do Studio, que não tem todas as capacidades. Algumas propriedades são ilegíveis ou imutáveis nesse contexto, e algumas simplesmente não existem para o plugin.

## O que não funciona
- **`Lighting.Technology`**: ler e escrever geram "The current thread cannot read/write 'Technology' (lacking capability RobloxScript)". A tecnologia de iluminação (Future, ShadowMap, Voxel) precisa ser trocada manualmente no painel Properties do Lighting.
- **`Terrain.Decoration`**: "is not a valid member of Terrain". A decoração de grama 3D do material Grass não pode ser desligada por script.
- **`Workspace.StreamingTargetRadius`**: "is not a valid member of Workspace". O raio de streaming não é ajustável por script; `StreamingEnabled` pode ser lido (no projeto está ligado).
- **`HttpService`**: `HttpEnabled` é falso e `GetAsync` falha com "HTTP requests are not enabled. Enable via Experience Settings". Não há como enviar dados do Studio para fora por HTTP; para extrair código, usar `script_read`.
- **Câmera**: mudar `CameraType` para Scriptable em `execute_luau` é revertido pela ferramenta ("The execute_luau changed camera type. Resetting...").

## O que funciona
- Ler e escrever propriedades de Lighting (exceto Technology), Sky, Atmosphere, efeitos de pós-processamento, Terrain (água, cor de material, FillBlock, FillCylinder, WriteVoxels, ReadVoxels), MaterialService e a maioria das propriedades de Parts.
- Criar scripts e definir `Source`.
- CollectionService (AddTag e GetTagged) e atributos.

## Técnicas de contorno
- Para a tecnologia de iluminação, orientar o dono do projeto a ajustá-la manualmente; as sombras de PointLight (`Shadows = true`) só aparecem sob Future.
- Para a decoração do terreno, trocar o material para Ground (ver Terreno - Material Ground e altura real da superfície).
- Para distâncias de streaming, implementar descarregamento próprio no cliente (ver Carregamento por distância - Script NevoaDistante).

## Relacionados
- Roblox Studio via MCP - Ferramentas e fluxo de trabalho
- Roblox Studio - Streaming e SurfaceGui à distância
