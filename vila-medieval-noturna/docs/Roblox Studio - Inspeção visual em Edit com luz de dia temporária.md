---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, mcp, captura, iluminacao]
---
# Roblox Studio - Inspeção visual em Edit com luz de dia temporária
Índice: [[Jogos - Gerais]]

## Conceito
- Em Play, a noite da vila é escura de propósito, e a câmera do jogo segue o personagem, o que dificulta olhar a geometria. Para inspecionar casas, telhados e ruínas, clareia-se a iluminação temporariamente em modo Edit e usam-se capturas com câmera livre.

## Procedimento
1. Guardar os valores originais de `Lighting` em atributos (Brightness, Ambient, OutdoorAmbient, ExposureCompensation, FogStart, FogEnd, FogColor e ClockTime).
2. Ajustar para inspeção: `ClockTime = 10,5`, `Brightness = 2,5`, `ExposureCompensation = 0`, `Ambient` e `OutdoorAmbient` em (105,105,125), `FogStart = 900` e `FogEnd = 1500`. Só mudar `Ambient` não basta: com `Brightness = 0` e sem Sol a cena continua preta.
3. Capturar com `screen_capture` informando `camera_position` e `look_at_position` (funcionam em Edit; ver [[Roblox Studio - Teste em Play e capturas de tela]]).
4. Restaurar todos os valores a partir dos atributos, apagar os atributos e conferir.
- Valores originais da vila: Brightness 0, Ambient e OutdoorAmbient (0,0,0), ExposureCompensation 0,35, FogStart 12, FogEnd 135, FogColor (8,9,13), ClockTime 3,4 e GeographicLatitude 20 (eram 19,8 e 0 até a Lua ser levada ao terraço) (ver [[Iluminação - Configuração final da noite]]).

## Dicas
- Alguns pedidos de captura expiram por tempo; repetir o mesmo pedido costuma funcionar.
- As sombras de dia podem esconder detalhes; mudar o `ClockTime` altera o lado da luz.
- Em Play, o clareamento feito pelo datamodel Client não se mostrou estável (a cena voltou ao escuro pouco depois); a inspeção clara deve ser feita em Edit.
- A câmera de Play pode não acompanhar o giro do personagem teletransportado; para olhar numa direção, a captura em Edit é mais confiável.

## Variante usada na vila circular
- Os valores originais foram guardados num único atributo de `ServerStorage` em JSON (incluindo as propriedades de `Atmosphere` e o estado `Enabled` de cada efeito de pós-processamento) e restaurados dele, apagando o atributo depois. Para inspeção, bastou `Brightness = 3`, `ClockTime = 14`, `Ambient` e `OutdoorAmbient` claros, `FogEnd` muito grande, `Atmosphere.Density` e `Haze` em 0 e os efeitos desligados.
- Para ver a vila toda de cima, uma câmera a 900 studs de altura com `look_at_position` na origem enquadra o círculo inteiro; para um cruzamento ou uma curva, uma câmera a cerca de 100 studs de altura e 50 a 60 de afastamento.

## Variante usada nas fazendas dos quarteirões
- O estado da iluminação foi guardado em JSON em atributos de `ServerStorage` e alternado várias vezes entre dia (para ver a geometria) e noite (para ver a luz fraca da fazenda). Ao fim, cada propriedade foi comparada com o backup antes de apagar os atributos.
- As capturas em Edit foram feitas uma de cada vez: três em lote estouraram o tempo, e uma captura repetida pode devolver o quadro anterior (ver a nota de verificação das fazendas, em Relacionados).

## Relacionados
- [[Fazendas dos quarteirões - Verificação e limites]]
- [[Roblox Studio - Modo Edit e modo Play]]
- [[Roblox Studio via MCP - Ferramentas e fluxo de trabalho]]
