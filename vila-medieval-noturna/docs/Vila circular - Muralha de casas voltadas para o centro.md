---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, muralha, casas, circular]
---
# Vila circular - Muralha de casas voltadas para o centro
Índice: [[Jogos - Gerais]]

## Conceito
- A vila inteira tem formato circular e, no lugar de uma muralha de pedra (como a das cidades cercadas por muros), o limite é um anel contínuo de casas, todas com a fachada voltada para o centro. O anel fecha a volta completa: não há portões, e cada rua cardeal termina numa pequena praça de piso e poço que encara uma casa da muralha.
- O raio da vila é definido pela casa mais distante do centro: o fundo da casa mais profunda da muralha chega a 374,8 studs (terreno de -384 a 384).

## Geometria
- Raio da frente das casas (andares superiores): `RF_MURO = 346`, medido a partir do centro da vila (origem do mundo).
- Centro de cada casa: `rc = 346 + d/2 + 2,4`, em que 2,4 é o balanço da casa (parede térrea mais recuada que os andares superiores); orientação `CFrame.lookAt(posição, origem)`. A frente da parede térrea fica em 348,4 e o fundo em no máximo 372,4 (374,8 nos cantos).
- Dimensões sorteadas: largura w de 19 a 25 e profundidade d de 16 a 24; guinada de ±0,03 rad.
- Cada casa ocupa o ângulo `(w + 0,6 + 2,2 + sorteio de 0 a 1,6) / 346`. Larguras são sorteadas até a soma de ângulos passar de 2*pi; a sobra é repartida por igual entre todas as casas, de modo que a volta fecha sem emenda. O resultado são 84 casas, com folgas de cerca de 3 a 5 studs entre fachadas.
- O plano inteiro vem de uma semente fixa (`Random.new(9300)`), por isso pode ser regenerado igual em qualquer trecho; as casas são construídas em trechos de 21 (índices 1-21, 22-42, 43-63 e 64-84).

## Envelhecimento e luzes
- O parâmetro `t` de cada casa é sorteado entre 0,35 e 0,8, ou seja, a muralha é toda "distante" (ver [[Casas em ruína - Níveis de envelhecimento]]). No máximo 8 casas ficam em ruína total (`limitaRuina`).
- Resultado: 32 intactas, 18 gastas, 26 decadentes e 8 em ruína total.
- Estados de luz do plano: 8 ligadas, 20 piscando e 56 apagadas (ruínas a partir do nível 2 ficam sempre apagadas). Ver [[Casas das ruas - Fileiras variadas e luzes apagadas]] e [[Luzes - Animação no cliente e falhas de carregamento]].
- Cada casa recebe fundação escondida, adereços de calçada (lenha, barris e caixas) e, se em ruína, entulho assentado no piso (ver [[Casa - Hera e envelhecimento]]).

## Nomes e pastas
- Casas `CasaMuro1` a `CasaMuro84` em `Workspace.Vila.Casas`; cada uma com o grupo de luz do próprio nome.
- As pedras sob as casas são removidas com `limpaPedras` (prefixo `Muralha`), 717 pedras no total.

## O que mudou nas praças pequenas
- As quatro praças circulares do fim das ruas mantêm piso, poço e doze postes, mas deixam de ter casas ao redor: as 44 casas do círculo foram removidas, porque a muralha passa a fechar a vila. O meio-fio que tinha ficado de fora junto às portas foi completado (132 blocos). Ver [[Praça circular - Anel de casas voltadas para dentro]] e [[Poço - Centro da praça circular]].

## Código
- `M.planoMuralha`, `M.muralhaCasas`, `M.removeCirculoCasas` e `M.completaMeioFio`: ver [[Módulo ConstrutorVilaGrande - Código parte 10 vila circular]].

## Relacionados
- [[Vila Medieval - Expansão pelas quatro direções]]
- [[Passeio da muralha - Lajes, pedras e postes]]
- [[Ruas laterais - Anel viário entre as ruas cardeais]]
- [[Casas - Posicionamento no anel da praça]]
