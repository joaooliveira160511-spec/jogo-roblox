---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, grama, geracao]
---
# Grama - Geração das lâminas
Índice: Jogos - Gerais

## Conceito
- A grama não é terreno: é um conjunto de lâminas (WedgePart) criadas por script em `Workspace.Grama`, em duas pastas (Trecho1 = metade oeste, Trecho2 = metade leste). Na cena final são 7.683 lâminas num anel de r = 92 a 150, fora da vila.

## Lâmina
- WedgePart de tamanho (0,05; h; 0,22 + rand*0,12), com `h = 1,6 + max(noise(x*0,07; z*0,07), 0)*1,6 + rand*0,8` (de 1,6 a 4 studs).
- A cunha tem o lado vertical em +Z e a altura cai para -Z, o que dá uma lâmina pontuda.
- Posição: base em y = -0,1; rotação aleatória em Y e inclinação inicial de 0 a 0,28 rad; o centro da peça fica na metade da altura.
- Anchored, sem colisão, sem consulta, sem sombra, Massless.
- Material Neon (a cor é totalmente controlada e não depende de luz): HSV (0,40 + ruído*0,06 + rand*0,05; 0,62 + rand*0,15; 0,14 + rand*0,12 + max(ruído,0)*0,06), depois escurecida em 55% (Lerp para preto) para não brilhar no escuro.

## Distribuição
- Passo de grade 1,8 com jitter de ±0,99; só entram pontos com 92 < r < 150 e |x| > 11,5 e |z| > 11,5 (evita as ruas).
- Probabilidade de manter: `clamp((150 - r)/14, 0, 1) * clamp((r - 92)/4, 0,25, 1) * (patch > -0,12 and 0,85 or 0,12)`, onde `patch = noise(x*0,035; z*0,035)`; isso faz manchas de grama com bordas ralas, e a densidade cai perto do limite externo.
- 30% dos pontos geram uma segunda lâmina próxima.
- Construção em duas pastas, cada uma parentada ao final, com `task.wait()` entre as duas.

## Histórico
- Primeira versão: 5.600 lâminas em um quadrado de 90 x 90 ao redor da origem, com cores HSV mais claras (V de 0,5 a 0,8) e material Plastic, depois Neon. Ao criar a praça, essa grama foi apagada (ela cobria o piso).
- Segunda versão: anel de r = 118 a 176 com 12.000 lâminas na vila grande.
- Versão final: anel de r = 92 a 150 com 7.683 lâminas, na vila compacta.

## Exceções e limites
- O número de lâminas é pesado; o script GramaViva só anima e mantém carregadas as que estão a menos de 140 studs (ver Grama - Script GramaViva).
- Alterar o raio interno da grama exige recomeçar a geração; apagar as pastas Trecho1 e Trecho2 antes.

## Remoção posterior
- Depois da expansão pelas quatro direções, 3.136 lâminas que ficavam sob calçadas e casas novas foram removidas, e restaram 4.547 (ver Grama - Limpeza sob as construções novas).

## Revisão - relva nova no lugar das lâminas antigas
- As lâminas descritas acima (cunhas largas de `Neon`, em `Trecho1` e `Trecho2`) saíram de `Workspace.Grama`: as 1.263 que ainda restavam, secas, foram levadas para `ServerStorage.GramaAntiga`, sem apagar. No lugar entrou `Workspace.Grama.Relva`, com 3.035 tufos e 17.075 peças `Plastic`, em dois segmentos, num anel de 62 a 185 studs, plantada pelo módulo de geração (ver a nota da relva e a nota do módulo, em Relacionados).
- As seções acima valem como história da primeira versão. Em particular, o limite de 140 studs de animação e carregamento deixou de valer: a relva nova não é carregada nem descarregada por distância, e só a parte a menos de 34 studs da câmera se move.

## Relacionados
- Grama - Reflexo da Lua
- Terreno - Material Ground e altura real da superfície
- Grama - Relva densa em dois segmentos
- Módulo GeradorRelva - Código completo
