---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, fonte, agua]
---
# Fonte - Bacias e água de terreno
Índice: Jogos - Gerais

## Conceito
- A água da fonte são quatro cilindros de água de terreno, um por bacia, dimensionados para ficar um pouco abaixo da borda de pedra. A função interna `agua(raio, y0, y1)` chama `Terrain:FillCylinder(CFrame.new(x, (y0+y1)/2, z), y1-y0, raio, Enum.Material.Water)`.

## Bacias
| Bacia | Raio da água | y inferior | y superior |
|---|---|---|---|
| Principal | 24,8 | b+0,6 | b+4,2 |
| Nível 1 | 14,4 | b+17,2 | b+19,2 |
| Nível 2 | 9,5 | b+30,2 | b+31,8 |
| Nível 3 | 5,5 | b+41,0 | b+42,3 |

- b = 0,5. A borda da bacia principal chega a b+6,4, de modo que a água fica cerca de 2 studs abaixo do topo.

## Limpeza antes de refazer
- A água de terreno persiste no mundo. Antes de reconstruir a fonte, apagar os voxels acima do chão:

```lua
workspace.Terrain:FillBlock(CFrame.new(0, 45, 0), Vector3.new(80, 90, 80), Enum.Material.Air)
```

- Esse bloco começa em y = 0 e não toca na camada de chão (ver Terreno - Material Ground e altura real da superfície).

## Aparência
- Cor, reflexo, ondas e transparência vêm das propriedades do Terrain (ver Terreno - Água de terreno e propriedades).
- Sob a tecnologia Future, a água reflete também as luzes; com outras tecnologias, só reflete o céu.

## Exceções e limites
- Os voxels de 4 studs deixam a borda da água serrilhada; as paredes de pedra (espessura 3) escondem isso.
- A água não transborda nem muda de nível; o efeito de queda vem das partículas (ver Fonte - Jatos, bicas e respingos).

## Relacionados
- Fonte - Estrutura em níveis
