---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, fonte, estrutura]
---
# Fonte - Estrutura em níveis
Índice: Jogos - Gerais

## Conceito
- A fonte é um Model chamado "Fonte" em `Workspace.Vila`, centrado em (0, 0,5, 0), com cerca de 65 studs de altura e 62 de diâmetro. A altura base é b = 0,5 (topo do piso). Todas as alturas abaixo são relativas a b. É um monumento fechado: não existe câmara nem porta (ver Fonte - Câmara habitável removida).

## Camadas (de baixo para cima)
| Elemento | Raio | Altura / posição | Observação |
|---|---|---|---|
| FundoBacia | 27,6 | espessura 0,6 em b+0,3 | chão da bacia |
| DegrauBacia | 30,6 | 64 blocos, y = b+0,8, altura 1,6, espessura 2,8 | degrau externo |
| ParedeBacia | 26,2 | 56 blocos, y = b+3, altura 6, espessura 3,0 | parede da bacia (círculo fechado) |
| CapaBacia | 26,2 | y = b+6,4, altura 0,9, espessura 4,3 | capa de coroamento, sem colisão |
| Pilastras | 27,6 | 8, 2,6 x 8,4 x 2,6, ângulos de 22,5 + k*45 graus | com esferas de 2,2 no topo |
| PedestalCentral | 10,5 | altura 16, centro em b+8 | cilindro maciço |
| ColarPedestalBase / Topo | 11,5 / 11,3 | b+1,1 / b+15,4 | anéis decorativos |
| PilastraPedestal | 10,9 | 14 blocos de 1,2, altura 14 | detalhe vertical |
| PratoMedio | 17 | espessura 1,2 em b+16,6 | chão do nível 1 |
| BordaMedia | 16,2 | 40 blocos, y = b+18,7, altura 3 | borda do nível 1 |
| Coluna1 | 4,6 | altura 11,8 em b+23,1 | com colares |
| BaciaN2 | 11 | espessura 1,2 em b+29,6 | nível 2 |
| BordaN2 | 10,6 | 28 blocos, y = b+31,5, altura 2,6 | |
| Coluna2 | 2,6 | altura 9,8 em b+35,1 | com colar |
| BaciaN3 | 6,5 | espessura 1,0 em b+40,5 | nível 3 |
| BordaN3 | 6,2 | 20 blocos, y = b+42,1, altura 2,2 | |
| Coluna3 | 1,3 | altura 6 em b+44 | |
| Pinaculo / Esfera | 0,9 / 1,7 | b+47,8 / b+49,4 | topo |

- A água de cada bacia é água de terreno (ver Fonte - Bacias e água de terreno); os jatos e bicas em Fonte - Jatos, bicas e respingos.
- Os blocos dos anéis são criados por `anel(nome, n, raio, y, h, grossura, cor1, cor2, colide)`: n blocos com comprimento tangencial `2*pi*raio/n*1,04`, cada um voltado para o centro e com cores alternadas.

## Cores
- Pedra limpa e escura: PA (66,66,70), PB (57,57,61), PL (80,80,86), PD (46,46,50), depois esfriadas por fatores (0,88; 0,96; 1,14) em R, G e B (ver Fonte - Pedra limpa e escura).

## Código
- Ver Módulo ConstrutorVilaGrande - Código parte 6 fonte.

## Relacionados
- Fonte - Falhas periódicas
- Praça - Geometria e raios
