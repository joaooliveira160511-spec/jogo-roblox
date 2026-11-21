---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, luzes, cliente, desempenho, script]
---
# Luzes - Otimização do LuzesCliente
Índice: [[Jogos - Gerais]]

## Conceito
- O `LuzesCliente` (`StarterPlayer.StarterPlayerScripts`) anima as 3.021 peças com tag `Luz` da vila (870 `PointLight` e 2.732 `Decal` de janela). A versão anterior percorria todas a cada 0,05 s e escrevia `Brightness` e `Transparency` em cada uma; era o maior custo de script medido no cliente (ver [[Vila Medieval - Desempenho e contagem de peças]]).
- A versão otimizada mantém a mesma função de tempo (`alvo`) e o mesmo visual; só muda quando e quanto se escreve nas propriedades. A original ficou em `ServerStorage.LuzesCliente_v1` (LocalScript desligado).

## Mudanças
1. **Passadas fatiadas**: os itens ficam também numa lista; a cada `Heartbeat` o script continua a passada em andamento por, no máximo, 2 ms de CPU (`ORCAMENTO`) e retoma no quadro seguinte de onde parou (`cursor`). Isso elimina o pico de um tick único e limita o custo por quadro.
2. **Passadas a 20 Hz**: uma nova passada só começa 0,05 s depois do início da anterior (`PASSADA`), como na versão original; se a passada demora mais, a seguinte começa logo.
3. **Escrita só quando muda**: `Brightness` só é escrito se a diferença para o último valor passa de 1,5% do brilho-base (`LIMIAR_LUZ`), e `Transparency`, se passa de 0,01 (`LIMIAR_VELA`). Mudanças de estado (liga e desliga, material e cor) continuam imediatas e zeram o cache.
4. **Menos atualização longe da câmera**: até 140 studs o item é atualizado a cada passada; de 140 a 260, a cada 3; de 260 a 450, a cada 8; além de 450 não é atualizado, como antes. A distância só é recalculada quando chega a vez do item.
5. **Remoção segura**: o sinal de remoção da tag marca o item como `morto`; a passada o tira da lista por troca com o último.

## Resultado medido
- Em Play no Studio, o custo de script no `Heartbeat` (`Stats.HeartbeatTimeMs`, que não é limitado pelo teto de 15 fps), acima da referência sem nenhum script de luz (1,65 ms):

| Versão | Média | p90 | Acima da referência |
|---|---|---|---|
| Original | 5,19 ms | 6,41 ms | cerca de 3,5 ms |
| Fatiada (sem limite de 20 Hz) | 3,63 ms | 3,91 ms | cerca de 2,0 ms |
| Atual | 3,23 ms | 4,02 ms | cerca de 1,6 ms |

- Redução de cerca de 55% do custo do script nas condições do Studio (cerca de 13 fps). O limite de 20 passadas por segundo só ajuda de fato com mais fps; o ganho a 60 fps não foi medido.
- Comportamento conferido em Play, com amostras por quadro: poste ligado oscilou de 0,86 a 1,28 (base 1,25); poste enfraquecido oscilou de 0,41 a 0,55 (base 0,575), respeitando o brilho reduzido; poste piscando ficou desligado em 9 de 199 quadros; poste apagado ficou fixo e desligado; a `Transparency` de uma janela ligada variou de 0,30 a 0,36. Console sem erros.
- O micro-benchmark anterior (cerca de 13 ms por tick) superestimou o custo: forçava escrita de valores sempre diferentes. O custo real da versão original foi o da tabela.

## Como reverter
- Desligar ou apagar o `LuzesCliente` atual e copiar `ServerStorage.LuzesCliente_v1` para `StarterPlayer.StarterPlayerScripts` com o nome `LuzesCliente` e `Enabled = true`. O brilho-base de cada luz vem do `PointLight` gravado em Edit, então os lampiões enfraquecidos seguem valendo (ver [[Postes e lampiões - Lampiões de luz fraca]]).

## Código
```lua
-- LuzesCliente: anima as luzes da vila só no cliente (piscar fraco das casas e dos postes, tremor de vela).
-- O servidor só define o estado inicial (atributos Estado e Grupo); nenhuma mudança por quadro é replicada,
-- o que evita o atraso e as falhas de carregamento das luzes quando há centenas delas.
-- Os Models que o NevoaDistante descarrega e recarrega voltam a ser registrados pelo sinal de tag.
--
-- Versão otimizada (a anterior está em ServerStorage.LuzesCliente_v1): o trabalho é fatiado por quadro,
-- a propriedade só é escrita quando o valor muda de forma perceptível e o que está longe é atualizado menos vezes.
local CS = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
local WARM = Color3.fromRGB(255, 112, 28)
local DARK = Color3.fromRGB(16, 20, 28)
local DIST = 450 -- sem neblina: anima a vila inteira (raio de cerca de 375)

local ORCAMENTO = 0.002 -- segundos de CPU por quadro gastos na animação; o que sobra fica para o quadro seguinte
local PERTO, MEDIO = 140, 260 -- faixas de distância da câmera, em studs
local CICLO_MEDIO, CICLO_LONGE = 3, 8 -- a distância média e longa, o item só é atualizado a cada tantas passadas
local LIMIAR_LUZ = 0.015 -- fração do brilho-base abaixo da qual a escrita de Brightness é pulada
local LIMIAR_VELA = 0.01 -- diferença de Transparency abaixo da qual a escrita é pulada
local PASSADA = 0.05 -- intervalo mínimo entre o início de duas passadas completas (20 por segundo, como na versão anterior)

local itens = {}
local lista = {} -- os mesmos itens em array, para percorrer em fatias
local cursor = 1
local bases = setmetatable({}, { __mode = "k" }) -- brilho original de cada luz, mesmo depois de descarregada e recarregada

local function semente(s)
	local h = 7
	for i = 1, #s do h = (h * 31 + s:byte(i)) % 100003 end
	return h
end

-- devolve (acesa, fator de brilho) de um item no instante t
local function alvo(it, t)
	local e = it.estado
	if e == "apagada" then return false, 0 end
	local n = math.noise(t * 1.5, it.seed * 0.37 + 0.31)
	if e ~= "piscando" then return true, 0.86 + 0.28 * n end
	-- piscando: luz fraca; longos trechos estáveis e depois uma rajada de falhas, às vezes com apagão
	local P = 7 + it.seed % 6
	local u = (t + it.fase) % P
	local f = 0.64 + 0.2 * n
	local rajada = 2.4
	if u > P - rajada then
		local s = u - (P - rajada)
		local ciclo = math.floor((t + it.fase) / P)
		if math.noise(s * 9, it.seed * 0.11 + ciclo + 0.5) < -0.1 then return false, 0 end
		if (ciclo + it.seed) % 4 == 0 and s > rajada * 0.55 then return false, 0 end
		f *= 0.45 + 0.4 * (math.noise(s * 5, ciclo + 3.3) + 1) / 2
	end
	return true, f
end

-- aplica o estado; só escreve na propriedade quando a diferença é perceptível (cada escrita custa caro)
local function aplica(it, on, f)
	if on ~= it.on then
		it.on = on
		it.ultB, it.ultT = nil, nil
		if not it.vela then
			it.part.Material = on and Enum.Material.Neon or Enum.Material.Glass
			it.part.Color = on and WARM or DARK
		end
		if it.luz then it.luz.Enabled = on end
	end
	if on then
		if it.luz then
			local b = it.base * f
			if not it.ultB or math.abs(b - it.ultB) > it.base * LIMIAR_LUZ then
				it.ultB = b
				it.luz.Brightness = b
			end
		end
		if it.vela then
			local tr = math.clamp(0.64 - f * 0.4, 0.3, 0.55)
			if not it.ultT or math.abs(tr - it.ultT) > LIMIAR_VELA then
				it.ultT = tr
				it.vela.Transparency = tr
			end
		end
	elseif it.vela and it.ultT ~= 1 then
		it.ultT = 1
		it.vela.Transparency = 1
	end
end

local function registra(inst)
	if itens[inst] or not inst:IsA("BasePart") then return end
	local h = semente(tostring(inst:GetAttribute("Grupo") or inst.Name))
	local luz = inst:FindFirstChildOfClass("PointLight")
	if luz and not bases[luz] then bases[luz] = luz.Brightness end
	local it = {
		part = inst, estado = inst:GetAttribute("Estado") or "ligada", seed = h, fase = (h % 97) / 97 * 10,
		luz = luz, base = luz and bases[luz] or 0, vela = inst:FindFirstChildOfClass("Decal"),
		n = h % CICLO_LONGE, ciclo = 1, morto = false,
	}
	itens[inst] = it
	lista[#lista + 1] = it
	aplica(it, alvo(it, os.clock()))
end

for _, inst in ipairs(CS:GetTagged("Luz")) do registra(inst) end
CS:GetInstanceAddedSignal("Luz"):Connect(registra)
CS:GetInstanceRemovedSignal("Luz"):Connect(function(inst)
	local it = itens[inst]
	if it then
		it.morto = true -- sai da lista na próxima passada
		itens[inst] = nil
	end
end)

-- a cada quadro continua a passada atual dentro do orçamento de tempo; uma nova passada só começa PASSADA segundos
-- depois do início da anterior. A distância de um item só é recalculada quando chega a vez dele (a cada "ciclo" visitas).
local visitados = 0 -- itens já percorridos na passada atual
local emPassada = false
local inicioPassada = 0

RunService.Heartbeat:Connect(function()
	local t = os.clock()
	if not emPassada then
		if #lista == 0 or t - inicioPassada < PASSADA then return end
		emPassada, visitados, inicioPassada = true, 0, t
	end
	local cp = camera.CFrame.Position
	local limite = t + ORCAMENTO
	local feitos = 0
	while visitados < #lista do
		if cursor > #lista then cursor = 1 end
		local it = lista[cursor]
		if it.morto then
			local ultimo = #lista
			lista[cursor] = lista[ultimo]
			lista[ultimo] = nil
		else
			it.n += 1
			if it.n >= it.ciclo then
				it.n = 0
				local d = (it.part.Position - cp).Magnitude
				if d < DIST then
					it.ciclo = d < PERTO and 1 or (d < MEDIO and CICLO_MEDIO or CICLO_LONGE)
					aplica(it, alvo(it, t))
				else
					it.ciclo = CICLO_LONGE -- fora do alcance: só reavalia a distância de vez em quando
				end
			end
			cursor += 1
			visitados += 1
			feitos += 1
			if feitos % 40 == 0 and os.clock() > limite then return end -- continua no próximo quadro
		end
	end
	emPassada = false
end)
```

## Exceções e limites
- A medição foi feita no Studio, com teto de 15 fps e com servidor e cliente no mesmo processo; os números absolutos num cliente real podem ser menores. A redução relativa é a informação útil.
- Um item longe da câmera demora até 8 passadas (cerca de 0,4 s) para ser reclassificado como próximo quando a câmera se aproxima ou salta de lugar.
- Itens a mais de 450 studs continuam sem animação, como na versão anterior.
- As sombras (66 mil peças com `CastShadow`) e a quantidade de luzes ativas não foram alteradas por esta mudança.

## Relacionados
- [[Luzes - Animação no cliente e falhas de carregamento]]
- [[Luzes - Sistema de estados]]
- [[Vila Medieval - Desempenho e contagem de peças]]
- [[Postes e lampiões - Lampiões de luz fraca]]
