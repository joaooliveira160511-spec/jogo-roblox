---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, terreno, voxels]
---
# Terreno - Material Ground e altura real da superfície
Índice: Jogos - Gerais

## Conceito
- O chão de base da vila é Terrain (voxels de 4 studs). Os elementos construídos (piso, pedras, bases das casas) assumem que a superfície do terreno está abaixo de y = 0,5; uma diferença de 2 studs esconde tudo.

## Construção do terreno
1. Mover a Baseplate original para ServerStorage.
2. `Terrain:Clear()`.
3. `Terrain:FillBlock(CFrame.new(0, -8, 0), Vector3.new(768, 16, 768), Enum.Material.Ground)`.
4. `Terrain:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(44, 60, 50))`.
5. Reescrever a camada superior com ocupação parcial (ver abaixo).

## Por que Ground e não Grass
- O material Grass desenha lâminas decorativas 3D que cobrem as peças e o piso; a propriedade que desliga a decoração não existe no contexto de plugin (ver Roblox Studio via MCP - Limitações de permissão). Em Ground não há decoração, e a grama da cena é feita de peças próprias (ver Grama - Geração das lâminas).

## O problema da altura
- Um bloco de Ground com topo em y = 0 produz superfície de colisão e de renderização em y = 2,0. Medições: raycast de cima para baixo acertava "Terrain" em y = 2,0, e `ReadVoxels` mostrava as células [-8,-4] e [-4,0] com ocupação 1 e [0,4] vazia.
- Efeito visível: em Play, o piso (topo em 0,5), as pedras (topo até 0,95) e as bases das casas ficavam sob o terreno; o chão parecia "100% liso" e ocupado só pela cor do terreno.

## A correção
- Reescrever a camada [-4, 0] com `WriteVoxels`, material Ground e ocupação 0,45 em toda a área de 768x768:

```lua
local T = workspace.Terrain
local f, N = 0.45, 192
local regiao = Region3.new(Vector3.new(-384, -4, -384), Vector3.new(384, 0, 384))
local mats, occ = {}, {}
for x = 1, N do
	local mx, ox = {}, {}
	local my, oy = {}, {}
	for z = 1, N do my[z] = Enum.Material.Ground; oy[z] = f end
	mx[1] = my; ox[1] = oy
	mats[x] = mx; occ[x] = ox
end
T:WriteVoxels(regiao, 4, mats, occ)
```

- Resultado: em Play, o personagem (HumanoidRootPart) fica em y ≈ 3,7 sobre as pedras e o piso e as pedras ficam visíveis.
- O raycast ainda pode devolver y = 2,0 para o Terrain em alguns pontos; o teste confiável é visual em Play.

## Exceções e limites
- A água de terreno (fonte) usa células acima do chão; para refazer a fonte, limpar essa região com `FillBlock(CFrame.new(0, 45, 0), Vector3.new(80, 90, 80), Enum.Material.Air)` (ver Fonte - Bacias e água de terreno); esse bloco começa em y = 0 e não apaga a camada de chão.

## Relacionados
- Terreno - Água de terreno e propriedades
- Piso - Pedras individuais estilo cobblestone
