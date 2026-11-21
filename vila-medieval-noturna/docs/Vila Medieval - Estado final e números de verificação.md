---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, verificacao]
---
# Vila Medieval - Estado final e números de verificação
Índice: [[Jogos - Gerais]]

## Conceito
- Esta nota reúne os valores medidos no lugar ao final da construção. Servem para conferir se uma reconstrução ou uma continuação preserva exatamente o modelo.

## Contagens de peças (BaseParts)
- Workspace.Vila: 13.092 partes no total.
  - Praca: 236 partes (discos, meio-fio, 13 segmentos de rua por direção com dois meios-fios cada).
  - Pedras: 3.528 partes em 104 Models.
  - Casas: 6.466 partes em 12 Models.
  - Lampioes: 504 partes em 28 Models.
  - Mobiliario: 90 partes em 30 Models (barris e caixas; os bancos foram removidos).
  - Aderecos: 308 partes em 188 filhos.
  - Detalhes: 1.570 partes em 2 Models (Pedregulhos com 1.500 e Rochas com 70).
  - Fonte: 390 partes em um Model com 391 filhos (inclui o Script FonteFalha).
- Workspace.Grama: 7.683 lâminas, em duas pastas (Trecho1 com 3.929 e Trecho2 com 3.754).

## Scripts presentes
- StarterPlayerScripts: GramaViva, NevoaDistante, NeblinaLua.
- ServerScriptService: LuzesDaVila, NascerNaPraca.
- ServerStorage: ConstrutorVilaGrande (módulo principal), ConstrutorVila (módulo antigo, não usado), ConstrutorVilaGrande_run (cópia temporária para furar o cache de require) e Baseplate (a Baseplate original, guardada).
- MaterialService: pasta AssistantMaterials e quatro MaterialVariant (vila_telhas, vila_paralelepipedo, vila_madeira, vila_reboco).

## Valores de ambiente
- Lighting.ClockTime = 3,4 e GeographicLatitude = 20 (antes, 19,8 e 0; mudados para a Lua aparecer no terraço, como descrito na nota da Lua, citada na linha do Sky); Brightness = 0; Ambient e OutdoorAmbient = (0, 0, 0); ExposureCompensation = 0,35 (ver [[Iluminação - Configuração final da noite]]).
- Neblina: FogStart 12, FogEnd 135, FogColor (8, 9, 13) (ver [[Neblina - Parâmetros e comportamento]]).
- Sky: StarCount 4000, MoonTextureId rbxassetid://128342251593093, MoonAngularSize 18, SunAngularSize 0 (ver [[Lua - Textura no Sky]]).
- Terrain: material Ground cor (44, 60, 50), camada superior com ocupação 0,45 (ver [[Terreno - Material Ground e altura real da superfície]]).
- Spawn: SpawnLocation em (0, 1, 46), tamanho 6x1x6, transparente; o personagem é recolocado em (0, 5, 44) pelo script NascerNaPraca.

## Verificações rápidas em Play
- O personagem nasce em torno de (0, 3,7, 44), olhando para -Z.
- Não deve haver erros no console.
- A fonte alterna entre jato ligado e desligado em ciclos de dezenas de segundos.
- Cerca de 111 luzes ligadas, 72 piscando e 103 apagadas entre os itens marcados com a tag Luz (ver [[Luzes - Sistema de estados]]).

## Números depois da expansão pelas quatro direções
- Workspace.Vila: 55.676 partes. Praca: 400 partes (inclui as ruas longas, os meios-fios novos e as lajes de calçada); Pracas: 160 partes em 4 Models; Pedras: 10.732 partes em 616 Models; Casas: 38.424 partes em 89 Models; Lampioes: 1.440 partes em 80 Models; Mobiliario: 513 partes em 85 Models; Aderecos: 308 partes; Detalhes: 3.309 partes (1.500 pedregulhos antigos, 70 rochas e 1.739 pedregulhos novos); Fonte: 390 partes.
- Workspace.Grama: 4.547 lâminas (7.683 menos as removidas sob as construções novas).
- Cerca de 177 grupos de luz marcados com a tag Luz em Play; postes: 43 ligados, 18 piscando e 19 apagados.
- Pedregulhos a mais de 0,15 stud acima da laje: 0 (ver [[Piso - Pedregulhos flutuando e reassentamento]]).
- Em Play, de pé em x = 266 (praça circular do Leste), o cliente tem cerca de 16 casas, 13 postes, 120 Models de pedra e 12 de mobiliário carregados (ver [[Carregamento por distância - Pivôs dos Models novos]]).
- Casas novas: 77, com 25 intactas, 18 gastas, 19 decadentes e 15 em ruína total (ver [[Vila Medieval - Expansão pelas quatro direções]]).

## Números depois da vila circular
- Workspace.Vila: 124.989 partes. Casas: 189 Models (12 originais, 24 antigas das ruas cardeais, 69 do anel viário e 84 da muralha); Lampioes: 136 Models (80 mais 32 do anel e 24 da muralha); Pedras: 1.129 Models; Mobiliario: 321 Models.
- Workspace.Grama: 4.547 lâminas, nenhuma a mais de 149 do centro.
- Casas removidas: as 44 do círculo das praças pequenas e 9 das ruas cardeais que invadiam o corredor das ruas laterais (ver [[Cruzamentos - Limpeza de casas, pedras e meios-fios]]).
- Pedras novas (ruas laterais e passeio da muralha): 17.546, todas com topo entre 0,55 e 1,1; pedregulhos novos nas ruas laterais: 1.033.
- Entre as 177 casas com fundação não há sobreposição de caixas. A peça mais distante do centro está a 374,8 (`CasaMuro74`).
- Casas da muralha: 32 intactas, 18 gastas, 26 decadentes e 8 em ruína total; casas do anel viário: 36, 19, 12 e 2.
- Luzes: grupos de casa com 14 ligados, 30 piscando e 133 apagados; 108 luzes de poste sem sombra e 28 com sombra (ver [[Luzes - Animação no cliente e falhas de carregamento]]).
- StarterPlayerScripts passa a ter também o `LuzesCliente`.
- A taxa de quadros medida em Play no centro variou de 59 a 15 fps no mesmo ponto; a medição foi inconclusiva.

## Valores depois de remover a neblina
- Lighting: FogStart = 100000 e FogEnd = 100000. Workspace.StreamingEnabled = false. `NevoaDistante.Enabled = false`. `GramaViva`: LOAD_DIST 1000 e UNLOAD_DIST 1100. `LuzesCliente`: DIST 450.
- Em Play, o cliente tem todas as 124.989 partes de `Workspace.Vila`, 189 casas, 136 postes e 1.129 Models de pedra carregados desde o início, sem erros no console.

## Números depois da casa da varanda (casa depois substituída)
- `CasaNorteVaranda`: 390 partes, 47 com colisão; a pasta `Casas` continua com 189 Models (a `CasaNorteA1` saiu para `ServerStorage.CasasSubstituidas`).
- Removidas sob a nova construção: 5 pedras de calçada, 3 pedregulhos e 3 lâminas de grama (restam 4.544 lâminas). Um NPC foi deslocado 3 studs.
- Medição em Play: 9 peças com tag `Luz` na casa, todas `ligada`, 2 PointLights ativas e nenhum erro no console; sem colisão entre as peças sólidas da casa nova e as demais casas (ver [[Casa da varanda - Cottage com varanda na rua Norte]] e [[Cadeira de balanço - Modelo e script CadeiraBalanco]]).
- Scripts: `StarterPlayerScripts` passa a ter também o `CadeiraBalanco`; `ServerStorage` tem o módulo `ConstrutorCasaVaranda` e a pasta `CasasSubstituidas`.

## Números depois da casa da cobertura
- `CasaNorteCobertura` substitui a `CasaNorteVaranda` (removida, com 402 descendentes): 977 partes, 178 com colisão, 26 peças com tag `Luz` (todas `ligada`) e 11 PointLights ativas; a pasta `Casas` continua com 189 Models (ver [[Casa da cobertura - Casa com interior e terraço na rua Norte]]).
- A limpeza do lote não removeu pedras, pedregulhos nem lâminas de grama, porque a casa anterior já tinha limpado a área; a grama fica em 4.544 lâminas.
- A cerca da rua Norte (z = 15,2) foi encurtada de x 88 a 104 para 88 a 96, com o trecho original guardado em `ServerStorage.CasasSubstituidas.CercaNorteFrenteOriginal`.
- Medição em Play: o personagem sobe a escada de pedra (térreo a 1,6 para o 1º andar a 9,5) e a de madeira (9,5 para 18,0) sem pular, atravessa a porta do terraço e chega à cadeira; o balanço oscila até cerca de 0,057 rad; nenhum erro no console (ver [[Casa da cobertura - Escadas internas e níveis]]).
- Scripts: `ServerStorage` passa a ter também o módulo `ConstrutorCasaCobertura`, e o `ConstrutorCasaVaranda` fica como arquivo (ver [[Módulo ConstrutorCasaCobertura - Código completo]]).

## Números depois da fachada reformulada e do interior separado
- `CasaNorteCobertura` passou a ser só a fachada: 920 partes (160 com colisão), 959 descendentes, 2 peças com tag `Luz` (as lanternas de fora, `ligada`), 4 PointLights (duas de janela, permanentemente desligadas) e 25 janelas com a tag `JanelaCasa`; a pasta `Casas` continua com 189 Models (ver [[Casa da cobertura - Fachada reformulada e telhado alto]]).
- O interior fica em `ReplicatedStorage.InteriorCasaCobertura`, com 2991 partes (437 com colisão), 25 lampiões, 5 lareiras, 7 lustres e 2 portas com folhas; só existe na cena enquanto o jogador está dentro (ver [[Casa da cobertura - Interior em espaço separado e planta dos cômodos]]).
- Scripts novos: no `ServerStorage`, os módulos `CasaBase`, `CasaInterativos`, `CasaMoveis`, `ConstrutorCasaFachada` e `ConstrutorInteriorCasa`; no `StarterPlayerScripts`, o LocalScript `CasaCobertura` (ver [[Script CasaCobertura - Código completo]]). O `CadeiraBalanco` passou a guardar a pose no atributo `BaseCF` (detalhes na nota da cadeira de balanço, citada acima).
- `NPC_teodoro` foi movido para (16; 4,03; -92) (ver [[Prompts de interação - Tecla F da casa e tecla E dos NPCs]]).

## Números depois da segunda versão do interior
- O interior em `ReplicatedStorage.InteriorCasaCobertura` passou a ter 5189 descendentes e 4946 partes, 403 com colisão (136 delas caixas invisíveis de colisão dos móveis), 12 lampiões, 3 lareiras, 1 lustre, 2 portas com folhas, 1 elevador com portão e 16 PointLights; planta de 96 x 64 e pé-direito de 16 (ver [[Casa da cobertura - Interior ampliado de 96 x 64 e pé-direito de 16]]).
- Medição em Play: entrada com 7,0 a 7,3 s de tela preta e saída com 8,8 a 9,4 s, até a volta de 4544 lâminas de grama e 3005 peças `Luz`; sem erros nem avisos do jogo no console; renascer dentro da casa devolve o mundo (ver [[Casa da cobertura - Tela preta até o mundo carregar]]).
- Elevador testado subindo e descendo entre y = 3 e y = 20 (ver [[Casa da cobertura - Elevador de gaiola aberta]]).
- Scripts: `ServerStorage` passa a ter também o módulo `CasaElevador`; `CasaMoveis`, `CasaInterativos`, `ConstrutorInteriorCasa` e o LocalScript `CasaCobertura` foram substituídos pela versão 2, e as versões 1 ficam arquivadas em `ServerStorage.CasaV1` (ver [[Módulo CasaElevador - Código completo]]).

## Números depois da versão humilde do interior
- O interior em `ReplicatedStorage.InteriorCasaCobertura` passou a ter 4708 descendentes e 4465 partes, 403 com colisão (136 caixas invisíveis: 130 `Colisao` e 6 de cesto e ferramentas das lareiras), 12 lampiões, 3 lareiras, 1 lustre, 2 portas com folhas, 1 elevador com portão e 16 PointLights; a planta de 96 x 64 não mudou (ver [[Casa da cobertura - Acabamento humilde e paleta de madeira]]).
- Medição em Play: passagem de entrada completa em 7,43 s de tela preta e saída em 7,87 s, até a volta de 4544 de 4544 lâminas de grama e 3005 de 3005 peças `Luz`; sem erros do jogo no console. A cabine do elevador, de madeira, subiu de y = 1500,12 a 1517,12 em cerca de 3,6 s, levando o personagem.
- O lustre do grande salão virou uma roda de carroça (ver [[Casa da cobertura - Lustre de roda de carroça]]).
- Scripts: no `ServerStorage`, os módulos `CasaMoveis`, `CasaInterativos`, `CasaElevador` e `ConstrutorInteriorCasa` foram substituídos pela versão 3, e as versões 2 ficam arquivadas na pasta `ServerStorage.CasaV2`; `CasaBase` e o LocalScript `CasaCobertura` não mudaram.

## Números depois dos ajustes finais do interior
- O interior em `ReplicatedStorage.InteriorCasaCobertura` passou a ter 4520 descendentes e 4279 partes, 401 com colisão (134 caixas invisíveis: 128 `Colisao` e 6 de cesto e ferramentas das lareiras), sem armaduras no hall, com a cabine do elevador em z = 7,0 do interior; o resto (12 lampiões, 3 lareiras, 1 lustre, 2 portas e 16 PointLights) não mudou.
- Medição em Play: entrada com passagem completa de 7,25 s e saída de 9,70 s, com 4544 de 4544 lâminas de grama e 3005 de 3005 peças `Luz` de volta; a tela fica preta na hora, sem a porta abrir e sem o personagem caminhar, e ele já surge dentro ou fora da casa (ver [[Casa da cobertura - Passagem direta com tela preta imediata]]). Sem erros do jogo no console.
- Scripts: `ConstrutorInteriorCasa` e o LocalScript `CasaCobertura` passaram à versão 3.1; as demais versões ficam nas notas de código.

## Números depois da barreira do terraço e dos móveis retirados
- O interior em `ReplicatedStorage.InteriorCasaCobertura` passou a ter 4336 descendentes e 4107 partes, 389 com colisão (122 caixas invisíveis: 116 `Colisao` e 6 de cesto e ferramentas das lareiras), sem as quatro mesas baixas e as oito poltronas dos quatro cômodos comuns; o resto (12 lampiões, 3 lareiras, 1 lustre, 2 portas e 16 PointLights) não mudou.
- A fachada `CasaNorteCobertura` passou a ter 924 partes, 164 com colisão e 964 descendentes, com o Model `BarreiraTerraco` (4 partes invisíveis com colisão) fechando o terraço (ver [[Casa da cobertura - Barreira invisível do terraço]]).
- Medição em Play: a tela fica preta 18 ms depois do aviso da porta, também na primeira passagem; entrada em 6,81 s, saída para o terraço em 7,58 s (grama 4544 de 4544 e luzes 3005 de 3005) e entrada pelo terraço em 6,77 s, sem erros do jogo no console (ver [[Casa da cobertura - Primeira passagem sem travada]]).
- Scripts: `ConstrutorInteriorCasa` e o LocalScript `CasaCobertura` passaram à versão 3.2 e `ConstrutorCasaFachada`, à 2.1.

## Números depois do terraço ampliado e do preenchimento da fachada
- A fachada `CasaNorteCobertura` passou a ter 950 partes, 168 com colisão e 991 descendentes (eram 924, 164 e 964), com o terraço 3,2 maior (ver [[Casa da cobertura - Terraço ampliado e escoras]]) e o Model `Preenchimento`, de 3 blocos opacos com colisão (ver [[Casa da cobertura - Preenchimento da fachada e câmera de chegada]]). O Model `BarreiraTerraco` continua com 4 partes invisíveis, agora mais longas.
- Scripts: `ConstrutorCasaFachada` passou à versão 2.2 (20025 bytes) e o LocalScript `CasaCobertura`, à 3.3 (32800 bytes); `ConstrutorInteriorCasa` continua na 3.2. O interior não mudou: 4336 descendentes.
- Medição em Play: entrada pela porta da rua com passagem completa em 6,96 s e sem erros no console; barreira do terraço testada em cinco direções sem que o personagem saísse dele. O limite de zoom da câmera de chegada foi observado em Play nas duas portas: na saída pela porta da rua a câmera ficou 1,45 antes da face da folha (zoom de 4,13) e, na saída pelo terraço, 0,65 antes (zoom de 3,30), sem nenhuma amostra dentro dos blocos de preenchimento; o zoom máximo voltou ao normal depois de meio segundo.

## Relacionados
- [[Vila Medieval - Visão geral]]
- [[Vila circular - Muralha de casas voltadas para o centro]]
- [[Vila Medieval - Ordem de reconstrução passo a passo]]
- [[Roblox Studio - Teste em Play e capturas de tela]]
