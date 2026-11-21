---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, grama, lua, reflexo]
---
# Grama - Reflexo da Lua
Índice: Jogos - Gerais

## Conceito
- A grama reflete a Lua como o mar: uma trilha prateada de lâminas brilhantes na direção da Lua, que cintila quando o vento mexe nas lâminas. Isso é calculado por lâmina, no cliente, sem luz real.

## Modelo
- Para cada lâmina: `u` = vetor de cima da lâmina (de repouso, somado à curvatura atual), `v` = direção da lâmina até a câmera, `moonDir` = direção da Lua.
- Vetor intermediário `H = normalize(moonDir + v)`.
- `spec = max(dot(u, H), 0)^10` (brilho especular).
- `lit = max(dot(u, moonDir), 0)` (parcela difusa leve).
- Fator de mistura `k = min(spec * (0,9 + 0,3 * sin(3t + fase)) + lit * 0,1, 1)`.
- Cor final: `baseColor:Lerp(SILVER, k)` com SILVER = (215, 232, 255).

## Por que forma uma trilha
- Quando a câmera olha para a Lua, as lâminas na linha entre a câmera e a Lua têm `v` quase oposto à direção horizontal da Lua; a soma `moonDir + v` fica quase vertical, `dot(u, H)` perto de 1 e `spec` alto.
- Lâminas fora dessa linha têm `H` inclinado e o brilho cai rapidamente (expoente 10).
- A oscilação senoidal e a curvatura causada pelo vento fazem a trilha cintilar.

## Parâmetros
- Expoente 10 (antes 16: trilha estreita demais), oscilação 0,9 ± 0,3, parcela difusa 0,10 (antes 0,22: deixava a grama inteira esverdeada).
- 260 lâminas atualizadas por frame, em rodízio (ciclo completo em cerca de 30 frames para 7.683 lâminas).

## Exceções e limites
- A grama é Neon e foi escurecida; o brilho prateado é a única coisa que faz a trilha aparecer no escuro.
- A direção `moonDir` é lida uma vez do Lighting no início; ela não acompanha mudanças de ClockTime em jogo.

## Revisão - Lua a oeste
- A Lua passou a ficar a oeste, a cerca de 39 graus de elevação (`GetMoonDirection` de aproximadamente (-0,78; 0,63; -0,06)), para aparecer a quem olha para cima no terraço da casa da cobertura. Como o script lê essa direção ao começar, a trilha prateada agora aponta para o oeste e fica visível a quem olha para lá. As fórmulas e os parâmetros acima não mudaram.
- Não foi conferido em imagem como a trilha aparece na praça com a Lua nessa posição mais alta: com a elevação maior, o ângulo entre a câmera e a Lua muda, e o expoente 10 pode estreitar ou afastar a mancha.

## Revisão - reflexo retirado
- O brilho prateado descrito acima deixou de existir. O script de vento foi reescrito e não calcula mais nenhuma mistura com a cor prateada; a relva nova (peças `Plastic`, sem trilha) não reflete a Lua (ver a nota da relva e a nota do código da versão 2, em Relacionados). Todas as seções acima descrevem a versão antiga.
- Motivo: em captura de Play, a trilha aparecia como pontas brancas isoladas contra o chão escuro, e não como uma faixa contínua; o efeito lia como ruído branco e não como reflexo.
- Se ainda restar um branco estranho junto à Lua, a outra fonte possível é a névoa de partículas que fica perto dela, que não foi alterada (ver a nota da névoa da Lua, em Relacionados).

## Relacionados
- Grama - Script GramaViva
- Lua - Textura no Sky
- Grama - Relva densa em dois segmentos
- Script GramaViva - Código completo da versão 2
- Neblina da Lua - Script NeblinaLua
