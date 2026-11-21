---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, grama, limpeza]
---
# Grama - Limpeza sob as construções novas
Índice: [[Jogos - Gerais]]

## Conceito
- As lâminas de grama (anel de r = 92 a 150 em torno do centro) deixam o piso e as casas novas atravessados por pontas pretas. Depois de construir calçadas e casas, as lâminas que ficam sob elas são removidas.

## Regra
- Para cada lâmina com posição a mais de 80 studs do centro, testa-se se ela está dentro de algum "oclusor":
  - as lajes `Calcada` (metade do tamanho mais 0,4 de margem);
  - a peça `Fundacao` de cada casa nova (metade do tamanho mais 1,4 de margem).
- O teste usa `CFrame:PointToObjectSpace` e compara com as meias dimensões em X e Z. A lâmina removida é destruída em Edit.
- Resultado: 2.977 lâminas na primeira passagem e 159 na segunda (depois que as casas foram afastadas para x = 90), o que deixou 4.547 das 7.683.

## Por que funciona
- O script `GramaViva` monta seu cache a cada início de jogo a partir das lâminas existentes em `Workspace.Grama`, então lâminas removidas em Edit não deixam rastros (ver [[Grama - Script GramaViva]]).
- As lâminas têm `CanQuery = false`, por isso não entram nas consultas de sobreposição usadas para as pedras; o teste geométrico é o caminho.

## Exceções e limites
- A grama não foi estendida às áreas novas além de r = 150: o terreno ali é o Ground liso, e a densidade da grama já decai até zero em 150 (ver [[Grama - Geração das lâminas]]).

## Código
- `M.limpaGrama`: ver [[Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção]].

## Revisão - quarteirões das fazendas
- Nos quatro quarteirões diagonais a regra foi outra: em vez de destruir as lâminas sob as construções, as 3.281 lâminas que caíam na área de cada fazenda foram movidas para `ServerStorage.GramaSubstituida` (uma pasta por quarteirão, com o atributo `Trecho`), e as 1.263 que ficaram foram escurecidas e rareadas. Nada foi apagado de vez e a operação tem volta (detalhes na nota da grama seca das fazendas, em Relacionados).
- A contagem de 4.547 lâminas acima vem do primeiro ajuste; a de 4.544 é a medida na hora da retirada, e a diferença de três lâminas não foi investigada.

## Relacionados
- [[Fazendas dos quarteirões - Grama seca e retirada das lâminas]]
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Ruas - Continuação e calçadas até as praças circulares]]
