---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, expansao, visao-geral]
---
# Vila Medieval - Expansão pelas quatro direções
Índice: [[Jogos - Gerais]]

## Conceito
- As quatro ruas cardeais da vila foram prolongadas. Ao longo de cada uma continuam as fileiras de casas, mais variadas, mais apagadas e algumas em ruína. No fim de cada rua há uma praça circular menor, cercada por casas voltadas para dentro, sem novas ruas saindo dela.
- O piso continua com as mesmas pedras individuais, os lampiões continuam na mesma sequência de postes com lampião pendurado, e cada praça circular tem um poço coberto no centro.

## Geometria geral
- Cada direção usa um referencial próprio de rua: x cresce ao se afastar do centro da vila e z é o deslocamento lateral. A rotação é `CFrame.Angles(0, k * pi / 2, 0)` com k = 0 Leste, 1 Norte, 2 Oeste, 3 Sul (ver [[Ruas - Quatro caminhos cardeais]]).
- Fileiras de casas: x de 90 a 214, uma de cada lado da rua (ver [[Casas das ruas - Fileiras variadas e luzes apagadas]]).
- A rua continua de x = 215,4 até x = 250,4, com calçadas de pedra dos dois lados (ver [[Ruas - Continuação e calçadas até as praças circulares]]).
- Praça circular de raio 46 com centro em x = 296 (ver [[Praça circular - Anel de casas voltadas para dentro]]).
- O terreno tem 768 x 768 (de -384 a 384); o ponto mais distante das casas das praças circulares fica a cerca de 373 do centro, dentro do terreno.

## Números da cena depois da expansão
- Casas novas: 77 (Leste 19, Norte 19, Oeste 19, Sul 20), somadas às 12 originais, 89 no total.
- Níveis de envelhecimento das casas novas, somando as quatro direções: 25 intactas, 18 gastas, 19 decadentes e 15 em ruína total (ver [[Casas em ruína - Níveis de envelhecimento]]).
- Postes novos: 52 (um por rua e doze por praça circular), 80 no total (ver [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]).
- Models de pedra: 616 (os 104 originais mais 512 novos); partes de pedra: 10.732.
- Partes em `Workspace.Vila`: 55.676 (eram 13.092). Casas: 38.424 partes em 89 Models.
- Pedregulhos: 3.239 (os 1.500 originais, reassentados, e 1.739 novos) (ver [[Piso - Pedregulhos flutuando e reassentamento]]).
- Lâminas de grama: 4.547 (eram 7.683; 3.136 foram removidas sob as construções novas) (ver [[Grama - Limpeza sob as construções novas]]).

## Pastas usadas
- `Workspace.Vila.Casas`: casas novas com nomes `CasaLesteA1`, `CasaLesteB1`, `CasaCircLeste1` e equivalentes de Norte, Oeste e Sul (A é o lado +Z do referencial da rua, B o lado -Z).
- `Workspace.Vila.Pedras`: Models `RuaExt...`, `Calc...` e `Circulo...`.
- `Workspace.Vila.Praca`: segmentos `Rua`, `MeioFioRua` e lajes `Calcada`.
- `Workspace.Vila.Pracas` (pasta nova): um Model por praça circular (`PracaLeste`, `PracaNorte`, `PracaOeste`, `PracaSul`).
- `Workspace.Vila.Lampioes`: postes `PosteExt...` e `PosteCirc...`.
- `Workspace.Vila.Mobiliario`: lenha, barris, caixas e os quatro poços.
- `Workspace.Vila.Detalhes`: Models `PedregulhosNovos`.

## Ordem de construção
1. `limparExtensao` (opcional, apaga tudo o que a expansão criou).
2. `pisoDirecao` para k de 0 a 3.
3. `casasDirecao` para k de 0 a 3.
4. `pedregulhosDirecao` para k de 0 a 3.
5. `limpaGrama`.
6. `fixaPivos` (ver [[Carregamento por distância - Pivôs dos Models novos]]).
- O código está em [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]], [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]] e [[Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção]].

## Revisão - vila circular
- Esta expansão foi revista: o anel de casas voltadas para dentro deixou de ser um conjunto de quatro círculos nas pontas das ruas e passou a ser uma muralha contínua de 84 casas que envolve a vila inteira (ver [[Vila circular - Muralha de casas voltadas para o centro]]). As 44 casas do círculo foram removidas; as praças pequenas mantêm piso, poço e postes.
- Das 77 casas novas desta expansão sobram 24 nas ruas cardeais (9 saíram para abrir as ruas laterais) e foram acrescentadas 69 casas ao longo das oito ruas laterais (ver [[Ruas laterais - Anel viário entre as ruas cardeais]] e [[Cruzamentos - Limpeza de casas, pedras e meios-fios]]).
- O raio da vila passa a ser dado pela casa mais distante do centro, cerca de 375 (o fundo das casas da muralha), dentro dos 384 do terreno.
- Pastas novas ou ampliadas: `Casas` (`CasaAnel...` e `CasaMuro...`), `Pedras` (`RuaAnel...`, `CalcAnel...` e `Muralha...`), `Praca` (peças com o atributo `Anel`) e `Lampioes` (`PosteAnel...` e `PosteMuro...`).

## Relacionados
- [[Vila Medieval - Visão geral]]
- [[Vila Medieval - Estado final e números de verificação]]
- [[Poço - Centro da praça circular]]
- [[Vila Medieval - Requisitos visuais do projeto]]
