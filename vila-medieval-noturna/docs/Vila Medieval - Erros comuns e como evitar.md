---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, armadilhas]
---
# Vila Medieval - Erros comuns e como evitar
Índice: Jogos - Gerais

## Conceito
- Armadilhas encontradas durante a construção, com a causa e a correção. Todas se repetirão se o caminho for refeito sem atenção.

## Lista
- **Construir durante o Play**: toda chamada com `datamodel_type` Edit falha se o jogo estiver rodando. Parar o Play antes de editar (ver Roblox Studio - Modo Edit e modo Play).
- **require com cache**: depois de editar o ModuleScript, `require` devolve a versão antiga. Clonar o módulo e dar require na cópia (ver Roblox Studio - ModuleScript, require e cache).
- **Terreno escondendo o piso**: a superfície do terreno ficava em y = 2 e cobria praça, pedras e bases das casas; corrigir com ocupação parcial na camada superior (ver Terreno - Material Ground e altura real da superfície).
- **Terreno de Grass**: gera decoração 3D que não se desliga por script e cobre as peças; usar Ground.
- **Lua em SurfaceGui**: não aparece além de cerca de 1.000 studs e, perto, atravessa a profundidade das construções; usar a textura do Sky (ver Lua - Tentativas descartadas).
- **Streaming**: o lugar tem StreamingEnabled; peças muito longe não chegam ao cliente e scripts que listam descendentes cedo demais veem zero itens (ver Roblox Studio - Streaming e SurfaceGui à distância).
- **Câmera em Play**: `execute_luau` não consegue manter uma câmera Scriptable, e `screen_capture` ignora a posição pedida durante o Play (ver Roblox Studio - Teste em Play e capturas de tela).
- **Propriedades bloqueadas**: `Lighting.Technology` não é gravável; `Terrain.Decoration` e `Workspace.StreamingTargetRadius` não existem no contexto do plugin (ver Roblox Studio via MCP - Limitações de permissão).
- **HttpService desligado**: não dá para exportar scripts do Studio por HTTP; ler com `script_read`.
- **Estimar a escala**: um Humanoid tem cerca de 5 studs; portas de 3 studs, postes baixos e bancos pequenos ficam ridículos.
- **Luz exagerada**: lampiões com brilho 2,8 e alcance 56 estouram a praça em laranja; o ajuste final é brilho 1,25 e alcance 44 (ver Postes e lampiões - Geometria e luz).
- **Janelas Neon**: Neon com cor laranja vira amarelo chapado sob Bloom; usar vidro escuro com Decal (ver Janelas - Brilho de vela quadriculado).
- **Grama Neon**: brilha no escuro; escurecer a cor base.
- **Poças de vidro escuro**: sem reflexo viram círculos pretos (ver Piso - Poças e círculos pretos removidos).
- **Substituição global de texto**: um `replace_all` de "Mat.Plaster" não atingiu o módulo como esperado; conferir sempre o resultado com uma busca no Source.
- **Pedregulhos flutuando**: o raycast sem filtro acertava o terreno, que na época ficava 2 studs acima do piso; assentar peças pequenas por raycast que só enxerga o piso (ver Piso - Pedregulhos flutuando e reassentamento).
- **Models novos sumindo longe do centro**: o NevoaDistante lê o pivô ao iniciar e, com StreamingEnabled, Models vazios têm o pivô na origem; fixar `WorldPivot` (ver Carregamento por distância - Pivôs dos Models novos).
- **Casas, postes e adereços sobre o terreno**: a superfície real do terreno fica em y = -0,2, e peças apoiadas em y = 0,5 pairam 0,7 acima; usar calçada de pedra ou fundação escondida (ver Ruas - Continuação e calçadas até as praças circulares).
- **Ruínas em excesso**: sem limite por conjunto o sorteio produz casas em ruína demais; limitar o número por fileira e por círculo (ver Casas em ruína - Níveis de envelhecimento).
- **Primeira casa da fileira sobre o anel original**: iniciar a fileira em x = 86 gera sobreposição com as casas do anel nos ângulos de 22,7 e 67,3 graus; iniciar em x = 90 (ver Casas das ruas - Fileiras variadas e luzes apagadas).
- **Câmera de Play não acompanha o giro**: ao teletransportar o personagem, a captura pode mostrar a direção oposta; conferir a geometria em Edit com luz de dia temporária (ver Roblox Studio - Inspeção visual em Edit com luz de dia temporária).
- **Animar luzes no servidor**: laços de Heartbeat e corrotinas que mexem em Brightness, Transparency, Material e Color de centenas de itens replicam milhares de escritas por segundo e as luzes aparecem tarde ou travadas; animar no cliente e deixar o servidor só com o estado inicial (ver Luzes - Animação no cliente e falhas de carregamento).
- **Pedras duplicadas onde duas ruas se encontram**: nas curvas do anel viário, as calçadas das duas meias ruas se sobrepõem e as pedras de alturas diferentes cintilam; só a meia rua com `kd = kc + 1` leva a pista e as calçadas até o canto (ver Ruas laterais - Anel viário entre as ruas cardeais).
- **Pedregulhos flutuando depois de apagar pedras**: ao remover pedras do cruzamento, apagar também os pedregulhos que estavam sobre elas (ver Cruzamentos - Limpeza de casas, pedras e meios-fios).
- **Fileiras que se encontram na curva**: as margens internas das duas meias ruas ocupam o mesmo quarteirão no canto; terminar a margem interna em x = 150.
- **Models de pedra grandes demais para o descarregamento**: anéis de pedras divididos em seis Models têm centenas de studs de arco e o pivô no meio; usar Models de 36 pedras (ver Passeio da muralha - Lajes, pedras e postes).
- **multi_edit sem efeito no Source**: depois de criar um script com `multi_edit`, uma segunda chamada devolveu sucesso, mas o `Source` lido por `execute_luau` continuou com o texto antigo; conferir o `Source` depois de editar e, se for preciso, atribuí-lo por `execute_luau`.
- **Atalho de vetor sem campos estáticos**: depois de `local V3 = Vector3.new`, `V3.xAxis` falha, porque a variável é uma função; usar `Vector3.xAxis` (ver Módulo ConstrutorCasaVaranda - Código completo).
- **Furo da parede e janela com bases diferentes**: se o vão aberto na parede e a janela que o preenche usam bases de altura distintas, sobra uma fresta ou um pedaço de parede dentro do vão; passar a mesma base aos dois (ver Técnica de recortes - Paredes e lajes com furos).
- **Corrente de lampião terminando no ar**: lampiões suspensos precisam prender a corrente numa viga ou num tirante; conferir a posição em x e z do ponto de fixação (ver Casa da cobertura - Interior e móveis).
- **Concluir que o percurso é impossível porque o pathfinder falhou**: o pathfinder do Studio (raio de agente 2) não achou rota pela porta de 5,4 nem até o 1º andar da casa da cobertura, embora o personagem suba a pé; testar com `Humanoid:MoveTo` degrau a degrau (ver Casa da cobertura - Escadas internas e níveis).
- **Cerca ou NPC diante de uma porta nova**: ao trocar uma casa, conferir se as cercas e os NPCs do lote deixam um acesso direto à porta (ver Casa da cobertura - Casa com interior e terraço na rua Norte).
- **Aviso de porta na mesma tecla de um NPC**: dois `ProximityPrompt` na tecla E disputam, e a conversa do NPC desliga o serviço de avisos até acabar; usar teclas diferentes e afastar NPCs da frente das portas (ver Prompts de interação - Tecla F da casa e tecla E dos NPCs).
- **Objetos do interior registrados duas vezes**: a cópia do interior guardada em `ReplicatedStorage` leva as mesmas tags da cópia em uso, e `GetTagged` devolve as duas; registrar só o que é descendente do Workspace (ver Casa da cobertura - Portas de dobradiça e passagem entre mundos).
- **Interior preto absoluto**: com a noite da vila (brilho 0 e ambiente preto), um espaço sem luz não mostra nem a porta de entrada; dar ao jogador uma PointLight fraca e fria que se apaga quando alguma luz é acesa (ver Casa da cobertura - Escuridão inicial e brilho no escuro).
- **Animação que acumula deriva ao recarregar o mundo**: um script que toma a pose atual como base registra uma pose torta se o objeto for descarregado no meio do movimento; guardar a pose de repouso em um atributo (ver Cadeira de balanço - Modelo e script CadeiraBalanco).
- **Aviso de lampião escondido pelo da porta**: dois avisos próximos competem pela mesma tecla; reduzir o alcance dos avisos de porta dentro de casa (ver Casa da cobertura - Lampiões, lareiras e lustres acendíveis).
- **Espera escondida num WaitForChild com tempo limite**: `require(PlayerScripts:WaitForChild("PlayerModule", 5))` esperava os 5 s inteiros na primeira passagem pela porta, porque o PlayerModule não existe em `PlayerScripts` no teste em Play; conferir se o objeto existe antes de esperar por ele e medir a latência com um amostrador de quadros (ver Casa da cobertura - Primeira passagem sem travada).
- **Guarda-corpo que não impede a queda**: balaústres sem colisão deixam o jogador atravessar o terraço ou pular dele; fechar o terraço com paredes invisíveis (`Transparency` 1 e `CanQuery` desligado) mantém a vista livre (ver Casa da cobertura - Barreira invisível do terraço).
- **Casca de fachada vazia**: uma fachada de paredes ocas, com o interior em outro espaço, mostra o vazio quando a câmera entra no casco (câmera atrás do personagem encostado na porta, zoom, fresta entre as folhas); encher os vazios com blocos opacos e pôr a câmera do lado de fora (ver Casa da cobertura - Preenchimento da fachada e câmera de chegada).
- **CanQuery desligado não tira uma peça com colisão dos raios**: `Workspace:Raycast` ainda a atinge; para uma parede invisível não atrapalhar a câmera vale a `Transparency` 1, e os raios do jogo precisam pular peças transparentes (como faz a função `camaraAtras`).

- **Aviso padrão de ProximityPrompt que não aparece, com a tecla funcionando**: o aviso `Default` é desenhado pelo motor e não pode ser inspecionado; quando falha, a tecla ainda aciona o prompt. Para um aviso confiável, usar `Style = Custom` e desenhar o próprio `BillboardGui`; todo prompt `Custom` passa pelos tratadores de `PromptShown` de todos os scripts, então cada tratador deve filtrar pelo nome do prompt (ver Script AvisosCasa - Código completo).
- **PreloadAsync sem limite de espera**: com a rede bloqueando os assets a chamada não volta, e uma interface de pré-carga que só se destrói depois dela fica na tela para sempre; rodar a chamada em outra tarefa e esperar no máximo alguns segundos (ver Pergaminho do ancião - Folha envelhecida e caixa de fala).
- **NPC com o corpo dentro de poste, casa ou pedra alta**: o ponto escolhido numa grade de células não garante que o corpo inteiro caiba; medir cada peça com `GetPartsInPart` e ignorar os discos `Piso`, cujo `Size.Y` é o diâmetro (ver NPCs da vila - NPCs encravados em obstáculos e reposicionamento).
- **Laço de Heartbeat que ignora o interior da casa**: vagalumes, grama e neblina rodam no cliente; todo laço novo por quadro deve parar quando o atributo `InteriorAtivo` vale `true` (ver Vagalumes - Script e parâmetros).
- **Ambiente guardado por uma função chamável duas vezes**: o "original" passa a ser o valor já alterado; guardar só se ainda não houver guardado (detalhes na nota da escuridão inicial, citada acima).
- **Script padrão do modelo base**: o `Script` com `print("Hello world!")` em `Workspace` polui o console e esconde mensagens úteis; desativar (ver Vila Medieval - Varredura geral de bugs).

- **Aviso `Custom` sem vigia**: um aviso desenhado pelo jogo só é confiável se alguém garantir que ele existe enquanto o prompt está mostrado; criá-lo apenas em `PromptShown` deixa buraco se o objeto for destruído ou o estilo mudar. Manter a tabela do que o motor diz estar mostrado e conferir a cada 0,2 s (recriar, retirar, repor o estilo), com volta ao aviso padrão se desenhar falhar (a solução do aviso da casa, descrita na nota citada acima).
- **`UIOffset` em `BillboardGui`**: a propriedade é do `ProximityPrompt`; o `BillboardGui` tem `SizeOffset` (em frações do próprio tamanho), e usar `UIOffset` nele dá "is not a valid member" e derruba o desenho do aviso.
- **Lua que não aparece de onde o jogador olha**: a posição da Lua vem de `ClockTime` e `GeographicLatitude`, e com latitude 0 ela fica sempre perto do norte; para levá-la a outro azimute é preciso mexer na latitude, achando valores por busca e conferindo a linha de visão com raios que ignorem peças invisíveis (ver Lua - Textura no Sky).
- **Teste que derruba o personagem fora do piso**: teletransportar o personagem para uma posição calculada sem conferir o chão (no interior da casa, a cerca de 1500 de altura) o faz cair e morrer; o respawn leva à praça e descarrega o interior. Achar o piso por raio e pôr o personagem 3 acima dele.

## Relacionados
- Vila Medieval - Ordem de reconstrução passo a passo
- Vila Medieval - Visão geral
- Roblox Studio via MCP - Ferramentas e fluxo de trabalho

## Revisão - defeitos de fachada achados por medição
- Veneziana aberta invadindo a janela ou a porta vizinha: antes de abrir uma folha contra a parede, conferir se há uma folha de largura livre até o vão seguinte.
- Viga do enxaimel atravessada num vão de porta: vigas horizontais devem ser cortadas nos vãos que vão do piso ao alto.
- `WoodPlanks` com as tábuas na horizontal numa porta: o desenho corre ao longo do X da peça; deitar a peça e girá-la 90 graus.
- Peças sem consulta espacial (`CanQuery` desligado) não aparecem em `GetPartsInPart`: uma conferência que dá "zero sobreposições" pode estar cega a elas; comparar caixas por conta própria.
- Detalhes em Fachadas - Venezianas sobrepostas, vigas no vão da porta e tábuas verticais.

## Revisão - lições das fazendas dos quarteirões
- **Identificador com letra acentuada**: `fz.Adereços` quebra o código no Luau com "Failed to parse command code"; usar `fz["Adereços"]`. Cadeias de texto com acento funcionam normalmente.
- **Peça decorativa invisível a raios e caixas**: as peças das fazendas têm `CanQuery` desligado, então `Raycast` e `GetPartBoundsInBox` não as veem; o NPC que fica sobre um leito precisa subir à mão a altura do leito (0,6) ou do disco do terreiro (0,12).
- **Siglas iguais para quarteirões diferentes**: a primeira e a última letra de "Nordeste" e "Noroeste" dão `ne` nos dois; usar uma tabela explícita de siglas nos ids dos NPCs.
- **Reconstruir sem desfazer**: chamar `M.desfazer(i)` antes de `M.construir(i)`; sem isso, a grama é rareada de novo a cada reconstrução (ver Fazendas dos quarteirões - Grama seca e retirada das lâminas).
- **Capturas em lote**: três `screen_capture` seguidos estouram o tempo e uma captura repetida pode devolver o quadro anterior; fazer uma por vez e conferir se a imagem mudou (ver Fazendas dos quarteirões - Verificação e limites).

## Revisão - lições do diálogo, do trabalho e dos detalhes das fazendas
- **A tecla que abre a conversa também a avança**: o mesmo E que aciona o `ProximityPrompt` chega a `InputBegan` com a caixa já aberta e pode pular a primeira página; dar uma folga de cerca de 0,25 s depois de abrir. Digitação e esperas devem seguir `os.clock()`, e a espera por uma imagem precisa ter limite curto (0,5 s), porque em rede lenta ou com assets bloqueados ela é o tempo máximo de uma conversa que parece não abrir (ver NPCs da vila - Endurecimento da lógica de diálogo).
- **Testar a conversa num NPC sem prompt**: os caminhantes (`Rota`) não têm o prompt `Falar`; um teste que mira um deles nunca abre nada. Escolher um NPC parado e falante.
- **Ferramenta de balanço apontando para o jogador**: o corpo girando para quem conversa faz a enxada, a pá, o machado ou a vassoura parecerem dirigidos a ele; quem trabalha deve continuar no lugar, só com a cabeça acompanhando (ver NPCs da vila - Trabalho durante a conversa).
- **Captura de tela parada por minutos**: o `screen_capture` pode devolver o mesmo quadro ou estourar o tempo por um longo período, mesmo em Play, sem erro no jogo; não concluir que a cena está parada. Conferir por consulta (`execute_luau`) enquanto isso e repetir a captura depois, uma de cada vez.
- **Telhado de uma água errada**: refazer a água como espelho da outra em relação à cumeeira, em vez de consertar peça por peça (ver Casas em ruína - Reparo de telhado por espelhamento da água).
- **Terreiro apertado demais para os objetos novos**: quando poço, carroça e cocho já ocupam o centro, o anel de busca de lugar precisa ir até 15 studs e os raios de reserva devem ser pequenos; senão o braseiro, a lenha e os sacos ficam sem posição (ver Fazendas dos quarteirões - Detalhes e postes da vila).

## Revisão - lições da relva e do personagem parado na conversa
- **Script que move milhares de peças**: quase todo o custo está em `BulkMoveTo` (cerca de 80%), e não na conta de cada lâmina. Medir o tempo do cálculo separado do tempo da chamada, e reduzir a quantidade de peças movidas por quadro (raio, taxa por distância, escala que encolhe sozinha) antes de otimizar a matemática (ver Grama - Relva densa em dois segmentos).
- **Plantar sobre o chão sem enxergar peças `CanQuery` desligado**: consultas espaciais não as veem, e havia 11.618 delas perto do chão (parcelas, detalhes, caminhos, água). A ocupação precisa ser um raster montado a partir de todas as peças que tocam a faixa do chão, e a conferência final deve ser feita contra esse raster.
- **Cortar texto acentuado no meio de um caractere**: `string.sub` por bytes pode partir uma letra e `HttpService:JSONEncode` falha com "Can't convert to JSON". Usar `utf8.len` e `utf8.offset`, ou não fatiar o texto.
- **Tecla segurada depois de desligar os controles**: `Controls:Disable()` não zera o comando de movimento já em curso; segurar W ao apertar E continuaria andando. Chamar `Humanoid:Move(Vector3.zero)` a cada quadro enquanto durar o bloqueio (ver NPCs da vila - Personagem parado durante a conversa).
- **Um bloco grande de peças de uma vez**: parentar uma pasta com milhares de descendentes é uma única operação que não cede o controle. Parentar primeiro a pasta raiz e entrar com as pastas filhas, pequenas, uma a uma, com `task.wait` a cada poucas.
- **E apertado de novo logo depois de fechar**: o aviso volta cerca de 0,3 s depois do fechamento, então um segundo E reabre a conversa. É o desenho esperado, não um defeito.
