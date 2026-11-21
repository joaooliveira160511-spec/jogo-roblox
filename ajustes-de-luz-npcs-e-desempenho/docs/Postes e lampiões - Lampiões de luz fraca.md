---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, vila-medieval, postes, lampioes, iluminacao, ambientacao]
---
# Postes e lampiões - Lampiões de luz fraca
Índice: [[Jogos - Gerais]]

## Conceito
- Alguns lampiões continuam acesos, mas com luz mais fraca, para reforçar a ambientação de vila em declínio sem recorrer ao estado `apagada`. O estado do poste não muda: a `Chama` segue com `Estado = ligada`, com o neon e o tremor de chama de sempre; só o `PointLight` perde brilho e alcance (ver [[Luzes - Sistema de estados]]).
- Foram enfraquecidos 18 dos 127 postes `ligada` com nome iniciado em `Poste` (originais, de reforço, de praça, de anel e de muralha).

## Parâmetros
- Brilho: de 1,25 para 35% a 55% do valor original (cerca de 0,44 a 0,69), sorteado por poste.
- Alcance: de 44 para 70% a 80% do original (cerca de 31 a 35 studs), sorteado por poste.
- Sorteio com semente fixa `20261105`; distância mínima de 38 studs (no plano) entre dois enfraquecidos, para que o efeito fique espalhado e não crie um trecho inteiro escuro.
- Restrição de escolha: um poste só entra se, com ele, no máximo 12 NPCs comuns ficam abaixo da iluminação mínima de 0,8 e nenhum dos 29 NPCs originais cai abaixo dela (ver [[NPCs da vila - Retirada de NPCs sem luz suficiente]]). Sem essa restrição, o mesmo sorteio com 24 postes deixaria 43 NPCs abaixo de 0,8.

## Postes enfraquecidos
- PosteRua52, PosteRua12, PosteRua58, PosteRua54, PosteRua22, PosteRua35, PosteRua53, PosteRua24, PosteRua57 e PosteRua56.
- PosteMuro20, PosteMuro3 e PosteMuro6.
- PosteCircOeste6, PosteCircLeste10 e PosteCircLeste12.
- PosteExtNorte1 e PosteAnelOesteNorte2.

## Como reverter
- Cada `Chama` enfraquecida guarda os atributos `Fraca = true`, `BrilhoOriginal` e `AlcanceOriginal`. Para restaurar um poste, basta devolver ao `PointLight` filho esses dois valores e remover os atributos.
- O `LuzesCliente` lê o brilho-base do `PointLight` ao registrar a peça, então o valor reduzido gravado em Edit é o que vale em Play (ver [[Luzes - Animação no cliente e falhas de carregamento]]). Nada no código das luzes precisou mudar.

## Exceções e limites
- A conferência foi numérica (a mesma conta de brilho * (1 - distância / alcance) da regra de iluminação) e por leitura das propriedades; uma inspeção visual em Play ainda não foi feita.
- O neon da chama não escurece junto com a luz: o lampião fraco ainda parece aceso de perto, mas ilumina menos o entorno. Se for preciso um aspecto mais apagado, é preciso mexer na cor ou na transparência da peça, e o `LuzesCliente` só reaplica material e cor quando o estado liga ou desliga.
- Rodar `IluminarRuas` com `gravar = true` apaga e recria os `PosteRua*`, o que devolve os postes de reforço enfraquecidos ao brilho padrão (ver [[Postes e lampiões - Reforço nas ruas escuras]]).

## Relacionados
- [[Postes e lampiões - Geometria e luz]]
- [[Postes e lampiões - Reforço nas ruas escuras]]
- [[Luzes - Sistema de estados]]
- [[NPCs da vila - Regra de iluminação e escolha das posições]]
- [[NPCs da vila - Retirada de NPCs sem luz suficiente]]
