---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulescript, cache]
---
# Roblox Studio - ModuleScript, require e cache
Índice: Jogos - Gerais

## Conceito
- O código de construção da vila fica em um ModuleScript (`ServerStorage.ConstrutorVilaGrande`) que devolve uma tabela `M` com funções (`casa`, `poste`, `praca`, `pedras`, `detalhes`, `fonte`, `aderecos`, `barril`, `caixa`, `banco`). Cada chamada de `execute_luau` faz `require` e usa as funções.

## O problema do cache
- `require` guarda o resultado da primeira execução. Se o código do módulo mudar depois (por `multi_edit` ou por `Source`), uma nova chamada de `require` no mesmo Studio ainda devolve a tabela antiga.
- Sintoma observado: após editar `praca` para raio 58, a chamada ainda criou um piso de 160 studs de diâmetro.

## A solução
- Antes de cada rodada de construção, clonar o módulo e dar `require` na cópia:

```lua
local SS = game.ServerStorage
local velho = SS:FindFirstChild("ConstrutorVilaGrande_run"); if velho then velho:Destroy() end
local copia = SS.ConstrutorVilaGrande:Clone()
copia.Name = "ConstrutorVilaGrande_run"
copia.Parent = SS
local V = require(copia)
```

- Nas chamadas seguintes da mesma rodada, `require(game.ServerStorage.ConstrutorVilaGrande_run)` reaproveita a cópia.

## Redefinição de funções
- O módulo mantém versões antigas de `praca`, `pedras`, `detalhes` e `fonte` no meio do arquivo e as redefine mais abaixo, antes de `return M`. Em Luau, a última definição de `M.nome` prevalece, por isso as versões finais ficam no fim do arquivo (ver Módulo ConstrutorVilaGrande - Visão geral e API).

## Exceções e limites
- Variáveis `local` do módulo (como a tabela de cores `C` e `M.variant`) são mutáveis e persistem na cópia durante a rodada. A função `fonte` apaga a entrada de `M.variant` para Cobblestone, o que afeta construções posteriores da mesma cópia.

## Revisão - reconstrução dos NPCs
- A mesma técnica de clonar os módulos e trocar as chamadas de `require` por `script.Parent.<módulo>` é usada para recriar os NPCs sem cache velho (ver NPCs da vila - Ferramentas de posicionamento e reconstrução). Mudar o `Source` de um módulo já requerido não atualiza o resultado de quem o requer pelo caminho original; isso apareceu quando papéis novos de `PapeisNPC` não eram vistos por `GeradorNPCs`.

## Relacionados
- Roblox Studio via MCP - Ferramentas e fluxo de trabalho
- Vila Medieval - Erros comuns e como evitar
- NPCs da vila - Ferramentas de posicionamento e reconstrução
