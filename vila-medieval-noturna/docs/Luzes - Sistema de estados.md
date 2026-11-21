---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, luzes, estados]
---
# Luzes - Sistema de estados
Índice: Jogos - Gerais

## Conceito
- Toda fonte de luz da vila é uma peça marcada com a tag `Luz` (CollectionService) e dois atributos: `Estado` (ligada, piscando ou apagada) e `Grupo` (texto). Itens do mesmo grupo acendem e apagam juntos; o script LuzesDaVila lê as tags ao iniciar o jogo (ver Luzes - Script LuzesDaVila).

## Estados
- **ligada**: acesa o tempo todo, com leve tremulado de brilho.
- **piscando**: acesa por 2 a 9 s, depois uma rajada de 3 a 9 falhas (apaga por 0,04 a 0,25 s, acende com 40 a 100% de intensidade por 0,04 a 0,3 s) e, em 30% das vezes, apaga de vez por 0,8 a 2,5 s antes de voltar.
- **apagada**: desligada, vidro escuro sem brilho e sem luz.

## Quem tem tag
- Vidros das janelas das casas (peça "Vidro", com Decal "Vela").
- Lanternas de porta ("LanternaPorta").
- Chamas dos postes ("Chama").
- Lanternas das barracas ("LanternaBarraca").
- Grupos: casas "casa1" a "casa12"; postes "poste1" a "poste28"; barracas "barraca0" a "barraca3".
- Grupos da expansão: casas novas com o nome da própria casa (`CasaLesteA1`, `CasaCircNorte3` e assim por diante), postes `PosteExtLeste1` e `PosteCircLeste1` a `PosteCircLeste12` (e equivalentes), e poços `pocoLeste`, `pocoNorte`, `pocoOeste` e `pocoSul` (ver Postes e lampiões - Continuação nas ruas e nas praças circulares e Poço - Centro da praça circular).

## Contagem na cena final
- 111 itens ligados, 72 piscando e 103 apagados (inclui todos os vidros).
- Casas: 4 ligadas, 3 piscando, 5 apagadas.
- Postes: probabilidades de 55% ligada, 25% piscando e 20% apagada por poste (Random 777).

## Aplicação do estado na construção
- `aplicaLuz(parte, estado)`: se a peça tem Decal (janela), define `Decal.Transparency = 0,4` ligada ou 1 apagada e mantém o vidro Glass escuro; se não tem Decal (lanterna), define Material Neon e cor quente quando ligada, Glass escuro quando apagada. Também liga ou desliga a PointLight filha.

## Exceções e limites
- O estado inicial é definido na construção e o script só o altera em Play; em modo Edit, ver o resultado do estado "piscando" não é possível.
- As luzes "piscando" e "ligada" não coordenam entre grupos; cada uma tem seu ritmo aleatório.

## Revisão - animação no cliente
- Quem lê as tags e anima as luzes agora é o `LuzesCliente` (cliente), não o `LuzesDaVila` (servidor), que só aplica o estado inicial (ver Luzes - Animação no cliente e falhas de carregamento).
- O estado **piscando** passou a ser fraco: fator de brilho de cerca de 0,25 a 0,85 do brilho-base (0,64 com ruído de 0,2, vezes 0,45 a 0,85 durante a rajada), período de 7 a 12 s com uma rajada final de 2,4 s em que a luz falha e, num ciclo em quatro, apaga de vez no fim da rajada. As luzes **ligadas** mantêm o tremor de chama (fator de 0,58 a 1,14).
- Novos grupos: casas `CasaAnel<Cardeal><Lateral><A ou B><n>` e `CasaMuro1` a `CasaMuro84`; postes `PosteAnel<Cardeal><Lateral><n>` e `PosteMuro1` a `PosteMuro24`.
- Cena final: 14 grupos de casa ligados, 30 piscando e 133 apagados.

## Revisão - luzes dos NPCs
- Lanternas, velas, tochas e a vara do acendedor dos NPCs também levam a tag `Luz`, `Estado = ligada` e um `Grupo` próprio (`npc_<modelo>_<peça>`); o `LuzesCliente` as anima como as demais (35 luzes na cena). Elas não entram na conta de iluminação usada para posicionar NPCs (ver a nota sobre a luz própria de lanternas, velas e tochas dos NPCs, em Relacionados).
- O estado `ligada` dos postes, lanternas de porta e poços é o que define onde os NPCs podem ficar (ver a nota da regra de iluminação dos NPCs, em Relacionados).

## Revisão - postes de reforço nas ruas
- 61 postes novos (`PosteRua1` a `PosteRua61`) com `Estado = ligada`, `Grupo = posteRua<n>` e sem sombra. Contando as peças com tag `Luz` de alcance 16 ou mais fora dos NPCs, a cena tem agora 166 ligadas, 75 piscando e 62 apagadas (ver a nota do reforço de postes nas ruas escuras, em Relacionados).

## Revisão - casa da varanda
- A casa da varanda usa o grupo `CasaNorteVaranda`, com `Estado = ligada` nas 9 peças com tag `Luz`: oito vidros de janela e o lampião da varanda, de alcance 26 e brilho 1,0. Ela substituiu uma casa toda apagada (`CasaNorteA1`); os grupos de luz das casas passam a 15 ligados, 30 piscando e 132 apagados (ver Casa da varanda - Cottage com varanda na rua Norte). Essa casa foi removida depois, como descrito a seguir.

## Revisão - casa da cobertura
- O grupo `CasaNorteCobertura` substitui o `CasaNorteVaranda`, com `Estado = ligada` nas 26 peças com tag `Luz` (17 vidros de janela, 5 lampiões, 3 velas e o fogo da lareira) e 11 PointLights ativas. Como uma casa ligada trocou outra ligada, os grupos de luz das casas continuam em 15 ligados, 30 piscando e 132 apagados (ver Casa da cobertura - Luzes).

## Revisão - fachada reformulada da casa da cobertura
- No Model `CasaNorteCobertura` reformulado só as duas lanternas de fora (`LanternaPorta` e `LanternaTerraco`) ficam com a tag `Luz`, ambas `ligada`, de modo que o grupo continua ligado e a contagem de grupos de casa ligados não muda. Os vidros de janela perderam a tag `Luz` e os atributos `Estado` e `Grupo` e passaram a levar a tag `JanelaCasa` e o atributo `Nivel`, lidos só pelo cliente (ver Casa da cobertura - Janelas que acendem por fora e Casa da cobertura - Fachada reformulada e telhado alto).
- As luzes do interior (lampiões, lareiras e lustres) não participam deste sistema: têm tags próprias, começam apagadas e só existem no cliente enquanto o jogador está dentro (ver Casa da cobertura - Lampiões, lareiras e lustres acendíveis).

## Revisão - fazendas dos quarteirões
- Cada uma das quatro fazendas tem 5 peças com a tag `Luz`: quatro lampiões no caminho e o lampião do poço. Grupos `fazenda<Quarteirão>_1` a `_4` (três `ligada` e um `piscando`) e `fazenda<Quarteirão>_poco` (`ligada`); são 20 peças na cena, nenhuma `apagada`. Os lampiões do caminho têm brilho 0,9 e o do poço, 0,6, todos com alcance 15, abaixo do corte de 16 da regra de iluminação dos NPCs (ver a nota da regra, em Relacionados).
- Os luares (três por fazenda) são `PointLight` em peças invisíveis e sem a tag `Luz`: ficam fixos e o `LuzesCliente` não os anima (detalhes na nota da luz fraca das fazendas, em Relacionados).

## Revisão - postes da vila nas fazendas
- As estacas de lampião das fazendas foram trocadas por clones do poste da vila (`PosteVila_fazenda<Quarteirão>_<n>`, com `Estado` e `Grupo` herdados da estaca). Cada fazenda tem agora 6 peças com a tag `Luz` (24 na cena, nenhuma `apagada`): quatro chamas de poste (`fazenda<Quarteirão>_1` a `_4`, com `_3` `piscando` e as outras `ligada`), o lampião do poço (`fazenda<Quarteirão>_poco`) e o braseiro (`fazenda<Quarteirão>_braseiro`, ambos `ligada`).
- Alcance e brilho: postes 30 e 0,8; poço 15 e 0,6; braseiro 13 e 0,6; os três luares seguem sem tag, com alcance 70. Nove `PointLight` por fazenda, nenhuma com sombra. Os postes passam do corte de 16 da regra de iluminação dos NPCs; o poço e o braseiro continuam abaixo (ver a nota da camada de detalhes das fazendas, em Relacionados). As linhas da revisão anterior sobre as fazendas descrevem a situação antes dessa troca.

## Relacionados
- Fazendas dos quarteirões - Luz fraca e luar frio
- Luzes das casas - Tons e intensidades
- Janelas - Brilho de vela quadriculado
- Postes e lampiões - Geometria e luz
- NPCs da vila - Luz própria de lanternas, velas e tochas
- NPCs da vila - Regra de iluminação e escolha das posições
- Postes e lampiões - Reforço nas ruas escuras
- Fazendas dos quarteirões - Detalhes e postes da vila
