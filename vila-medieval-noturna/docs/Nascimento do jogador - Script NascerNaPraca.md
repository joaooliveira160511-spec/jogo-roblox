---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, spawn, script]
---
# Nascimento do jogador - Script NascerNaPraca
Índice: Jogos - Gerais

## Conceito
- O jogador deve nascer na praça, de frente para o Norte (direção -Z, onde está a rua principal), fora da fonte. Duas camadas garantem isso: o SpawnLocation e o script `NascerNaPraca`.

## SpawnLocation
- Posição (0, 1, 46), tamanho 6x1x6, `Transparency = 1`, `CanCollide = false`, orientado para -Z. O Decal do spawn também foi tornado transparente.
- A posição fica entre a fonte (raio de cerca de 32) e os postes da borda (raio 54,5), numa área livre.

## Script
- Script em `ServerScriptService.NascerNaPraca`: a cada CharacterAdded, espera o HumanoidRootPart, aguarda um frame e faz `PivotTo` para (0, 5, 44) olhando para -Z. O personagem cai e pousa sobre as pedras (altura de repouso do HumanoidRootPart em torno de 3,7).

```lua
-- Faz o personagem nascer sempre na praça (inclusive em "Play Here"), longe da fonte, de frente para o Norte (-Z).
local Players = game:GetService("Players")
local POS = Vector3.new(0, 5, 44)

local function posiciona(char)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if not hrp then return end
	task.wait()
	char:PivotTo(CFrame.lookAt(POS, POS + Vector3.new(0, 0, -1)))
end

local function aoEntrar(p)
	p.CharacterAdded:Connect(posiciona)
	if p.Character then task.spawn(posiciona, p.Character) end
end
Players.PlayerAdded:Connect(aoEntrar)
for _, p in ipairs(Players:GetPlayers()) do aoEntrar(p) end
```

## Por que o script
- No modo "Play Here" o Studio coloca o personagem no foco da câmera do editor; se a câmera estiver sobre a fonte, o jogador nasce dentro dela. O script ignora essa posição e sempre leva o jogador à praça.
- Se a câmera do editor estiver dentro da fonte e o personagem for criado por outro mecanismo, o script ainda corrige.

## Exceções e limites
- O ponto de nascimento deve permanecer livre de peças; a barraca mais próxima está em (±33, ±33) e os barris em torno de r = 56 a 57.
- Em um jogo com vários jogadores, todos nascem exatamente no mesmo ponto; seria preciso um pequeno deslocamento aleatório.

## Relacionados
- Roblox Studio - Modo Edit e modo Play
- Praça - Geometria e raios
