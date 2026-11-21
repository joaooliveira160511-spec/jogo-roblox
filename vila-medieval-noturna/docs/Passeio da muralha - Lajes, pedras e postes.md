---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, muralha, piso, postes]
---
# Passeio da muralha - Lajes, pedras e postes
Índice: [[Jogos - Gerais]]

## Conceito
- Diante das casas da muralha corre um passeio circular de pedra, do mesmo estilo do piso das ruas, com postes de lampião. Ele liga as quatro praças dos portões e dá chão firme a quem anda ao longo da muralha (ver [[Vila circular - Muralha de casas voltadas para o centro]]).

## Lajes-base
- Anel de lajes `Calcada` (topo em 0,5) com raio médio 335,5: `floor(2*pi*335,5/12 + 0,5)` lajes, cada uma com largura tangencial igual ao arco mais 0,5, 1,0 de espessura e 23,0 de profundidade radial (de 324 a 347), orientadas com `CFrame.lookAt(posição, origem)`.
- Lajes que caem dentro das praças dos portões (distância ao centro da praça menor que 44) são puladas.

## Pedras
- Anéis concêntricos de pedras individuais (`pedraNova`) de r = 325,2 a 346,0 em passos de 2,4, cada pedra voltada para o centro e com número de pedras `floor(2*pi*r/2,35)` por anel.
- Os Models têm 36 pedras (cerca de 85 studs de arco), pequenos o bastante para o descarregamento por distância (ver [[Carregamento por distância - Script NevoaDistante]]); nomes `Muralha<anel>_<n>`.
- Pedras a menos de 47,5 do centro de uma praça de portão são puladas; sobram 6.546 pedras depois da limpeza das que ficam sob as casas.

## Postes
- 24 posições a cada 15 graus, deslocadas de 7,5, em raio 334, voltados para o centro; os que ficariam a menos de 50 do centro de uma praça são pulados (nenhum foi pulado na cena final).
- `estadoPoste` (45% ligada, 25% piscando, 30% apagada), nomes `PosteMuro1` a `PosteMuro24`, luz sem sombra (ver [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]).

## Meio-fio das praças dos portões
- Com as casas do círculo removidas, o meio-fio que ficava de fora junto das portas foi completado: 132 blocos no total (ver [[Praça circular - Anel de casas voltadas para dentro]]).

## Código
- `M.passeioMuro`, `M.pedrasAneis2`, `M.postesMuro` e `M.completaMeioFio`: ver [[Módulo ConstrutorVilaGrande - Código parte 10 vila circular]].

## Relacionados
- [[Ruas laterais - Anel viário entre as ruas cardeais]]
- [[Piso - Pedras individuais estilo cobblestone]]
- [[Vila Medieval - Expansão pelas quatro direções]]
