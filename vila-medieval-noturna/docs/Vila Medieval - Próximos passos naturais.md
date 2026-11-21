---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, expansao]
---
# Vila Medieval - Próximos passos naturais
Índice: [[Jogos - Gerais]]

## Conceito
- Extensões coerentes com o modelo atual. Cada uma reutiliza as funções do módulo e as regras de estilo já registradas.

## Extensões possíveis
- **Casas ao longo das ruas**: usar `casa` com frente voltada para o eixo da rua, afastando a fachada 14 studs do eixo (meio-fio em 10,5). O limite de peças por casa é cerca de 540 (ver [[Vila Medieval - Estado final e números de verificação]]).
- **Mais ruas e bairros**: as quatro ruas têm 13 segmentos de 12,2 studs (até cerca de 216 studs do centro); estender além disso exige também estender `pedras` e `detalhes`.
- **Interiores**: as casas são fechadas por blocos maciços; para entrar, trocar a base por paredes ocas e usar a porta já modelada.
- **Mais variações de adereços**: o módulo tem funções para carroça, feno, cerca e barraca; novas peças devem seguir a paleta de madeira e pedra (ver [[Vila Medieval - Paleta de cores e materiais]] e [[Adereços - Carroças, feno, cercas e barracas]]).
- **Sons ambientes**: não há áudio no projeto; um som de água para a fonte e vento para a neblina combinaria com o conjunto.
- **Mais falhas de luz**: o script LuzesDaVila já aceita novos itens marcados com a tag Luz e atributos Estado e Grupo (ver [[Luzes - Sistema de estados]]).
- **Desempenho**: se necessário, reduzir os 1.500 pedregulhos, as lâminas de grama ou o número de pedras (ver [[Carregamento por distância - Script NevoaDistante]]).

## Extensões já realizadas
- **Casas ao longo das ruas** e **mais ruas e bairros**: as ruas foram prolongadas até 250 studs, com fileiras de casas variadas e, no fim de cada uma, uma praça circular com anel de casas (ver [[Vila Medieval - Expansão pelas quatro direções]], [[Casas das ruas - Fileiras variadas e luzes apagadas]] e [[Praça circular - Anel de casas voltadas para dentro]]).
- **Estender `pedras` e `detalhes`** além de 216: feito com funções próprias de calçada, pedras e pedregulhos (ver [[Ruas - Continuação e calçadas até as praças circulares]]).
- Continuam em aberto: interiores, sons ambientes, mais variações de adereços e grama nas áreas novas.
- **Vila circular**: ruas laterais com anel viário e muralha de casas voltadas para o centro (ver [[Vila circular - Muralha de casas voltadas para o centro]] e [[Ruas laterais - Anel viário entre as ruas cardeais]]).
- **Mais luzes de casas**, agora animadas no cliente (ver [[Luzes - Animação no cliente e falhas de carregamento]]).
- Em aberto depois da vila circular: grama nos quarteirões internos e fora da muralha (a grama só existe a menos de 149 do centro), portões na muralha, uso dos quarteirões vazios entre as ruas, medição confiável de FPS e novas ruas ou praças centrais dentro dos quarteirões.

## Regras para qualquer extensão
- Manter a escala grande (porta de 8 studs, postes de 15).
- Manter a noite em breu e as fontes de luz quentes e localizadas.
- Não criar peças em modo Play; construir em Edit e testar em Play.

## Relacionados
- [[Vila Medieval - Requisitos visuais do projeto]]
- [[Vila Medieval - Ordem de reconstrução passo a passo]]
