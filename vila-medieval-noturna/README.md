# Vila Medieval Noturna (Roblox Studio)

Cenário noturno de uma vila medieval construído no Roblox Studio: uma praça circular com uma fonte gigante que falha de tempos em tempos, casas de enxaimel com janelas de vela, postes com lampiões, neblina, grama que se curva ao passar e uma Lua desenhada no céu. O jogador nasce na praça, de frente para a rua Norte.

Esta pasta reúne o que foi feito no chat: os scripts, o módulo que constrói a vila, os geradores das imagens e a documentação em `docs/`.

## Estado desta versão

- **Reconstituída do chat, não exportada do Studio.** No momento da exportação o Studio não estava conectado. Os scripts de luzes e a grama foram escritos a partir do que foi aplicado no chat. **O módulo `ConstrutorVilaGrande.lua` é um snapshot anterior** e não tem a vila circular, as ruas laterais, a muralha nem a extensão de luzes desta última sessão; o código dessas partes está em `docs/Módulo ConstrutorVilaGrande - Código parte 10 vila circular.md` e nas partes 7 a 9. Para atualizar o módulo, exportar o `ConstrutorVilaGrande` do Studio de novo.
- **Neblina e carregamento por distância desligados.** No Studio, `FogStart` e `FogEnd` estão em 100000, `NevoaDistante` está com `Enabled = false` e `StreamingEnabled` é `false`. O arquivo `NevoaDistante.lua` continua igual; a desativação é uma propriedade do Studio, não do código.
- **Versão consolidada do módulo.** O arquivo original tinha definições antigas de `M.praca`, `M.pedras`, `M.detalhes` e `M.fonte` que eram sobrescritas mais abaixo. Aqui ficaram só as versões finais. O comportamento é o mesmo.
- **Fora desta pasta:** as extensões feitas depois, em outras sessões (ruas laterais, anel viário, casas em ruína, NPCs, cena do terraço, fazendas, relva nova e vila circular). Elas estão no lugar salvo do Studio, não aqui.
- **Não testado de novo** depois da transcrição. Os scripts rodaram no Studio durante o chat. Não há interpretador Lua instalado para checar a sintaxe deste repositório.
- **Pedaços temporários de teste não entram:** o script `TesteCamera`, a cópia `ConstrutorVilaGrande_run` (é só um clone para furar o cache do `require`) e o módulo antigo `ConstrutorVila`.

## Estrutura

```
vila-medieval-noturna/
├── README.md
├── src/
│   ├── ServerStorage/
│   │   └── ConstrutorVilaGrande.lua     módulo que constrói a vila (ModuleScript)
│   ├── ServerScriptService/
│   │   ├── LuzesDaVila.lua              luzes que acendem, piscam e apagam
│   │   └── NascerNaPraca.lua            o jogador nasce sempre na praça
│   ├── StarterPlayerScripts/
│   │   ├── GramaViva.lua                grama animada, reflexo da Lua e vagalumes
│   │   ├── NevoaDistante.lua            descarrega casas e postes além da neblina
│   │   └── NeblinaLua.lua               névoa fina na direção da Lua
│   └── Fonte/
│       └── FonteFalha.lua               Script filho do Model "Fonte"
├── geradores/
│   ├── gerar_imagens.py                 gera lua.png e vela.png
│   ├── gerar_vela2.py                   gera vela2.png (descartada)
│   ├── gerar_vela3.py                   gera vela3.png (vidro quadriculado, em uso)
│   └── *.png                            imagens geradas
└── docs/                                notas do cofre sobre este projeto (ver docs/Jogos - Gerais.md)
```

## Onde cada arquivo vai no Studio

| Arquivo | Destino no Studio | Tipo |
|---|---|---|
| `src/ServerStorage/ConstrutorVilaGrande.lua` | `ServerStorage.ConstrutorVilaGrande` | ModuleScript |
| `src/ServerScriptService/LuzesDaVila.lua` | `ServerScriptService.LuzesDaVila` | Script |
| `src/ServerScriptService/NascerNaPraca.lua` | `ServerScriptService.NascerNaPraca` | Script |
| `src/StarterPlayerScripts/GramaViva.lua` | `StarterPlayer.StarterPlayerScripts.GramaViva` | LocalScript |
| `src/StarterPlayerScripts/LuzesCliente.lua` | `StarterPlayer.StarterPlayerScripts.LuzesCliente` | LocalScript (anima as luzes no cliente) |
| `src/StarterPlayerScripts/NevoaDistante.lua` | `StarterPlayer.StarterPlayerScripts.NevoaDistante` | LocalScript (desativado no Studio) |
| `src/StarterPlayerScripts/NeblinaLua.lua` | `StarterPlayer.StarterPlayerScripts.NeblinaLua` | LocalScript |
| `src/Fonte/FonteFalha.lua` | `Workspace.Vila.Fonte.FonteFalha` | Script (criado pelo módulo, não copiar à mão) |

O script `FonteFalha` é criado pelo próprio módulo dentro do Model da fonte. O arquivo deste repositório serve de referência.

## Como montar do zero

1. **Lugar:** mover a `Baseplate` para `ServerStorage`.
2. **Terreno:** limpar, preencher Ground de 768x16x768 centrado em `(0, -8, 0)`, cor `(44, 60, 50)`, e reescrever a camada superior com ocupação 0,45 (ver a nota de terreno em `docs/`). Sem isso as pedras ficam escondidas sob o terreno.
3. **Lighting, Sky e Atmosphere:** aplicar os valores da seção abaixo.
4. **Imagens:** rodar `geradores/gerar_imagens.py` e `geradores/gerar_vela3.py`. Enviar `lua.png` e `vela3.png` ao Roblox com a ferramenta `upload_image` (ou pelo Asset Manager). Os ids usados no chat foram `rbxassetid://128342251593093` (Lua) e `rbxassetid://124780722048553` (vidro). Se o id mudar, trocar em `Sky.MoonTextureId` e na função `janela` do módulo.
5. **Módulo:** criar o ModuleScript `ServerStorage.ConstrutorVilaGrande` com o conteúdo de `src/ServerStorage/ConstrutorVilaGrande.lua`.
6. **Construção em modo Edit.** Cada chamada abaixo deve ser feita com o jogo parado. Antes de cada rodada, clonar o módulo para furar o cache do `require`:

```lua
local SS = game.ServerStorage
local velho = SS:FindFirstChild("ConstrutorVilaGrande_run"); if velho then velho:Destroy() end
local copia = SS.ConstrutorVilaGrande:Clone()
copia.Name = "ConstrutorVilaGrande_run"
copia.Parent = SS
local V = require(copia)

local vila = Instance.new("Folder"); vila.Name = "Vila"; vila.Parent = workspace
V.praca(vila)
V.pedras(vila)
V.detalhes(vila)
-- remover poças e musgo gerados por detalhes (ver docs: "Piso - Poças e círculos pretos removidos")
vila.Detalhes.Pocas:Destroy(); vila.Detalhes.Musgo:Destroy()
V.fonte(vila, Vector3.new(0, 0.5, 0))
```

   Depois, as casas, os postes, o mobiliário e os adereços (as posições e sementes estão nas notas `docs/Casas - Posicionamento no anel da praça.md`, `docs/Postes e lampiões - Geometria e luz.md` e `docs/Adereços - Carroças, feno, cercas e barracas.md`). Cada casa é uma chamada a `V.casa(parent, cf, opções)`; cada poste, `V.poste(parent, cf, estado, grupo, nome)`.

7. **Scripts** de `src/` nas pastas indicadas na tabela.
8. **Ajustes finais de luz e cor** (também nas notas de luzes e de piso): lampiões em `Range 44`, `Brightness 1.25`, cor `(255, 184, 108)`; janelas com `Range 13`, `Brightness 0.3`.
9. **Testar em Play** e salvar o lugar. Nada deste repositório salva o lugar sozinho.

## Configuração do Studio (não está em nenhum script)

- **Lighting:** `ClockTime` 19,8; `Brightness` 0; `Ambient` e `OutdoorAmbient` em `(0, 0, 0)`; `ColorShift_Top` e `ColorShift_Bottom` em `(0, 0, 0)`; `EnvironmentDiffuseScale` 0; `EnvironmentSpecularScale` 0,15; `ExposureCompensation` 0,35; `FogColor` `(8, 9, 13)`; `FogStart` e `FogEnd` em 100000 (neblina removida nesta versão; o valor original era 12 e 135).
- **Lighting.Technology:** Future para sombras dos PointLights e reflexos da água. Essa propriedade não pode ser mudada por script; ajustar à mão no painel Properties.
- **Sky:** `MoonTextureId` com o id da Lua; `MoonAngularSize` 18; `SunAngularSize` 0; `StarCount` 4000.
- **Atmosphere:** `Density` 0,3; `Haze` 0,3; `Offset` 0; `Glare` 0; `Color` `(8, 10, 16)`; `Decay` `(2, 3, 6)`.
- **Bloom:** `Intensity` 0,5; `Size` 24; `Threshold` 1,2.
- **ColorCorrection "CorNoite":** `TintColor` `(255, 250, 244)`; `Saturation` 0; `Contrast` 0,2; `Brightness` -0,04.
- **DepthOfField:** desligado. **SunRays:** intensidade 0.
- **Água do Terrain:** `WaterColor` `(22, 52, 72)`; `WaterTransparency` 0,5; `WaterReflectance` 1; `WaterWaveSize` 0,12; `WaterWaveSpeed` 8.
- **Spawn:** `SpawnLocation` em `(0, 1, 46)`, 6x1x6, transparente. O script `NascerNaPraca` reposiciona o personagem em `(0, 5, 44)` olhando para `-Z`.

## Limitações conhecidas

- **Sombras e reflexos** dependem da tecnologia Future, que é manual (ver acima).
- **Mapa inteiro carregado de uma vez:** sem neblina nem carregamento por distância, o cliente recebe todas as peças da vila (cerca de 125 mil) logo no início. Se pesar em computadores modestos, reativar `NevoaDistante`, o fog e o `StreamingEnabled` (valores em `docs/Neblina - Parâmetros e comportamento.md`).
- **FPS não foi medido** neste chat. A cena tem muitas peças (vila e grama somam bem mais de 20 mil), então a primeira coisa a cortar, se pesar, são os pedregulhos, as lâminas de grama e as sombras dos postes. Ver `docs/Vila Medieval - Desempenho e contagem de peças.md`.
- **Lua:** é textura do `Sky`, e não uma peça, porque a peça aparecia na frente de construções distantes e não podia ficar longe o bastante. Ver `docs/Lua - Tentativas descartadas.md`.
- **Imagens:** a textura da Lua e o vidro quadriculado foram enviados pela conta do criador do lugar. Em outra conta, é preciso enviá-las de novo.
- **Rede da escola:** em redes que bloqueiam o download de assets, personagens e NPCs podem não aparecer. Não é bug do cenário.

## Documentação

A pasta `docs/` tem as notas do cofre (Obsidian) sobre cada parte do projeto: parâmetros, geometria, decisões, o que foi tentado e o que foi descartado, e o código das partes do módulo. O índice é `docs/Jogos - Gerais.md`.

Aviso: as notas foram copiadas do cofre no estado atual. Algumas receberam seções de sessões posteriores (expansão, NPCs, cena do terraço), que não estão neste repositório; essas seções ficaram com referências que não existem aqui. Para ver só o que foi feito neste chat, use as seções iniciais de cada nota. Os links `[[...]]` do Obsidian foram convertidos em texto.

## Referências visuais

Praças alemãs com casas de enxaimel e fonte central, usadas como referência (ver `docs/Vila Medieval - Referências visuais pesquisadas.md`):

- Calw, Floresta Negra, fonte iluminada à noite: https://p12.photo12.com/en/image/brk25m52_308
- Römerberg, Frankfurt, fonte Justitia: https://mediastorehouse.com/worldinprint/half-timbered-houses-justitia-fountain-roemerberg-13324809.html
- Plönlein, Rothenburg: https://www.locationscout.net/germany/20538-plonlein

## Licença

Nenhuma licença definida. Antes de publicar como projeto aberto, escolha uma.
