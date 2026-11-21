---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, lua, historico]
---
# Lua - Tentativas descartadas
Índice: Jogos - Gerais

## Conceito
- Antes da textura do Sky, a Lua foi feita como uma peça com SurfaceGui. Esta nota registra o que foi tentado e por que cada variante falhou.

## Tentativa 1 - peça distante com SurfaceGui
- Uma Part transparente (Size 460 a 1000 studs, 1 stud de espessura) a 1.000 a 2.400 studs do centro, com SurfaceGui na face Front e círculos de Frame (UICorner raio 1) para halo, disco, crateras e anéis.
- Em modo Edit renderizava; em Play não renderizava (distância demais) e, ainda por cima, não existia no cliente por causa de streaming.
- Um CanvasGroup para recortar a fase da Lua também não rendeu o esperado e foi trocado por Frame.

## Tentativa 2 - peça perto
- A 200 studs a Lua renderizava em Play; escolheu-se 300 e depois 70 studs com tamanho ajustado para o mesmo tamanho aparente.
- A neblina (FogEnd) fazia a peça sumir se ela ficasse além do alcance do fog; por isso a distância foi reduzida.
- Para impedir que o jogador chegasse perto, a peça foi movida a cada frame (BindToRenderStep) para a posição da câmera mais a direção da Lua vezes a distância.

## Problemas finais
- A peça era uma geometria real: aparecia na frente de casas mais distantes que ela (cerca de 100 a 200 studs), parecia "entrar" nas construções.
- O brilho da SurfaceGui (Brightness) estourava em branco e sofria bloom; o valor aceitável ficava entre 0,6 e 1,4.

## Solução adotada
- Textura do Sky (ver Lua - Textura no Sky). O script GramaViva teve removido o código que movia a peça.

## Exceções e limites
- Se algum dia a Lua precisar de animação (fases, nuvens passando), o caminho é trocar a textura por script, não voltar a uma peça.

## Relacionados
- Roblox Studio - Streaming e SurfaceGui à distância
- Vila Medieval - Evolução das versões
