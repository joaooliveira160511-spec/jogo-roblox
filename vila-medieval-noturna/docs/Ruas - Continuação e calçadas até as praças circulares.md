---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, ruas, calcadas, piso]
---
# Ruas - Continuação e calçadas até as praças circulares
Índice: [[Jogos - Gerais]]

## Conceito
- Cada rua cardeal, que terminava em x = 216, continua até x = 250,4 e desemboca na praça circular. Dos dois lados passa a existir uma calçada de pedra, de modo que o chão da vila prossiga igual: mesma cor, mesma espessura e mesmas pedras individuais.

## Continuação da rua
- Três segmentos de 11,67 de comprimento (peça de 11,87 com sobreposição), de x = 215,4 a 250,4, com largura 20,4, espessura 1,0 e cor (46,45,46), Cobblestone.
- Meios-fios nas laterais em z = ±10,5, com os mesmos blocos de 1,0 x 1,4; a alternância de cor entre (122,116,106) e (96,92,86) continua a da rua original (o primeiro segmento novo é o de índice 13).
- Pedras individuais: fileiras de x = 214,6 a 249,6 em passos de 2,4, de z = -9,4 a 9,45 em passos de 2,35.
- Os segmentos novos se chamam `Rua` e `MeioFioRua` e ficam em `Workspace.Vila.Praca`, para que o script de carregamento por distância os trate como os originais (ver [[Carregamento por distância - Script NevoaDistante]]).

## Calçadas
- Lajes-base chamadas `Calcada` (espessura 1,0, topo em 0,5, igual à rua), em três faixas por lado:
  - faixa principal, x de 84 a 232, de z = 11,2 a 24,0 (a borda externa do meio-fio é 11,2);
  - faixa final, x de 232 a 250,4, de z = 11,2 a 16,0, que acompanha a rua até a boca da praça;
  - faixa inicial, x de 62 a 84, de z = 11,2 a 17,5, entre a rua e as casas do anel da praça central.
- Pedras individuais sobre as lajes, com as mesmas regras do piso: z de 11,7 a 23,5 na faixa principal, de 11,7 a 15,6 na final e de 11,7 a 17,1 na inicial.
- As pedras que ficam sob casas, degraus ou outras peças consultáveis das casas são removidas por uma consulta de sobreposição (`GetPartBoundsInBox` com filtro só nas casas), o que também funciona com as casas originais do anel.

## Por que a calçada existe
- A superfície real do terreno ficou em y = -0,2 (raycast contra o Terrain com a camada superior em ocupação 0,45), enquanto postes, carroças e degraus são apoiados em y = 0,5. Fora do piso, essas peças pairam cerca de 0,7 stud acima do chão.
- A faixa pavimentada com topo em 0,5 elimina essa diferença nas calçadas e dá o chão de pedra até a porta de cada casa (ver [[Terreno - Material Ground e altura real da superfície]]).

## Código
- `M.ruaExtensao`, `M.calcada`, `M.pedrasCampo` e `M.limpaPedras`: ver [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]]; a chamada completa por direção está em `M.pisoDirecao` e `M.casasDirecao` ([[Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção]]).

## Exceções e limites
- A faixa de calçada atrás das casas não existe: as casas assentam sobre o terreno, com uma fundação escondida (ver [[Casas das ruas - Fileiras variadas e luzes apagadas]]).
- As cercas originais em z = ±15,2 passam a ficar sobre a calçada; os degraus das casas novas começam além delas.

## Revisão - cruzamentos com as ruas laterais
- No meio de cada rua cardeal (x = 200) sai uma rua lateral para cada lado; para abri-las, saíram as quartas casas das fileiras, as pedras de calçada sob a pista lateral e partes do meio-fio (ver [[Ruas laterais - Anel viário entre as ruas cardeais]] e [[Cruzamentos - Limpeza de casas, pedras e meios-fios]]).
- A rua cardeal continua inteira pelo cruzamento e acaba em x = 250,4, na praça do portão (ver [[Passeio da muralha - Lajes, pedras e postes]]).

## Relacionados
- [[Ruas - Quatro caminhos cardeais]]
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Piso - Pedras individuais estilo cobblestone]]
- [[Praça circular - Anel de casas voltadas para dentro]]
