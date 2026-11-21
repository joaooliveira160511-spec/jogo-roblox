---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, visao-geral]
---
# Vila Medieval - Visão geral
Índice: Jogos - Gerais

## Conceito
- A Vila Medieval Noturna é um cenário construído no Roblox Studio (lugar "Place1") por meio de scripts Luau executados em modo Edit; o resultado fica gravado no lugar como Parts, Models, scripts e configurações de Lighting e Terrain.
- A cena é uma praça circular de pedra, com uma fonte gigante no centro, quatro ruas nos pontos cardeais e doze casas de enxaimel em anel ao redor, tudo imerso em uma noite realmente escura, com neblina e uma Lua desenhada no céu.
- O jogador nasce dentro da praça, de frente para o Norte (direção -Z), que é a rua principal.
- A iluminação vem quase só de lampiões em postes altos, de velas nas janelas e da Lua; o que não recebe luz fica em breu.

## Componentes do mundo
- **Praça circular** de raio 58 studs, com anéis de piso e meio-fio (ver Praça - Geometria e raios).
- **Quatro ruas** cardeais de 20 studs de largura e cerca de 160 de comprimento (ver Ruas - Quatro caminhos cardeais).
- **Piso de 3.528 pedras individuais** em estilo cobblestone, com pedregulhos e rochas (ver Piso - Pedras individuais estilo cobblestone).
- **Fonte gigante** de três níveis, cerca de 65 studs de altura, com água de terreno e falhas periódicas (ver Fonte - Estrutura em níveis).
- **Doze casas** grandes, com base de pedra, paredes lisas de madeira, enxaimel, telhado em fiadas e janelas de vela (ver Casas - Posicionamento no anel da praça).
- **Vinte e oito postes** altos com lampiões pequenos e fortes (ver Postes e lampiões - Geometria e luz).
- **Adereços**: carroças, fenos, cercas e quatro barracas de feira (ver Adereços - Carroças, feno, cercas e barracas).
- **Grama animada** fora da vila, que se curva ao vento e quando o jogador passa (ver Grama - Script GramaViva).
- **Lua** como textura do Sky, sólida e distante (ver Lua - Textura no Sky).
- **Neblina** densa e escura, com descarregamento do que fica longe (ver Neblina - Parâmetros e comportamento).
- **Expansão pelas quatro direções**: as ruas continuam até 250 studs do centro, com 77 casas novas ao longo delas, mais variadas, apagadas ou em ruína, e uma praça circular de raio 46 no fim de cada rua, com um poço no centro e um anel de casas voltadas para dentro (ver Vila Medieval - Expansão pelas quatro direções).
- **Vila circular**: a vila inteira é um círculo de cerca de 375 studs de raio, fechado por uma muralha de 84 casas voltadas para o centro (ver Vila circular - Muralha de casas voltadas para o centro). Oito ruas laterais, saindo do meio das ruas cardeais e se ligando em curva, formam um anel viário quadrado (ver Ruas laterais - Anel viário entre as ruas cardeais). As praças pequenas do fim das ruas mantêm piso, poço e postes, mas sem as casas do círculo (ver Passeio da muralha - Lajes, pedras e postes). As luzes passaram a ser animadas no cliente (ver Luzes - Animação no cliente e falhas de carregamento).

- **Fazendas dos quarteirões**: nos quatro quarteirões diagonais mais próximos do centro, onde havia grama atrás das casas, há uma fazenda moribunda por quarteirão, com caminho de terra na diagonal, trigo morto, poço seco, água derramada, luz fraca e 20 NPCs (ver Fazendas dos quarteirões - Visão geral e geometria). Uma camada de detalhes acrescentou postes iguais aos da vila, braseiro, telheiro caído, ferramentas fincadas, crânios e corvos (ver Fazendas dos quarteirões - Detalhes e postes da vila).

## Como a cena foi produzida
- Um ModuleScript em ServerStorage chamado ConstrutorVilaGrande contém funções que criam cada elemento (casa, poste, fonte, praça, pedras, detalhes, adereços). Cada chamada é feita por `execute_luau` em modo Edit (ver Módulo ConstrutorVilaGrande - Visão geral e API).
- Scripts de execução em tempo de jogo cuidam do comportamento: luzes que piscam, nascimento, grama viva, neblina e carregamento por distância (ver Luzes - Script LuzesDaVila, Nascimento do jogador - Script NascerNaPraca).
- Imagens desenhadas em Python (Lua e vidro das janelas) foram enviadas ao Roblox e são usadas como textura de céu e como Decal (ver Roblox - Imagens geradas por Python e enviadas ao Roblox).

## Revisão - relva nova e personagem parado nas conversas
- A "grama animada" da lista de componentes é hoje a relva: 3.035 tufos e 17.075 peças, com lâminas de dois segmentos que balançam ao vento e se curvam a quem passa, sem reflexo da Lua (ver Grama - Relva densa em dois segmentos).
- Durante qualquer conversa com NPC o personagem fica parado, virado para o NPC, com vinheta, luz quente e campo de visão fechado (ver NPCs da vila - Personagem parado durante a conversa).

## Relacionados
- Vila Medieval - Estado final e números de verificação
- Vila Medieval - Ordem de reconstrução passo a passo
- Vila Medieval - Requisitos visuais do projeto
- Vila Medieval - Evolução das versões
- Roblox Studio via MCP - Ferramentas e fluxo de trabalho
