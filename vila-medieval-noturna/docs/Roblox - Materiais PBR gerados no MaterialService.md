---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, materiais, pbr]
---
# Roblox - Materiais PBR gerados no MaterialService
Índice: Jogos - Gerais

## Conceito
- A ferramenta `generate_material` cria MaterialVariant (mapas de cor, normal, rugosidade e metal) a partir de uma descrição em texto e de um material base. O resultado é gravado em `MaterialService.AssistantMaterials`, em pastas "Material: nome", com quatro variantes numeradas (nome, nome1, nome2, nome3).
- Uma Part usa a variante ao receber `Part.Material = materialBase` e `Part.MaterialVariant = "nome"`.

## Materiais gerados
| Nome | Material base | Descrição usada | Padrão |
|---|---|---|---|
| vila_paralelepipedo | Cobblestone | paralelepípedo medieval, pedras cinza arredondadas com juntas profundas, musgo, desgaste, relevo forte | Regular |
| vila_telhas | Slate | telhas de ardósia sobrepostas, desgaste, musgo, relevo e sombras entre telhas | Regular |
| vila_madeira | Wood | viga de carvalho escura envelhecida, rachaduras e veios | Organic |
| vila_reboco | Plaster | reboco de cal envelhecido, irregular, manchado | Organic |

## Preparação
- As quatro variantes principais (nome exato) foram movidas para a raiz de `MaterialService`, pois a busca por nome de MaterialVariant funciona melhor ali; `StudsPerTile` foi ajustado para 8 (telhas e paralelepípedo), 6 (madeira) e 12 (reboco).

## Uso final
- **vila_telhas** continua em uso: telhas dos telhados, cumeeiras e remates (material Slate). Ficou com ótimo relevo em close.
- **vila_paralelepipedo**: usado nas pedras das bases das casas construídas antes da troca, mas retirado das pedras do piso e da fonte, pois suas rachaduras escuras davam aspecto sujo e de longe pareciam chão liso; o piso usa Cobblestone padrão sem variante.
- **vila_madeira** e **vila_reboco**: não são mais usados. A madeira dava tom laranja-avermelhado forte e o reboco parecia pedra rachada; as paredes passaram a SmoothPlastic e as vigas a Wood padrão com cor escura (ver Casa - Paredes lisas de madeira).
- No módulo, a tabela `M.variant` mapeia material para nome de variante e só contém Cobblestone e Slate (ver Módulo ConstrutorVilaGrande - Código parte 1 base e luzes).

## Exceções e limites
- Materiais PBR tingem pela cor da Part; uma cor escura multiplica a textura, então a cor base do material aparece pouco quando a Part é muito escura.
- Em luz laranja forte, tudo tende ao bege; esfriar a cor das Parts compensa.

## Relacionados
- Roblox - Assets enviados e identificadores
- Casa - Telhado em fiadas de telhas
