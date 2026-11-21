---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, iluminacao, noite]
---
# Iluminação - Configuração final da noite
Índice: Jogos - Gerais

## Conceito
- A noite do projeto é uma noite sem luz ambiente: a única luz que atinge as superfícies vem de PointLights (lampiões, velas das janelas, lanternas de porta e barracas). Partes fora do alcance das luzes ficam em breu.

## Valores em Lighting
- ClockTime = 19,8 (define a posição da Lua; ver Lua - Textura no Sky).
- GeographicLatitude = 0.
- Brightness = 0 (sem luz direcional da Lua).
- Ambient = (0, 0, 0) e OutdoorAmbient = (0, 0, 0).
- ColorShift_Top = ColorShift_Bottom = (0, 0, 0).
- EnvironmentDiffuseScale = 0 e EnvironmentSpecularScale = 0,15.
- ExposureCompensation = 0,35.
- GlobalShadows = true.
- FogColor = (8, 9, 13), FogStart = 12, FogEnd = 135 (ver Neblina - Parâmetros e comportamento).

## Efeitos
- Atmosphere, Sky, Bloom, ColorCorrection e DepthOfField: ver Céu - Estrelas, atmosfera e pós-processamento.

## PointLights da cena
- Lampiões dos postes: Range 44, Brightness 1,25, Color (255, 184, 108), Shadows = true.
- Janelas das casas: Range 13, Brightness 0,3, Color (255, 176, 84).
- Lanterna de porta: Range 22, Brightness 0,5, Color (255, 170, 80).
- Barracas: Range 30, Brightness 0,8.
- Vagalumes: Range 8, Brightness variável de 0,1 a 2,3, Color (190, 255, 150).
- Detalhes por tipo em Luzes das casas - Tons e intensidades e Postes e lampiões - Geometria e luz.

## Exceções e limites
- `Lighting.Technology` não pode ser definida por script. As sombras dos PointLights (Shadows = true) só aparecem sob a tecnologia Future; o dono do projeto deve selecioná-la no Studio.
- Com Brightness 0 e ambiente 0, qualquer parte sem PointLight nas proximidades fica totalmente preta, incluindo o topo da fonte e rotas de acesso sem lampiões.

## Revisão - fog desligado
- Valores atuais do fog: FogStart = 100000 e FogEnd = 100000 (sem neblina nativa); FogColor segue em (8, 9, 13). Os demais valores desta nota não mudaram. Em vez de ficarem escondidos pela neblina a 135 studs, os lampiões e janelas distantes agora aparecem como pontos de luz no escuro.
- Só os 28 postes originais têm luz com sombra; as outras 108 luzes de poste ficam sem sombra (ver Luzes - Animação no cliente e falhas de carregamento).

## Revisão - hora e latitude para a Lua do terraço
- `ClockTime` passou de 19,8 para 3,4 e `GeographicLatitude`, de 0 para 20, só para levar a Lua ao oeste, a cerca de 39 graus de elevação, de modo que apareça a quem olha para cima no terraço da casa da cobertura (detalhes e método na nota da Lua, citada acima). Os demais valores desta nota não mudaram: `Brightness` segue em 0 e o ambiente, preto, então a hora não ilumina nada.
- Ao restaurar a vila depois de uma inspeção com luz de dia, os valores a devolver são esses dois novos (ver Roblox Studio - Inspeção visual em Edit com luz de dia temporária).

## Relacionados
- Iluminação - Evolução e lições
- Luzes - Sistema de estados
