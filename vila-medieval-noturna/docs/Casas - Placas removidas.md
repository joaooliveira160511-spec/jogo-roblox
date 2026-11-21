---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, placas]
---
# Casas - Placas removidas
Índice: Jogos - Gerais

## Conceito
- As casas tinham placas penduradas (comércio medieval: "Ferreiro", "Taverna do Corvo", "Padaria", "Boticário", "Alfaiate", "Estalagem", "Tanoeiro", "Curtume") com texto em SurfaceGui. O resultado visual foi considerado ruim e todas foram removidas.

## O que existia
- Braço metálico de 0,5 x 0,5 x 5,2, escora diagonal, duas correntes e uma tábua de 3,8 x 2,6 x 0,35 com SurfaceGui (TextLabel, fonte Antique, cor (214,184,120)) nas duas faces.
- Posição: a 0,33*w do centro, 5,5 acima do topo da base, afastada 0,6 da frente.

## Remoção aplicada
- Destruídas as peças "BracoPlaca", "EscoraPlaca", "CorrentePlaca" e "Placa" em todas as casas.
- A função `placa` e o parâmetro `o.placa` ainda existem no módulo; não passar `placa` nas chamadas de `casa`.

## Regra
- Não adicionar placas, letreiros ou textos às fachadas.

## Relacionados
- Casas - Posicionamento no anel da praça
- Vila Medieval - Requisitos visuais do projeto
