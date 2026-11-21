---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, casas, telhado]
---
# Casa - Telhado em fiadas de telhas
Índice: Jogos - Gerais

## Conceito
- O telhado de cada casa é de duas águas, íngreme, feito de fiadas de telhas individuais, cada fiada um pouco mais alta ou mais baixa que a vizinha para criar sombras entre elas. A cumeeira corre ao longo do eixo X local do telhado; com `gableFront`, o telhado é girado 90 graus para que a empena fique de frente.

## Geometria
- Base do telhado em y = yTop (topo do último andar), centrado em z = -jet/2, orientado por `roofCF = cf * CFrame.new(0, yTop, -jet/2) * rot`.
- RL (comprimento da cumeeira) e SP (vão): sem gableFront RL = ww e SP = dd; com gableFront RL = dd e SP = ww.
- Altura do telhado `rise = SP * 0,56`; meia largura `half = SP/2`; ângulo `a = atan2(rise, half)`.
- Comprimento da água `len = sqrt(half² + rise²) + 1,8` (1,8 é o beiral); largura do telhado `RW = RL + 3,6`.
- Para cada lado (s = -1 e 1): direção de queda `dirDown = (0, -sin a, s*cos a)` e normal `n = (0, cos a, s*sin a)`; os quadros de cada peça são criados com `CFrame.fromMatrix(posição, Vector3.xAxis, n)`.

## Camadas
1. **Subtelhado**: placa de RW x 0,6 x len em madeira escura, sólida.
2. **Telhas**: fiadas de 1,5 studs de profundidade com passo 1,15, ou seja, sobrepostas; a posição normal alterna entre 0,25 e 0,45 de deslocamento (fiada par e ímpar), gerando as sombras entre fiadas. Cada fiada é cortada em segmentos de 4,5 a 8,5 studs, cada um com espessura 0,42 e cor própria.
3. **Cores das telhas** (`slateColor`): v de 38 a 66 em (v, v+2, v+9); 10% esverdeadas (46,62,50), 6% avermelhadas (78,52,44).
4. **Cumeeira**: bloco de RW+0,2 x 1,0 x 1,9 em (34,36,42) mais remates a cada 2,4 studs de 1,7 x 1,5 x 2,2 em (30,32,38).
5. **Beiral e caibros**: viga de beiral de RW x 0,9 x 0,5 e caibros de 0,5 x 0,6 sob o beiral a cada 2,8 studs.
6. **Tabeiras** nas empenas: vigas de 0,7 x 1,2 acompanhando o caimento, em madeira escura.

## Material
- Slate com a variante PBR vila_telhas, que dá relevo de telhas e sombras (ver Roblox - Materiais PBR gerados no MaterialService).
- A quantidade de telhas por telhado fica em torno de 120 a 200 partes.

## Exceções e limites
- O telhado é íngreme demais para o jogador andar; as telhas não têm colisão (só o subtelhado).
- Ao mudar SP, `rise` muda junto; as chaminés e as trapeiras usam `rise` e `Ls` para se posicionar.

## Relacionados
- Casa - Empenas, trapeiras e chaminés
- Módulo ConstrutorVilaGrande - Código parte 2 casa
