---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, fonte, materiais]
---
# Fonte - Pedra limpa e escura
Índice: Jogos - Gerais

## Conceito
- A pedra da fonte deve ser limpa, como a do chão, porém mais escura e sem as rachaduras do material PBR gerado. Para isso, as peças usam o Cobblestone padrão do Roblox, sem MaterialVariant, em cinzas azulados escuros.

## Receita
- Dentro da função `fonte`, `M.variant[Mat.Cobblestone] = nil` desliga a variante vila_paralelepipedo para essa construção.
- Cores: PA (66, 66, 70), PB (57, 57, 61), PL (80, 80, 86), PD (46, 46, 50); depois um passe de correção nas peças Cobblestone da fonte multiplica R por 0,88, G por 0,96 e B por 1,14 (esfria o tom e afasta o bege).
- Uso: ParedeBacia e pedestal em PA/PB alternados; capas, pilastras e colunas em PL; fundo e degrau em PD/PB.
- Sem musgo nem limo na superfície (o limo "Limo" da versão anterior foi removido).

## Resultado
- Sob a luz dos lampiões, a pedra da fonte lê como cinza-arroxeado frio e limpo; o chão ao redor, em cinza e azul com manchas verdes, fica mais claro.

## Exceções e limites
- Se o Cobblestone padrão parecer marrom demais em outra luz, aumentar o azul das cores (o material tem base bege-rosada).
- As bases das casas construídas antes dessa mudança ainda usam a variante vila_paralelepipedo (ver Roblox - Materiais PBR gerados no MaterialService).

## Relacionados
- Fonte - Estrutura em níveis
- Piso - Cores das pedras e ajuste de brilho
