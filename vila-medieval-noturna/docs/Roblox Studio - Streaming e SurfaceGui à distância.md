---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, streaming, surfacegui]
---
# Roblox Studio - Streaming e SurfaceGui à distância
Índice: Jogos - Gerais

## Conceito
- O lugar do projeto tem `Workspace.StreamingEnabled = true`: o servidor só envia ao cliente as peças dentro de um raio. Isso afeta scripts de cliente e peças muito distantes.
- SurfaceGui sobre uma Part tem um alcance de renderização limitado.

## Observações medidas
- Uma Part com SurfaceGui a 2.200 e a 1.000 studs de distância não era desenhada em Play; a 200 studs era. Em modo Edit, a 2.200 studs era desenhada.
- No cliente, uma peça distante da Workspace pode não existir ainda (`workspace.Lua` era nil), embora exista no servidor.
- Para forçar a presença de um objeto distante, usar um Model com `ModelStreamingMode = Persistent`.
- Scripts de cliente que listam descendentes ao iniciar podem ver zero peças se elas ainda não foram transmitidas; no script GramaViva, a solução é esperar a contagem de lâminas estabilizar por um segundo antes de montar o cache.

## Consequências no projeto
- A Lua deixou de ser uma peça e passou a ser a textura do Sky, que não depende de streaming nem de distância (ver Lua - Textura no Sky).
- O descarregamento de peças distantes é feito por script de cliente, pois o raio de streaming não é ajustável (ver Carregamento por distância - Script NevoaDistante).

## Exceções e limites
- O raio de streaming padrão é grande o bastante (cerca de 1.024 studs) para que toda a vila (raio de cerca de 216 studs) esteja sempre presente no cliente.

## Relacionados
- Lua - Tentativas descartadas
- Roblox Studio via MCP - Limitações de permissão
