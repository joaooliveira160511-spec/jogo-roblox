---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, poco, praca, luzes]
---
# Poço - Centro da praça circular
Índice: [[Jogos - Gerais]]

## Conceito
- Cada praça circular tem no centro um poço coberto de pedra e madeira, com um lampião pendurado. Faz o papel de ponto focal que, na praça central, é da fonte gigante. O Model `Poco` fica em `Workspace.Vila.Mobiliario`.

## Geometria (função `M.poco`, referencial: base em y = 0,5, lampião voltado para -Z local)
- `PocoSoleira`: cilindro de raio 4,8 e altura 0,6, pedra escura.
- `PocoMuro`: cilindro de raio 3,5 e altura 3,0 (centro em y = 2,6), pedra.
- `PocoBorda`: cilindro de raio 3,8 e altura 0,45 (centro em y = 4,33), pedra clara.
- `PocoAgua`: disco de raio 2,7 e 0,08 de espessura em y = 4,6, Glass escuro (8,14,22), Reflectance 0,3, sem colisão; parece a boca do poço.
- Dois postes de madeira (0,6 x 7,6 x 0,6) em x = ±3,2, viga transversal de 7,4 em y = 12,3.
- Telhado de duas águas: duas lajes de 8,6 x 0,4 x 4,6 em Slate (40,42,50), inclinadas em ±0,62 rad, em y = 12,9 e z = ±1,87, com cumeeira de 8,8 x 0,4 x 0,6 em y = 14,15.
- Rolo de madeira em y = 10,2, manivela, corda de 4,6 e balde de raio 0,7 com aro de ferro em y = 5,1.
- Lampião: braço de ferro de 2,6, corrente e lanterna de quatro quinas com a "Chama" de vidro (0,68 x 1,0 x 0,68) em (3,2; 8,7; -2,5).

## Luz
- PointLight na chama: alcance 40, brilho 1,0, cor (255,184,108), com sombras. Entra no sistema de luzes por tag, estado e grupo (`pocoLeste`, `pocoNorte`, `pocoOeste`, `pocoSul`) (ver [[Luzes - Sistema de estados]]).
- Estados: Leste ligada, Norte piscando, Oeste apagada e Sul ligada.

## Variante em ruína
- Com `ruina = true` desaparece a água de telhado do lado -Z e a cumeeira, a corda e o balde que pendiam saem do poço, e o balde fica no chão em (2,4; 0,95; -4,2). Usada nos poços de Oeste e de Sul.

## Orientação
- O lampião fica voltado para a entrada da praça: o poço é posicionado com `CFrame.new(centro.X, 0,5, centro.Z) * rot * CFrame.Angles(0, pi/2, 0)`.

## Código
- `M.poco`: ver [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]].

## Relacionados
- [[Praça circular - Anel de casas voltadas para dentro]]
- [[Fonte - Estrutura em níveis]]
- [[Postes e lampiões - Geometria e luz]]
