---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, lua, sky]
---
# Lua - Textura no Sky
Índice: Jogos - Gerais

## Conceito
- A Lua é a textura da Lua do próprio Sky (`Sky.MoonTextureId`). Como o Sky é desenhado sempre atrás de toda a geometria e não depende de distância, a Lua é sólida, não cresce ao andar, nunca é alcançada e nunca aparece na frente de construções.
- A neblina (FogStart/FogEnd) não afeta o Sky, então a Lua permanece nítida, com no máximo uma névoa fina na frente dela (ver Neblina da Lua - Script NeblinaLua).

## Configuração
- Textura: rbxassetid://128342251593093, uma imagem de 512x512 com disco lunar desenhado (não realista), contorno claro, crateras com borda e halo azulado suave (código em Imagem da Lua - Código gerador em Python).
- `Sky.MoonAngularSize = 18` (grande); `Sky.SunAngularSize = 0`.
- Posição: definida por `Lighting.ClockTime = 19,8` e `GeographicLatitude = 0`. A direção da Lua é `Lighting:GetMoonDirection()` e vale aproximadamente (0,90, 0,46, -0,44): leste-nordeste e cerca de 25 graus de elevação. Como o personagem nasce voltado para o Norte (-Z), a Lua aparece à direita, a cerca de 64 graus do eixo de visão.

## Como ver em teste
- Em modo Edit, `screen_capture` com `camera_position = (0, 12, 46)` e `look_at_position = (90, 52, 4)` enquadra a Lua.
- Em Play, a câmera do jogo costuma ficar abaixo da elevação da Lua; a Lua só aparece ao olhar para cima.

## Exceções e limites
- A imagem precisa estar processada pelo Roblox; logo após o envio pode aparecer a mensagem "Asset content representation is being generated".
- O halo da textura é azulado; se a noite precisar ficar neutra, a cor do halo (175, 195, 255) deve ser alterada no gerador e a imagem reenviada.

## Revisão - Lua levada para o céu do terraço
- Pedido: a Lua deve aparecer a quem está no terraço da casa da cobertura, ao olhar para cima. O terraço fica voltado para o oeste (a casa tem a frente para -X; ver Casa da cobertura - Casa com interior e terraço na rua Norte), então a Lua precisa estar a oeste e alta o bastante para não ser coberta pelo telhado e pelas barreiras.
- Valores atuais: `GeographicLatitude = 20` e `ClockTime = 3,4` (antes, 0 e 19,8). `Lighting:GetMoonDirection()` vale cerca de (-0,78; 0,63; -0,06): azimute de 274,5 graus (0 é o norte, -Z; 90 é o leste, +X; 270 é o oeste, -X) e elevação de 38,9 graus. A seção "Configuração" acima descreve a posição anterior.
- Método: com `Brightness = 0` a hora só serve para posicionar a Lua, então bastou uma busca em grade de latitude e hora até achar azimute entre 255 e 285 graus e elevação entre 30 e 50 graus. Com latitude 0 a Lua nunca passa de cerca de 67 graus de azimute em torno do norte, por isso a latitude teve de sair de zero. As posições de azimute e elevação saem do vetor devolvido por `GetMoonDirection`: `azimute = atan2(x, -z)` e `elevação = asin(y)`.
- Linha de visão: de um ponto 1,5 acima do personagem no terraço, um raio na direção da Lua, ignorando as peças com transparência 1, sai livre para o céu; entre 10 e 80 graus de elevação, no mesmo azimute, nada bloqueia. A parede `BarreiraTerraco.ParedeFrente` é invisível (`Transparency` 1), embora um raio comum a atinja (ver Casa da cobertura - Barreira invisível do terraço).
- Conferido em captura, em modo Edit: de (25; 27; -106), olhando para (-60; 50; -106), a Lua aparece inteira, com as estrelas ao redor. Em Play o céu tem os mesmos valores (Sky, `CelestialBodiesShown`, direção da Lua), mas a captura em Play não serviu para ver a Lua: a imagem saiu com a câmera do jogo, e não com a posição pedida.
- Quem usa a direção da Lua e a lê uma vez ao começar passa a seguir a nova: a trilha prateada da grama (nota do reflexo, em Relacionados) e a névoa da Lua. A trilha vista do chão da praça, com a Lua a oeste, não foi conferida em imagem.
- Efeito colateral de mudar a hora: nenhum script do jogo lê `ClockTime` (a busca por esse nome não achou nada) e a luz direcional é nula (`Brightness = 0`), então a hora só posiciona a Lua; a nota da iluminação traz os valores antigos (ver Iluminação - Configuração final da noite).

## Revisão - a grama não reflete mais a Lua
- A trilha prateada da grama, citada na revisão do terraço, deixou de existir: a relva nova não reflete a Lua e não lê a direção dela. Só a névoa da Lua continua seguindo `GetMoonDirection`. O pedido de tirar o branco estranho que ficava junto à Lua foi atendido removendo a trilha; a névoa de partículas não foi alterada (ver a nota da relva, em Relacionados).

## Relacionados
- Lua - Tentativas descartadas
- Céu - Estrelas, atmosfera e pós-processamento
- Grama - Reflexo da Lua
- Grama - Relva densa em dois segmentos
