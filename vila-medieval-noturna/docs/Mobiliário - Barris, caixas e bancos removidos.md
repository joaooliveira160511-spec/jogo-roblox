---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, mobiliario, barris]
---
# Mobiliário - Barris, caixas e bancos removidos
Índice: Jogos - Gerais

## Conceito
- A pasta `Workspace.Vila.Mobiliario` guarda os objetos soltos da praça. Hoje contém só barris e caixas junto às casas; os bancos foram removidos por parecerem "cadeiras espalhadas".

## Barris e caixas
- Barril: cilindro de raio 1,5 e altura 3,2, madeira (84,58,38), com dois aros metálicos de raio 1,55.
- Caixa: bloco de 3 x 2,6 x 3 em WoodPlanks (78,62,48), com duas cintas escuras.
- Posição: para cada casa (12), de 1 a 3 objetos a r = 56,2 a 57,4, com 55% de barris e 45% de caixas, deslocados em até ±6 graus do ângulo da casa (Random 777).
- Total: 30 Models, 90 partes.

## Bancos (removidos)
- Existiam 8 bancos em r = 40, ângulos de 22,5 + k*45 graus, cada um com assento de 6,4 x 0,5 x 1,8, encosto e duas pernas de pedra. Foram destruídos (`m.Name == "Banco"`). A função `M.banco` continua no módulo, mas não deve ser chamada.

## Exceções e limites
- O culling por distância controla os Models de Mobiliario (ver Carregamento por distância - Script NevoaDistante).
- As cores de madeira dos barris e caixas tendem a laranja; recolorir se necessário (ver Casa - Paredes lisas de madeira).

## Relacionados
- Adereços - Carroças, feno, cercas e barracas
- Vila Medieval - Requisitos visuais do projeto
