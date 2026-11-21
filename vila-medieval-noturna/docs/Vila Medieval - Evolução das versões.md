---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, historico]
---
# Vila Medieval - Evolução das versões
Índice: [[Jogos - Gerais]]

## Conceito
- O cenário passou por versões sucessivas, cada uma corrigindo a anterior. Conhecer a ordem evita repetir caminhos que já se mostraram ruins.

## Versões
1. **Campo noturno**: terreno de grama, Lua desenhada por interface (SurfaceGui) em uma peça, grama feita de lâminas que reagem ao jogador e brilham com o reflexo lunar.
2. **Praça pequena**: praça de raio 32, casas de enxaimel pequenas (portas de 3 studs), fonte pequena, lampiões baixos, neblina e Lua móvel.
3. **Vila em grande escala**: praça de raio 80, casas com portas de 8 studs, fonte gigante com câmara habitável, postes de 15 studs, piso de pedras individuais, poças e pedregulhos, materiais PBR gerados.
4. **Vila compacta**: praça de raio 58 com casas coladas, Lua como textura do Sky, paredes lisas, piso cobblestone que realmente aparece, janelas de vela, barracas e adereços.
5. **Versão final**: fonte sem câmara e de pedra limpa e escura, sem bancos nem placas, janelas com vidro quadriculado, noite em breu, neblina densa e poças removidas.
6. **Expansão pelas quatro direções**: ruas prolongadas até 250 studs com calçadas, fileiras de casas variadas (mais apagadas e algumas em ruína), praças circulares com anel de casas voltadas para dentro e poço no centro, postes e piso contínuos, pedregulhos reassentados (ver [[Vila Medieval - Expansão pelas quatro direções]]).
7. **Vila circular**: as praças pequenas do fim das ruas perdem o anel de casas; uma muralha de casas voltadas para o centro fecha a vila num círculo de cerca de 375 studs, oito ruas laterais formam um anel viário entre as ruas cardeais e a animação das luzes passa para o cliente (ver [[Vila circular - Muralha de casas voltadas para o centro]], [[Ruas laterais - Anel viário entre as ruas cardeais]] e [[Luzes - Animação no cliente e falhas de carregamento]]).
8. **Sem neblina**: o fog nativo e o descarregamento por distância foram desligados e o mapa inteiro é carregado de uma vez, porque ligavam e desligavam Models com luzes e atrapalhavam a iluminação (ver [[Neblina - Parâmetros e comportamento]]).
9. **Fazendas nos quarteirões diagonais**: a grama atrás das casas dos quatro quarteirões mais próximos do centro deu lugar a uma fazenda moribunda em cada um (caminho de terra na diagonal, trigo morto, poço seco, água derramada, luz fraca e 20 NPCs); a grama restante secou e as lâminas retiradas ficaram guardadas, de modo que tudo pode ser desfeito (ver [[Fazendas dos quarteirões - Visão geral e geometria]]).

## Decisões que mudaram o rumo
- A Lua em peça com SurfaceGui só renderiza perto (menos de cerca de 1.000 studs) e, quando colocada perto, aparece na frente de construções mais distantes; a solução foi a textura do Sky (ver [[Lua - Tentativas descartadas]]).
- O terreno com material Grass mostrava lâminas decorativas por cima do piso e não pode ter a decoração desligada por script; trocou-se para Ground (ver [[Terreno - Material Ground e altura real da superfície]]).
- A superfície do terreno ficava 2 studs acima do esperado e escondia o piso inteiro; o ajuste foi reescrever a camada superior com ocupação 0,45.
- Os materiais PBR gerados para madeira e reboco davam aspecto estranho nas paredes; as paredes passaram a SmoothPlastic (ver [[Casa - Paredes lisas de madeira]]).
- O brilho radial das janelas foi substituído por um vidro quadriculado (ver [[Janelas - Evolução do vidro]]).
- A câmara habitável dentro da fonte foi removida (ver [[Fonte - Câmara habitável removida]]).
- O "círculo de casas" pensado como uma praça em cada rua deu lugar a um único círculo que envolve a vila inteira, com o raio dado pela casa mais distante do centro.
- Piscar e tremer de luzes no servidor replicava milhares de escritas por segundo; a animação foi movida para o cliente.

## Relacionados
- [[Vila Medieval - Visão geral]]
- [[Vila Medieval - Requisitos visuais do projeto]]
- [[Iluminação - Evolução e lições]]
