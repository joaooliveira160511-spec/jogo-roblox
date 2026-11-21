---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, desempenho]
---
# Vila Medieval - Desempenho e contagem de peças
Índice: Jogos - Gerais

## Conceito
- A cena tem mais de 20 mil peças ancoradas. O desempenho depende de quantas existem no cliente ao mesmo tempo, de quantas projetam sombra e de quantas luzes têm sombra.

## Números
- Vila: 13.092 peças; grama: 7.683 lâminas; total cerca de 20.800.
- Cada casa tem cerca de 540 peças; cada poste, 18 peças; cada pedra, 1 peça; a fonte, 390 peças.
- 28 luzes de poste com `Shadows = true`; as demais luzes sem sombras.

## Medidas de contenção já aplicadas
- Quase todas as peças pequenas de detalhe têm `CanCollide = false`, `CanQuery = false` e muitas têm `CastShadow = false`.
- Telhas, vigas e molduras têm `CastShadow = true` para produzir sombras de relevo.
- Descarregamento por distância: Models além de 160 studs são removidos no cliente e células de grama idem (ver Carregamento por distância - Script NevoaDistante).
- Animação de grama restrita a 42 studs em torno da câmera, com atualização em lote por `BulkMoveTo`.
- Atualização de cor da grama em rodízio, 260 lâminas por frame.

## Onde cortar se for preciso
1. Pedregulhos (1.500 peças): reduzir para 600 ou menos.
2. Grama (7.683 lâminas): aumentar o passo de grade ou diminuir o anel.
3. Sombras de poste (28): desativar nos postes das ruas.
4. Telhas: aumentar o passo das fiadas de 1,15 para 1,5, reduzindo as peças do telhado em cerca de 25%.
5. Pedras do piso: manter só nas áreas jogáveis e usar o piso-base nas pontas das ruas.

## Depois da expansão pelas quatro direções
- Workspace.Vila passa a ter 55.676 partes e a grama 4.547 lâminas, num total de cerca de 60.200 (números detalhados na nota de estado final, listada em Relacionados).
- Cada casa nova tem entre 250 e 540 partes (as em ruína têm menos); os 77 Models de casas novas somam cerca de 32.000 partes. Cada poste novo tem 18 partes, cada poço cerca de 35.
- As luzes com sombra passam de 28 para 80 postes, mais os poços; o descarregamento por distância mantém ativos só os que estão a menos de 160 studs da câmera (ver Carregamento por distância - Pivôs dos Models novos).
- Onde cortar primeiro, se necessário: os 1.739 pedregulhos novos, as pedras da calçada (cerca de 7.200 pedras novas em todo o piso novo), as sombras dos postes novos e as lâminas de grama.
- A medição real de FPS continua sem ser feita.

## Depois da vila circular
- Workspace.Vila passa a ter 124.989 partes (a grama continua com 4.547 lâminas). Casas: 189 Models; cada casa da muralha ou do anel viário tem entre 250 e 540 partes.
- As 44 casas do círculo das praças saíram (cerca de 18.000 partes) e entraram 153 casas novas (69 do anel viário e 84 da muralha); as pedras novas somam 17.546 partes e os pedregulhos novos, 1.033.
- Postes: 136 Models; só os 28 originais têm luz com sombra, as outras 108 foram colocadas sem sombra.
- Em Play, de pé no centro, o cliente chegou a ter cerca de 24.700 partes de `Workspace.Vila` carregadas e, perto da curva nordeste, cerca de 21.000 (descarregamento por distância a 160 studs).
- A animação das luzes foi movida para o cliente e roda só nas luzes a menos de 170 studs, a cada 0,05 s (ver Luzes - Animação no cliente e falhas de carregamento).
- A medição de FPS em Play foi inconclusiva: o mesmo ponto deu 59 e 15 fps em duas medidas.

## Depois de remover a neblina e o descarregamento
- O cliente carrega as 124.989 partes de `Workspace.Vila` e a grama toda desde o início, em vez das cerca de 21.000 a 25.000 que ficavam carregadas perto da câmera. Se o desempenho cair, as opções são reativar o `NevoaDistante` e o fog, reduzir as pedras do passeio e das ruas laterais ou ligar o `StreamingEnabled`.
- O FPS com o mapa inteiro carregado ainda não foi medido de forma confiável.

## Exceções e limites
- Fumaça e partículas (chaminés, fonte, névoa) são o outro custo relevante; a fonte emite cerca de 1.000 partículas ao mesmo tempo.
- A medição real de FPS não foi feita; as estimativas acima vêm de contagens, não de perfil.

## Depois da segunda ampliação dos NPCs
- `Workspace.NPCs` passou de 125 modelos (4.702 partes, 3.713 decals) para 275 modelos (10.836 partes, 8.191 decals), fora as 124.989 partes de `Workspace.Vila`. O cliente anima só quem está a menos de 150 studs da câmera (ver NPCs da vila - Poses procedurais e comportamento no cliente). O FPS com o elenco completo não foi medido.

## Depois dos postes de reforço nas ruas
- 61 postes novos de 18 partes: `Workspace.Vila` passa de 124.989 para 126.087 partes, e `Lampioes` para 197 Models. As luzes de poste com sombra continuam sendo 28; as outras 169 não projetam sombra. `Workspace.NPCs` tem 275 modelos, 10.855 partes e 8.191 decals depois do novo posicionamento. O FPS não foi medido (ver Postes e lampiões - Reforço nas ruas escuras).

## Medição em Play no Studio
- Com o jogo completo, o cliente ficou entre 11 e 14 fps (quadro médio de 80 a 110 ms, com picos de 120 a 150 ms em cerca de 15% dos quadros). O servidor ficou ocioso: 0,7 ms de Heartbeat e 0,4 ms de física.
- **Teto de 15 fps**: com a cena esvaziada no cliente (sem NPCs, casas, pedras, grama e vagalumes, só piso e céu), o quadro continuou em 66,7 ms (15,0 fps), com os efeitos de pós-processamento ligados ou desligados. Como nada sobra para desenhar, esse valor é um limite do Studio nessa medição, e não custo do jogo; por isso desligar luzes, efeitos ou scripts isoladamente não baixou o quadro abaixo de 66 ms. Medidas de FPS tiradas com esse teto escondem quanto cada parte pesa.
- **Contagens no cliente**: 141.083 peças e 253.226 instâncias; 66.065 peças com `CastShadow = true`; 870 `PointLight` (533 de janela com alcance 13; 32 com sombra); 10.560 decals; 85 emissores ativos.
- **Peças que projetam sombra, por pasta**: `Vila.Pedras` 27.887 (100%), `Vila.Detalhes` 4.250 (100%), `Vila.Praca` 1.140 (100%), `Vila.Pracas` 292 (100%), `Vila.Casas` 27.233 (32%: telhas e vigas), `NPCs` 4.208 (41%), `Vila.Lampioes` 591. Cerca de metade dos projetores é piso e pedregulho.
- **Custo medido do `LuzesCliente`**: 3.021 itens com tag `Luz` (870 com `PointLight`, 2.732 com `Decal`); cada tick custa cerca de 13 ms de CPU (1,8 ms de leitura e ruído, 11,1 ms de escrita de `Brightness` e `Transparency`), e roda 20 vezes por segundo, ou seja, cerca de 26% de um núcleo. Como o raio de animação é de 450 studs, o tick atualiza a vila inteira, inclusive janelas fora de vista.
- Correção: o número acima (cerca de 13 ms por tick) veio de um micro-benchmark que forçava escrita de valores sempre diferentes e superestimou o custo. Medindo o `Heartbeat` com e sem o script, o custo real da versão original foi de cerca de 3,5 ms por quadro; a versão otimizada baixou para cerca de 1,6 ms (ver Luzes - Otimização do LuzesCliente).
- Outros custos de CPU no cliente são pequenos: Heartbeat médio de 4,5 ms e física de 2,0 ms por quadro; desligar `NPCsVila` ou `GramaViva` não mudou o quadro de forma mensurável.
- Descarregar 87.590 instâncias (tudo além de 200 studs) e apagar as 505 luzes ativas também não mudaram o quadro dentro do teto, de modo que reativar a neblina e o `NevoaDistante` não foi comprovado como ganho.

## Depois das fazendas dos quarteirões
- As quatro fazendas somam 11.978 partes, todas ancoradas (entre 2.863 e 3.150 por fazenda), em `Workspace.Vila.Fazendas`; os 20 NPCs das fazendas somam 752 partes, em `Workspace.NPCsFazendas`.
- Cada fazenda tem 8 `PointLight`, todas sem sombra: cinco de lampiões (quatro de estaca e a do poço) e três de luar; são 32 luzes novas, das quais 20 (as de lampião) levam a tag `Luz` e são animadas pelo `LuzesCliente`.
- Em `Workspace.Grama`, a retirada de 3.281 lâminas deixou 1.263, todas secas (de 4.544 na hora da retirada).
- Não há contagem por tipo de peça; as plantas das parcelas, pequenas e numerosas, são a candidata natural a corte se for preciso (suposição, não medida). O FPS com as fazendas não foi medido, e a medição anterior em Play já estava presa ao teto de 15 fps do Studio (ver a nota de verificação das fazendas, em Relacionados).

## Depois dos detalhes das fazendas
- A camada `Detalhes` soma 2.441 peças (615, 615, 620 e 591) e as estacas de lampião foram retiradas: as quatro fazendas passam de 11.978 para 14.275 peças (3.729, 3.579, 3.549 e 3.418).
- Luzes das fazendas: 9 `PointLight` por fazenda (36 no total), nenhuma com sombra, e 24 peças com tag `Luz` (eram 20). O FPS com a camada não foi medido; a medição anterior já estava presa ao teto de 15 fps do Studio.

## Depois da relva nova
- `Workspace.Grama.Relva` tem 17.075 peças (3.035 tufos e 12.084 lâminas), todas ancoradas, sem colisão, sem consulta e sem sombra; 1.263 lâminas antigas saíram de `Workspace.Grama` para `ServerStorage.GramaAntiga`. O saldo em `Workspace` é de +15.812 peças.
- Custo do script de vento em Play no Studio: de 2,4 a 2,8 ms por quadro, com 290 a 815 peças movidas por quadro e a escala do raio entre 0,5 e 0,65. A chamada `BulkMoveTo` responde por cerca de 80% disso. Uma primeira versão da reescrita custava cerca de 10 ms por quadro; caiu com compilação nativa, vento calculado por célula e não por lâmina, taxa de atualização por distância e a escala adaptativa.
- A medição acima de que desligar o `GramaViva` não mudava o quadro vale para a versão antiga e para o teto de 15 quadros por segundo do Studio. O FPS com a relva nova não foi medido num cliente real; em celular fraco, reduzir o raio de vento ou usar um passo de tufos maior são os cortes naturais (ver a nota da relva, em Relacionados).

## Relacionados
- Fazendas dos quarteirões - Verificação e limites
- Vila Medieval - Estado final e números de verificação
- Grama - Relva densa em dois segmentos
- Neblina - Parâmetros e comportamento
- NPCs da vila - Visão geral e elenco
- Postes e lampiões - Reforço nas ruas escuras
- Luzes - Animação no cliente e falhas de carregamento
- Luzes - Otimização do LuzesCliente
- Fazendas dos quarteirões - Detalhes e postes da vila
