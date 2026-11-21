---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, piso, pocas, correcao]
---
# Piso - Poças e círculos pretos removidos
Índice: Jogos - Gerais

## Conceito
- A função `detalhes` do módulo ainda cria uma pasta "Pocas" com 22 discos de vidro escuro (cor (12,18,28), material Glass, Reflectance 0,5, Transparency 0,15, espessura 0,05, altura y = 0,86). Sem a iluminação Future, esse vidro não reflete nada e aparece como círculos pretos achatados no chão, que "estragam o visual" durante a caminhada.

## Correção aplicada
- Destruir `Workspace.Vila.Detalhes.Pocas` depois de rodar `detalhes`:

```lua
local pocas = workspace.Vila.Detalhes:FindFirstChild("Pocas")
if pocas then pocas:Destroy() end
```

- Alargar as pedras em 16 a 18% para fechar as juntas em anéis, que também apareciam como círculos pretos concêntricos (o piso-base quase preto aparecia pelas fendas), e clarear o piso-base de (22,21,22) para (46,45,46).

## Regra para extensões
- Não usar discos escuros de vidro para simular poça. Se uma poça for necessária, ela precisa de um material que reflita mesmo sem Future (por exemplo, água de terreno rasa) ou de uma cor menos preta que o piso.
- Qualquer disco achatado escuro sobre o piso deve ser evitado; o mesmo vale para manchas de musgo em forma de círculo.

## Relacionados
- Piso - Pedregulhos, rochas e musgo
- Vila Medieval - Erros comuns e como evitar

## Revisão - discos pretos dos buracos dos NPCs
- Três discos achatados quase pretos (`CovaBuraco`: cilindro de 0,1 x 3,2 x 3,2, cor (12, 10, 8), `SmoothPlastic`) ficavam no chão da vila ao lado dos NPCs que cavam (`NPC_heitor`, `NPC_firmino` e `NPC_gB7`) e liam como sombras pretas com defeito, exatamente o caso proibido acima. Agora são terra revolvida, cor (44, 34, 24) e material `Ground`, perto da cor dos montes de terra ao lado (66, 52, 38); o `ConstrutorNPCs` foi atualizado para que reconstruir os NPCs não traga o preto de volta (ver NPCs da vila - Ferramentas de posicionamento e reconstrução).
- Outras manchas escuras do chão, como as bandas de sombra dura que as luzes com sombra (os 28 postes e 4 poços) lançam, não foram alteradas: dependem da iluminação Future escolhida para a vila.

## Revisão - frestas entre as lajotas
- A base clareada para (46, 45, 46), citada acima, foi clareada de novo (cinza quente (78, 74, 68) nas ruas, calçadas e anéis) e os vazios da grade de pedras ganharam lajotas de preenchimento, porque as faixas pretas que restavam entre as lajotas eram vãos da grade vistos em sombra. Detalhes em Piso - Frestas entre lajotas preenchidas.
