---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vagalumes, particulas]
---
# Vagalumes - Script e parâmetros
Índice: Jogos - Gerais

## Conceito
- Quarenta e cinco vagalumes pairam e piscam acima do chão. São peças criadas pelo próprio script do cliente GramaViva e existem só em Play, na pasta `Workspace.Vagalumes`.

## Parâmetros
- Cada vagalume: esfera Neon de 0,28 studs, cor (205,255,140), sem colisão e sem sombra, com PointLight de Range 8 e cor (190,255,150).
- Base aleatória: x e z de -38 a 38 e y de 1,8 a 4,8 (Random 5).
- Movimento: a cada Heartbeat, desloca-se em torno da base com amplitudes 3,2 em X e Z e 0,9 em Y, em seno e cosseno com frequências 0,45; 0,9; 0,38 e fases individuais.
- Piscar: `s = (0,5 + 0,5 * sin(t * f * 1,7 + a * 3))^3`; o brilho da luz vai de 0,1 a 2,3 e a transparência da peça de 0,85 a 0 conforme `s`.
- As posições são atualizadas em lote com `workspace:BulkMoveTo`.

## Contexto
- Foram criados na fase inicial do campo noturno, quando a cena era uma planície de grama; continuam no script, mas com a vila e o fog, a área de ±38 studs em torno da origem cobre só o centro da praça (sobre a fonte e o piso).

## Exceções e limites
- A luz verde dos vagalumes tinge as pedras de verde perto de cada um; na noite em breu ela é visível a distância.
- Se os vagalumes precisarem ficar só em áreas de grama, mudar `base` para o anel externo (r de 92 a 150).

## Revisão - parados dentro da casa
- O laço de `Heartbeat` dos vagalumes passou a começar com `if noInterior() then return end`, a mesma guarda que a grama já usava (a função lê o atributo `InteriorAtivo` do Workspace, que vale `true` enquanto o jogador está dentro da casa da cobertura; ver Casa da cobertura - Mundo mantido carregado ao entrar e sair).
- Motivo: dentro da casa a câmera fica a mais de 2.000 studs da vila, e as 45 peças e as 45 luzes continuavam a ser movidas e reescritas (`BulkMoveTo`, `Brightness`, `Transparency`) a cada quadro, sem que ninguém as visse.
- Teste em Play: com o atributo em `true` um vagalume ficou parado durante um segundo; com `false` voltou a se mover. O trecho "Movimento" acima vale quando o jogador está na vila.

## Relacionados
- Grama - Script GramaViva
- Iluminação - Configuração final da noite
- Vila Medieval - Varredura geral de bugs
