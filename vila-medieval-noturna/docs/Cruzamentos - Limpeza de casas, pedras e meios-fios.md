---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, ruas, cruzamentos, limpeza]
---
# Cruzamentos - Limpeza de casas, pedras e meios-fios
Índice: [[Jogos - Gerais]]

## Conceito
- Onde uma rua lateral encontra uma rua cardeal, o que já existia no caminho precisa sair antes de construir: casas, adereços, pedras de calçada, pedregulhos e pedaços de meio-fio. A função `limpaCruzamentos` faz isso nos oito cruzamentos (ver [[Ruas laterais - Anel viário entre as ruas cardeais]]).

## O que é removido
- **Casas da rua cardeal** cujo trecho ocupado (`x + w/2 + 1,0`) passa de 176, o início do corredor da rua lateral (`ANEL - 24`). Resultado: 9 casas (as quartas casas de cada margem e uma quinta no Sul). As que sobram terminam em x = 166,5 no máximo.
- **Adereços** (lenha, barris, caixas) a mais de 120 do centro, com x local de 165 a 232 e |z| < 50 na rua cardeal: 18 itens.
- **Pedras de calçada** (Models `Calc...`, exceto `CalcAnel`) dentro da pista da rua lateral, ou seja, no referencial da meia rua com x de 10,6 a 24,4 e |z| < 10,6: 391 pedras. As lajes `Calcada` abaixo ficam, pois têm a mesma altura e cor da pista nova.
- **Pedregulhos novos** na mesma janela (x de 10 a 25, |z| < 11): 92. Sem isso eles ficariam flutuando sobre as pedras removidas (ver [[Piso - Pedregulhos flutuando e reassentamento]]).
- **Meio-fio da rua cardeal** (`MeioFioRua` em x = 10,5 do referencial da meia rua, |z| < 17,6): cada peça que cai inteira dentro de |z| < 10,6 é apagada (8 peças); as que atravessam o limite são encurtadas e reposicionadas (16 peças), pela interseção do seu intervalo com a janela.

## O que fica
- Os postes originais em x = 184, z = -11 e os `PosteExt` em x = 220 ficam fora da pista e das novas pedras (a pista só começa em x = 10,2 do referencial da lateral e as calçadas laterais em 24,4).
- A pista da rua cardeal continua inteira pelo cruzamento.

## Relacionados
- [[Vila circular - Muralha de casas voltadas para o centro]]
- [[Ruas - Continuação e calçadas até as praças circulares]]
- [[Módulo ConstrutorVilaGrande - Código parte 10 vila circular]]
