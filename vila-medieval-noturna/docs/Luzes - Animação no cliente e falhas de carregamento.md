---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, luzes, cliente, replicacao, script]
---
# Luzes - Animação no cliente e falhas de carregamento
Índice: [[Jogos - Gerais]]

## Conceito
- A animação das luzes (piscar e tremor de chama) roda inteira no cliente, no LocalScript `StarterPlayer.StarterPlayerScripts.LuzesCliente`. O servidor (`ServerScriptService.LuzesDaVila`) só aplica o estado inicial lido dos atributos `Estado` e `Grupo`; depois disso não muda mais nada por quadro.

## Problema da versão anterior
- O script do servidor alterava, em laço, propriedades de todas as luzes ativas: um laço de Heartbeat a cada 0,1 s escrevia `Brightness` e `Transparency` em todos os itens acesos, e cada grupo "piscando" tinha uma corrotina que apagava e acendia o grupo várias vezes por rajada (mudando Material, Color, Enabled, Brightness e Transparency).
- Com a vila ampliada eram 1.280 itens com a tag `Luz`, dos quais 421 acesos ou piscando: pelo menos cerca de 4.200 escritas por segundo, todas replicadas do servidor para cada cliente. Replicação nessa escala atrasa e perde atualizações, e as luzes aparecem tarde, travadas ou fora de fase.
- O estado inicial recebido pelo cliente estava certo (todas as luzes ligadas e apagadas conferiam com o atributo `Estado`); a falha estava na animação, não nos dados.
- O tráfego real de rede não foi medido; a causa foi identificada pela análise do código.

## Solução
- O cliente registra cada peça com a tag `Luz` (as já presentes e as que chegam por `GetInstanceAddedSignal`) e remove as que saem (`GetInstanceRemovedSignal`). O descarregamento por distância (ver [[Carregamento por distância - Script NevoaDistante]]) tira Models do mundo e os devolve; o sinal da tag os registra de novo e a luz volta ao estado certo.
- O brilho-base de cada PointLight é guardado numa tabela de chaves fracas, para que ele não seja lido de um valor já animado depois de um recarregamento.
- Só se anima o que está a menos de 170 studs da câmera, a cada 0,05 s. O estado de cada item é uma função do tempo (`os.clock()`), do estado e de uma semente tirada do nome do grupo; assim os itens do mesmo grupo piscam juntos e não é preciso nenhuma corrotina.
- Estados: **apagada** (desligada), **ligada** (acesa, fator de brilho 0,86 + 0,28 de ruído, tremor de chama) e **piscando** (fraca: fator 0,64 + 0,2 de ruído; período de 7 a 12 s com uma rajada final de 2,4 s em que o ruído apaga a luz por instantes e, num ciclo a cada quatro, a luz apaga de vez no fim da rajada).
- Itens com Decal "Vela" (janelas) mudam só a transparência do Decal e a PointLight; itens sem Decal (lanternas dos postes) trocam também Material (Neon ou Glass) e cor.

## Efeito nas casas
- Casas novas: ligada com probabilidade `0,12 - 0,05*t`, piscando `0,30 - 0,03*t` e apagada no restante; ruínas a partir do nível 2 ficam sempre apagadas (ver [[Casas das ruas - Fileiras variadas e luzes apagadas]]).
- As casas antigas das ruas cardeais foram sorteadas de novo com as mesmas probabilidades (Random 777), exceto as com entulho. Cena final: 14 grupos de casa ligados, 30 piscando e 133 apagados.
- A luz de janela continua fraca (alcance 13, brilho-base 0,3); piscando, o brilho efetivo fica por volta de 0,1 a 0,25.

## Sombras
- Só os 28 postes originais mantêm `Shadows = true`. As 108 luzes dos postes novos (ruas, praças, ruas laterais e muralha) foram colocadas sem sombra, para reduzir o custo de renderização (ver [[Postes e lampiões - Continuação nas ruas e nas praças circulares]]).

## Código
```lua
-- LuzesCliente: anima as luzes da vila só no cliente (piscar fraco das casas e dos postes, tremor de vela).
-- O servidor só define o estado inicial (atributos Estado e Grupo); nenhuma mudança por quadro é replicada,
-- o que evita o atraso e as falhas de carregamento das luzes quando há centenas delas.
-- Os Models que o NevoaDistante descarrega e recarrega voltam a ser registrados pelo sinal de tag.
local CS = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
local WARM = Color3.fromRGB(255, 112, 28)
local DARK = Color3.fromRGB(16, 20, 28)
local DIST = 450 -- sem neblina: anima a vila inteira (raio de cerca de 375)

local itens = {}
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

local function aplica(it, on, f)
	if on ~= it.on then
		it.on = on
		if not it.vela then
			it.part.Material = on and Enum.Material.Neon or Enum.Material.Glass
			it.part.Color = on and WARM or DARK
		end
		if it.luz then it.luz.Enabled = on end
	end
	if on then
		if it.luz then it.luz.Brightness = it.base * f end
		if it.vela then it.vela.Transparency = math.clamp(0.64 - f * 0.4, 0.3, 0.55) end
	elseif it.vela then
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
	}
	itens[inst] = it
	aplica(it, alvo(it, os.clock()))
end

for _, inst in ipairs(CS:GetTagged("Luz")) do registra(inst) end
CS:GetInstanceAddedSignal("Luz"):Connect(registra)
CS:GetInstanceRemovedSignal("Luz"):Connect(function(inst) itens[inst] = nil end)

local acc = 0
RunService.Heartbeat:Connect(function(dt)
	acc += dt
	if acc < 0.05 then return end
	acc = 0
	local cp = camera.CFrame.Position
	local t = os.clock()
	for inst, it in pairs(itens) do
		if (inst.Position - cp).Magnitude < DIST then
			aplica(it, alvo(it, t))
		end
	end
end)
```

```lua
-- LuzesDaVila (ServerScriptService): estado inicial das luzes (atributo "Estado": ligada, piscando, apagada).
-- A animação (piscar e tremor de vela) roda só no cliente, em StarterPlayerScripts.LuzesCliente;
-- aqui nada muda por quadro, para não replicar milhares de alterações por segundo.
-- Cada grupo (atributo "Grupo") acende e apaga junto, pois todos os itens do grupo têm o mesmo Estado.
local CS = game:GetService("CollectionService")

local WARM = Color3.fromRGB(255, 112, 28)
local DARK = Color3.fromRGB(16, 20, 28)

for _, inst in ipairs(CS:GetTagged("Luz")) do
	local on = inst:GetAttribute("Estado") ~= "apagada"
	local vela = inst:FindFirstChildOfClass("Decal")
	if vela then
		vela.Transparency = on and 0.4 or 1
	else
		inst.Material = on and Enum.Material.Neon or Enum.Material.Glass
		inst.Color = on and WARM or DARK
	end
	local luz = inst:FindFirstChildOfClass("PointLight")
	if luz then luz.Enabled = on end
end
```

## Sem neblina e sem descarregamento
- Com a neblina e o descarregamento por distância desligados, o mapa inteiro fica carregado e as luzes distantes passam a ser visíveis; por isso o raio de animação subiu de 170 para 450 studs, o que cobre a vila inteira. As luzes não saem mais do mundo, então o registro por sinal de tag só age no início do jogo (ver [[Neblina - Parâmetros e comportamento]]).
- Texto da seção "Solução" acima que fala de 170 studs e de recarregamento descreve a versão anterior.

## Verificação
- Em Play, as luzes "piscando" variaram de brilho e apagaram por instantes ao longo de 10 s; as "ligadas" mostraram o tremor de chama; o console ficou sem erros.

## Revisão - versão otimizada
- O código acima é a versão anterior. O `LuzesCliente` atual percorre a lista de luzes em fatias de até 2 ms por quadro, a 20 passadas por segundo, só escreve `Brightness` e `Transparency` quando a mudança é perceptível e atualiza menos vezes o que está longe da câmera; a cópia da original está em `ServerStorage.LuzesCliente_v1`. Código completo, parâmetros e medições: ver [[Luzes - Otimização do LuzesCliente]].

## Relacionados
- [[Luzes - Sistema de estados]]
- [[Luzes - Script LuzesDaVila]]
- [[Janelas - Brilho de vela quadriculado]]
- [[Luzes das casas - Tons e intensidades]]
- [[Luzes - Otimização do LuzesCliente]]
