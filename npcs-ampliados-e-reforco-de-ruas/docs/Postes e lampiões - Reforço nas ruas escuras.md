---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, postes, iluminacao, ruas]
---
# Postes e lampiões - Reforço nas ruas escuras
Índice: [[Jogos - Gerais]]

## Conceito
- As avenidas e os anéis tinham longos trechos escuros: parte dos postes originais está `piscando` e parte `apagada` por escolha de ambientação, e só os postes `ligada` iluminam de forma constante (ver [[Luzes - Sistema de estados]]). Em vez de religar postes apagados, o reforço acrescenta postes novos, sempre `ligada`, onde a iluminação da rua fica abaixo de uma meta.
- A ferramenta é o módulo `IluminarRuas`, em `ServerStorage` (ver [[NPCs da vila - Ferramentas de posicionamento e reconstrução]]).

## Medida
- A mesma conta da iluminação no chão (ver [[NPCs da vila - Regra de iluminação e escolha das posições]]): soma de brilho * (1 - distância / alcance), com a distância em 3D a partir de um ponto 1,5 studs acima do chão, para luzes de alcance 16 ou mais.
- Peso por estado: `ligada` vale 1, `piscando` vale 0,6 (a luz falha parte do tempo) e `apagada` vale 0.
- Meta: iluminação efetiva de 0,9 em cada amostra de rua.
- Amostras: oito ruas (as quatro avenidas, de 60 a 245 do centro, e os quatro lados do anel, de -214 a 214), com passo de 8 studs ao longo da rua e cinco deslocamentos em relação ao eixo (-18, -9, 0, 9 e 18, que cobrem as duas calçadas e a pista). Total de 1.560 amostras, das quais 1.189 estavam abaixo da meta.

## Escolha dos postes
1. Candidatos a cada 4 studs ao longo de cada rua, dos dois lados, a 11 studs do eixo (a mesma distância dos postes das avenidas originais): cerca de 1.240 posições nominais.
2. Uma posição só vale se o chão sob ela é de `Pedras` ou `Praca` (calçada ou meio-fio), se nenhuma peça fora do piso toca a caixa de 3,6 por 7 por 3,6 studs e se não há outro poste a menos de 16 studs. Restaram 701.
3. Escolha gulosa: a cada passo vence o candidato de maior ganho, isto é, a soma, sobre as amostras ainda abaixo da meta, do menor valor entre o déficit e a luz que o poste daria. Depois se descartam os candidatos a menos de 16 studs do escolhido. O laço para quando o maior ganho fica abaixo de 0,12 ou chega a 170 postes.
4. Resultado: 61 postes (anel leste 12, anel norte 11, anel oeste 10, anel sul 11; avenidas leste 5, norte 3, oeste 4 e sul 5). As amostras abaixo da meta caíram de 1.189 para 9.

## Como cada poste é criado
- Clone do poste original `Poste3` (que está `ligada`), com nome `PosteRua1` a `PosteRua61` e o atributo `PosteRua = true` no Model. A chama (`Chama`) recebe `Grupo = posteRua<n>` e `Estado = ligada`; a tag `Luz` vem junto no clone, de modo que o `LuzesDaVila` e o `LuzesCliente` tratam o poste como os demais.
- Orientação: o braço do lampião aponta para o eixo da rua. O giro vem de um `CFrame.lookAt` entre a direção do braço no molde e a direção desejada, aplicado em torno da base.
- Altura: um raio vertical acha o piso, e a base fica na mesma altura relativa ao piso que no molde.
- Luz: brilho 1,25 e alcance 44, como nos originais, e `Shadows = false`. Só os 28 postes originais projetam sombra, por desempenho (ver [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]); o clone de um original herdou `Shadows = true` e foi corrigido.
- Cada poste tem 18 partes: `Workspace.Vila` passou de 124.989 para 126.087 partes. As peças com tag `Luz` fora dos NPCs passaram de 2.926 para 2.987.
- Rodar a ferramenta com `gravar = true` apaga os `PosteRua*` anteriores antes de recriar.

## Exceções e limites
- Os postes originais `piscando` e `apagada` continuam como estavam: a ambientação de vila em declínio depende deles.
- O peso 0,6 do estado `piscando` é uma escolha, não uma medida.
- A 11 studs do eixo, a base de 2,4 studs encosta no meio-fio (em 10,5); nos anéis os postes originais ficam a 12,2 (ver [[Ruas laterais - Anel viário entre as ruas cardeais]]).
- As praças circulares não receberam postes novos: já têm doze cada.
- Em Play, o anel leste, a avenida leste e o anel norte aparecem com piso e fachadas claros e NPCs visíveis nas duas calçadas. As 9 amostras que restaram abaixo da meta ficam nas pontas dos anéis. O FPS não foi medido (ver [[Vila Medieval - Desempenho e contagem de peças]]).

## Relacionados
- [[Postes e lampiões - Geometria e luz]]
- [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]
- [[Ruas - Quatro caminhos cardeais]]
- [[Ruas laterais - Anel viário entre as ruas cardeais]]
- [[Luzes - Sistema de estados]]
- [[NPCs da vila - Regra de iluminação e escolha das posições]]
- [[NPCs da vila - Cotas por zona e espalhamento pelas ruas]]
- [[Postes e lampiões - Lampiões de luz fraca]]
