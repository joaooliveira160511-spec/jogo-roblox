---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, materiais]
---
# Casa - Paredes lisas de madeira
Índice: Jogos - Gerais

## Conceito
- As paredes das casas devem parecer madeira pintada, lisa, e não pedra rachada. A solução é usar SmoothPlastic nos blocos de parede e nas empenas, com cores de madeira envelhecida; as vigas (esqueleto) usam Wood padrão em marrom bem escuro e dessaturado.

## O que foi tentado
1. Reboco PBR (material Plaster com a variante vila_reboco): parecia pedra rachada e laranja.
2. Material Concrete e depois Plaster padrão sem variante: textura irregular.
3. Wood padrão com cor (116,92,68): veios laranja-avermelhados fortes, tom de madeira crua.
4. **SmoothPlastic** nas paredes: liso, controla bem a cor. Aprovado.

## Valores finais
- Paredes (blocos "AndarN", "EmpenaE/D", "Trapeira"): SmoothPlastic, cores de `M.plasters`.
- Vigas, postes, escoras, mãos-francesas, caibros e molduras: Wood padrão sem variante, cor (34 a 42, 29 a 37, 25 a 33) escura.
- Cor C.wood = (36,30,26) e C.woodDark = (26,21,18) no módulo.
- Portas e venezianas: WoodPlanks em tons de (46,32,22) e (52,66,56).

## Exceções e limites
- Madeira (Wood) com cor quente tende a sair laranja; manter baixa saturação e valor baixo.
- As variantes PBR vila_madeira e vila_reboco permanecem em MaterialService, mas não são mais usadas (ver Roblox - Materiais PBR gerados no MaterialService).

## Relacionados
- Casa - Andares, balanço e enxaimel
- Vila Medieval - Requisitos visuais do projeto
