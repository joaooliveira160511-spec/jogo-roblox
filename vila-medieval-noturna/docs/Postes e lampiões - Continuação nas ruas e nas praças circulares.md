---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, postes, lampioes, expansao]
---
# Postes e lampiões - Continuação nas ruas e nas praças circulares
Índice: [[Jogos - Gerais]]

## Conceito
- A sequência de postes altos com lampião pendurado continua nas quatro ruas e nas praças circulares. O modelo é o mesmo (`M.poste`, ver [[Postes e lampiões - Geometria e luz]]); só mudam a posição, o estado de luz e a base de apoio.

## Ruas
- Os postes das ruas originais estão em x = 76, 112, 148 e 184, alternando os lados. O próximo está em x = 220, no lado +1 (o padrão continua: ímpares do lado +1). Em z = ±12,2 do eixo, com o braço sobre a pista (guinada de ±pi/2).
- Depois dele, a sequência segue nos postes da praça circular, na entrada (ver abaixo). Nas calçadas novas, a base do poste (topo em y = 0,5) assenta sobre o piso.

## Praças circulares
- Doze postes por praça, no raio R - 3,5 = 42,5, nos ângulos de 15 + 30*j graus (j de 0 a 11), ou seja, entre as portas das casas, nunca sobre os degraus. Dois deles flanqueiam a entrada (165 e 195 graus).
- Braço voltado para o centro: `CFrame.lookAt(pos, centro) * CFrame.Angles(0, -pi/2, 0)`, como os da praça central.

## Luz
- PointLight no ajuste final dos postes existentes: Range 44, Brightness 1,25, cor (255,184,108), Shadows = true (o módulo cria com valores antigos e a função `poste2` corrige).
- Estados dos postes novos: 45% ligada, 25% piscando e 30% apagada (os postes originais têm 20% apagados), no total da cena 43 ligados, 18 piscando e 19 apagados.
- Os grupos se chamam `PosteExtLeste1` e `PosteCircLeste1` a `PosteCircLeste12` (e equivalentes) e entram no sistema por tag (ver [[Luzes - Sistema de estados]]).

## Exceções e limites
- As 80 luzes com sombra pesam em hardware modesto; como o carregamento por distância remove os postes além de 160 studs, só os próximos ficam ativos (ver [[Carregamento por distância - Script NevoaDistante]]).
- Os postes das ruas originais fora do piso (x = 112, 148 e 184) ficam sobre a calçada nova; o poste de x = 76 fica sobre a faixa inicial de calçada.

## Código
- `poste2`, `estadoPoste`, `M.postesRua` e `M.postesCirculo`: ver [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]].

## Revisão - ruas laterais, muralha e sombras
- Postes novos: 32 nas ruas laterais (quatro por meia rua, em x = 52, 96, 140 e 184, lados alternados) e 24 na muralha (a cada 15 graus em raio 334); no total 136 Models em `Lampioes` (ver [[Ruas laterais - Anel viário entre as ruas cardeais]] e [[Passeio da muralha - Lajes, pedras e postes]]).
- Só os 28 postes originais mantêm sombra; as 108 luzes dos postes `Ext`, `Circ`, `Anel` e `Muro` ficaram com `Shadows = false`, o que contraria o item "Luz" acima para esses postes (ver [[Luzes - Animação no cliente e falhas de carregamento]]).

## Revisão - reforço nas ruas
- Além dos postes acima, 61 postes `PosteRua` foram acrescentados nas avenidas e nos anéis onde a iluminação ficava abaixo da meta, todos `ligada` e sem sombra; os Models de `Lampioes` passam de 136 para 197 (ver [[Postes e lampiões - Reforço nas ruas escuras]]).

## Relacionados
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Praça circular - Anel de casas voltadas para dentro]]
- [[Ruas - Continuação e calçadas até as praças circulares]]
- [[Postes e lampiões - Reforço nas ruas escuras]]
