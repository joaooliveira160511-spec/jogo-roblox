---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, receita]
---
# Vila Medieval - Ordem de reconstrução passo a passo
Índice: [[Jogos - Gerais]]

## Conceito
- Receita na ordem exata em que os elementos devem ser criados para obter o mesmo resultado. Todas as etapas de construção rodam em modo Edit; o modo Play serve só para testar.

## Passos
1. **Conectar** ao Studio com `list_roblox_studios` e usar o id retornado em todas as chamadas (ver [[Roblox Studio via MCP - Ferramentas e fluxo de trabalho]]).
2. **Guardar a Baseplate**: mover `Workspace.Baseplate` para ServerStorage.
3. **Terreno**: limpar, preencher um bloco de Ground de 768x16x768 centrado em (0, -8, 0), cor (44, 60, 50), e reescrever a camada superior com ocupação 0,45 (ver [[Terreno - Material Ground e altura real da superfície]]).
4. **Lighting e Sky**: aplicar os valores de [[Iluminação - Configuração final da noite]] e [[Céu - Estrelas, atmosfera e pós-processamento]].
5. **Imagens**: gerar com Python a Lua e o vidro quadriculado, enviar com `upload_image` e anotar os ids (ver [[Roblox - Imagens geradas por Python e enviadas ao Roblox]]).
6. **Módulo**: criar o ModuleScript `ServerStorage.ConstrutorVilaGrande` com o código de [[Módulo ConstrutorVilaGrande - Visão geral e API]]; antes de cada rodada de construção, clonar o módulo para furar o cache de require (ver [[Roblox Studio - ModuleScript, require e cache]]).
7. **Praça** (`praca`) e **pedras** (`pedras`), depois **detalhes** (`detalhes`): ver [[Praça - Geometria e raios]] e [[Piso - Pedras individuais estilo cobblestone]]. Remover as poças geradas por `detalhes` (ver [[Piso - Poças e círculos pretos removidos]]).
8. **Fonte** (`fonte`) em (0, 0,5, 0); antes, limpar a água de terreno acima do chão (ver [[Fonte - Estrutura em níveis]]).
9. **Casas**: doze chamadas de `casa` com a sequência de ângulos e estados de [[Casas - Posicionamento no anel da praça]].
10. **Postes** (`poste`): doze na borda da praça e dezesseis nas ruas (ver [[Postes e lampiões - Geometria e luz]]).
11. **Mobiliário e adereços**: barris e caixas junto às casas e `aderecos` (ver [[Adereços - Carroças, feno, cercas e barracas]]).
12. **Ajustes de cor e luz** pós-construção: recolorir pedras, janelas e lampiões conforme as notas de luzes (ver [[Luzes das casas - Tons e intensidades]]).
13. **Grama**: gerar as lâminas do anel externo (ver [[Grama - Geração das lâminas]]).
14. **Scripts**: criar LuzesDaVila, NascerNaPraca, GramaViva, NevoaDistante e NeblinaLua (ver [[Luzes - Script LuzesDaVila]], [[Nascimento do jogador - Script NascerNaPraca]], [[Grama - Script GramaViva]], [[Carregamento por distância - Script NevoaDistante]], [[Neblina da Lua - Script NeblinaLua]]).
15. **Testar em Play** com teletransportes e capturas (ver [[Roblox Studio - Teste em Play e capturas de tela]]).

## Etapas da expansão pelas quatro direções
16. **Reassentar os pedregulhos originais** pelo raycast que só enxerga o piso (ver [[Piso - Pedregulhos flutuando e reassentamento]]).
17. **Piso das direções** (`pisoDirecao`, k de 0 a 3): rua longa, calçadas, praça circular, postes e poço (ver [[Ruas - Continuação e calçadas até as praças circulares]], [[Praça circular - Anel de casas voltadas para dentro]]).
18. **Casas das direções** (`casasDirecao`): duas fileiras por rua e o anel de cada praça (ver [[Casas das ruas - Fileiras variadas e luzes apagadas]] e [[Casas em ruína - Níveis de envelhecimento]]).
19. **Pedregulhos novos** (`pedregulhosDirecao`), **limpeza da grama** (`limpaGrama`) e **fixação dos pivôs** (`fixaPivos`) (ver [[Grama - Limpeza sob as construções novas]] e [[Carregamento por distância - Pivôs dos Models novos]]).
- Visão geral e números: [[Vila Medieval - Expansão pelas quatro direções]].

## Etapas da vila circular
20. **Limpar o que atrapalha**: remover as casas do círculo das praças pequenas, as casas das ruas cardeais que invadem o corredor das ruas laterais e as pedras, pedregulhos e meios-fios do cruzamento; completar o meio-fio das praças (ver [[Cruzamentos - Limpeza de casas, pedras e meios-fios]]).
21. **Piso do anel viário** (`anelPiso`, oito meias ruas) e **passeio e postes da muralha** (`passeioMuro` e `postesMuro`) (ver [[Ruas laterais - Anel viário entre as ruas cardeais]] e [[Passeio da muralha - Lajes, pedras e postes]]).
22. **Casas do anel viário** (`anelCasas`) e **casas da muralha** (`planoMuralha` e `muralhaCasas`, em quatro trechos) (ver [[Vila circular - Muralha de casas voltadas para o centro]]).
23. **Pedregulhos** (`anelPedregulhos`) e **pivôs** (`fixaPivos2` e `fixaPivos`); desligar as sombras dos postes novos.
24. **Luzes**: criar o `LuzesCliente`, reduzir o `LuzesDaVila` ao estado inicial e sortear de novo as luzes das casas antigas (ver [[Luzes - Animação no cliente e falhas de carregamento]]).
- Código: [[Módulo ConstrutorVilaGrande - Código parte 10 vila circular]].

## Exceções e limites
- A construção não deve ser feita com o jogo em Play: o datamodel Edit fica indisponível e a chamada falha com a mensagem "Edit datamodel is not available in Play mode".
- A propriedade `Lighting.Technology` não pode ser alterada por script; precisa ser ajustada à mão no Studio (ver [[Roblox Studio via MCP - Limitações de permissão]]).

## Relacionados
- [[Vila Medieval - Visão geral]]
- [[Vila Medieval - Estado final e números de verificação]]
- [[Vila Medieval - Erros comuns e como evitar]]
