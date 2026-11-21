---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, piso, cores]
---
# Piso - Cores das pedras e ajuste de brilho
Índice: Jogos - Gerais

## Conceito
- A cor final do piso depende da cor da peça, do material, da cor das luzes e da exposição. Em noite com poucas fontes de luz laranja, pedras acinzentadas parecem beges; por isso as cores das pedras foram esfriadas e escurecidas por etapas.

## Etapas de calibração
1. Pedras com variante PBR vila_paralelepipedo: pareciam sujas e, de longe, chão liso e marrom.
2. Troca para Cobblestone padrão, cores (111,108,105), pedras claras demais sob os lampiões (aparência rosada).
3. Pedras com material Slate: ficaram lisas demais e bege, sem textura; descartado.
4. Cobblestone padrão com cores cinza-azuladas variadas (g de 66 a 118), 12% musgosas, 18% azuladas, que sob a luz laranja leem como mistura de cinza, azul e verde (aparência final).

## Valores finais
- Piso-base: (46, 45, 46) e (44, 44, 48) no anel interno de Slate.
- Pedras: ver Piso - Pedras individuais estilo cobblestone.
- Pedregulhos: (46 a 96, ...) ver Piso - Pedregulhos, rochas e musgo.
- Lampiões: Color (255, 184, 108), Brightness 1,25 (ver Postes e lampiões - Geometria e luz).

## Regras práticas
- Se o chão parecer "marrom liso" em Play, olhar de perto antes de concluir; em visão alta e com luz forte a variação desaparece.
- Se aparecer bege demais, esfriar as cores das pedras (mais azul, menos vermelho) ou reduzir a saturação da luz.
- Ambiente zero (breu) exige que cada pedra esteja ao alcance de alguma luz para ser vista.

## Relacionados
- Iluminação - Evolução e lições
- Piso - Poças e círculos pretos removidos
