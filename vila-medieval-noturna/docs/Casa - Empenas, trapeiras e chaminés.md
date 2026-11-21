---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, empenas]
---
# Casa - Empenas, trapeiras e chaminés
Índice: Jogos - Gerais

## Conceito
- Os remates do telhado dão personalidade a cada casa: triângulos de parede nas extremidades (empenas), janelas no telhado (trapeiras) e chaminés de pedra com fumaça.

## Empenas
- Cada empena é feita de dois WedgeParts, um para cada metade do triângulo (espessura 0,8, altura `rise`, comprimento `half`), com cor da parede e material SmoothPlastic.
- Orientação do WedgePart: o lado vertical fica em +Z local e a altura cai para -Z. Para a metade -Z usa-se rotação nula; para a metade +Z, rotação de pi em Y.
- Moldura: poste central (0,8 x rise x 0,9), viga de base (0,8 x 0,9 x SP) e vigas diagonais paralelas ao caimento do telhado, 1,5 studs abaixo dele.
- Com `gableFront`, uma janela escala 0,9 abre na empena de frente, a 34% da altura.

## Trapeiras
- Criadas só quando a empena não está de frente e RL > 28; duas por casa, em ±0,22*RL, a 52% do comprimento da água na água da frente.
- Cada trapeira: corpo de 5,6 x 5,8 x 4,8 (parede), teto de 6,6 x 0,6 x 6,0 em ardósia, viga frontal e uma janela com venezianas (não acesa pela luz extra).

## Chaminés
- Pedra escura (66,64,62), bloco de 3,6 x (rise+7,5) x 3,6 posicionado em x = -(RL/2 - 2,6), com duas faixas claras, topo de 4,6 x 0,7 x 4,6 e dois canos cilíndricos.
- Em casas não apagadas, um ParticleEmitter "Fumaca" no topo: taxa 4, vida 7 a 11, velocidade 3 a 4, tamanho de 1,6 a 7, transparência 0,8 a 1, aceleração (1,4; 0,8; 0,5), cor (112,114,126).

## Exceções e limites
- A fumaça só sai de casas com Estado diferente de "apagada" no momento da construção; mudar o estado depois não remove nem cria o emissor.

## Relacionados
- Casa - Telhado em fiadas de telhas
- Módulo ConstrutorVilaGrande - Código parte 2 casa
