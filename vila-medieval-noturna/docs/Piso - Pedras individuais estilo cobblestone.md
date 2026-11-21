---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, piso, cobblestone]
---
# Piso - Pedras individuais estilo cobblestone
Índice: Jogos - Gerais

## Conceito
- O piso é feito de lajes de pedra individuais, cada uma uma Part, assentadas sobre um piso-base quase preto. O efeito é o do cobblestone de Minecraft: blocos rudes de alturas e tons diferentes, com juntas escuras e sombras entre eles.
- Total: 3.528 pedras em 104 Models (pasta `Workspace.Vila.Pedras`).

## Geração
- **Anéis da praça**: para r de 33,8 a 57,2 em passos de 2,4, cada anel tem `n = floor(2*pi*r / 2,35)` pedras com deslocamento angular aleatório; cada pedra fica voltada para o centro (`CFrame.lookAt`) com uma rotação aleatória de ±0,1 rad.
- **Ruas**: em cada direção, x de 58,6 a 214 em passos de 2,4 e z de -9,4 a 9,45 em passos de 2,35, com jitter de ±0,15 em x, ±0,12 em z e rotação de ±0,12 rad.
- **Agrupamento**: as pedras de um anel são divididas em até 6 Models; as das ruas, em Models de 6 fileiras. Isso permite o descarregamento por distância (ver Carregamento por distância - Script NevoaDistante).

## Dimensões de cada pedra
- Tamanho inicial: tangencial 1,9 a 2,25 e radial 1,9 a 2,2 (ruas: 2,0 a 2,3 por 1,9 a 2,2). Depois da primeira revisão, os eixos X e Z foram multiplicados por 1,16 e 1,18 para fechar as juntas e eliminar anéis pretos contínuos entre as fileiras.
- Altura h de 0,55 a 0,95; o topo fica entre 0,65 e 0,95 (`top = 0,53 + rand(0,12; 0,42)`); a peça é centrada em y = top - h/2.
- Inclinação aleatória de ±0,05 rad em X e Z.

## Material e cor
- Material Cobblestone padrão, sem MaterialVariant (as rachaduras do material gerado deixavam o piso sujo e liso ao mesmo tempo). `CanCollide = true`, `CanQuery = true`, `CastShadow = true`.
- Cores finais: g aleatório entre 66 e 118; 12% musgosas (g-22, g-4, g-20), 18% azuladas frias (g-14, g-8, g+10), o resto em cinza de pedra (g-8, g-5, g+2).
- Base do piso: (46, 45, 46), para que as juntas leiam como juntas escuras e não como buracos pretos.

## Código
- Função `pedra2` e `M.pedras`: ver Módulo ConstrutorVilaGrande - Código parte 4 praça, pedras e detalhes.

## Exceções e limites
- As pedras só aparecem se o terreno estiver abaixo do piso (ver Terreno - Material Ground e altura real da superfície).
- Pedras com colisão e alturas variadas fazem o personagem subir e descer pequenos degraus; a variação máxima entre vizinhas é de cerca de 0,4 stud, que o Humanoid atravessa sem travar.
- Sob luz laranja forte, o cobblestone padrão parece bege-rosado; a cor das pedras foi esfriada para compensar (ver Piso - Cores das pedras e ajuste de brilho).

## Relacionados
- Piso - Pedregulhos, rochas e musgo
- Piso - Poças e círculos pretos removidos
- Praça - Geometria e raios
