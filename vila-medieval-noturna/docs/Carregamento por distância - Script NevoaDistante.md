---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, streaming, neblina, script]
---
# Carregamento por distância - Script NevoaDistante
Índice: Jogos - Gerais

## Conceito
- LocalScript em `StarterPlayer.StarterPlayerScripts.NevoaDistante`. A cada 0,4 s ele compara a distância (no plano XZ) entre a câmera e o centro de cada "unidade" e remove do mundo (`Parent = nil`) as unidades além de 160 studs, recolocando-as quando ficam a menos de 140.
- Esse descarregamento é local ao cliente; o servidor continua com todas as peças.

## Unidades controladas
- Models filhos de `Workspace.Vila.Casas`, `Lampioes`, `Mobiliario` e `Pedras` (posição por `GetPivot().Position`).
- Peças da pasta `Praca` chamadas "Rua" e "MeioFioRua".
- Não são controlados: o piso e o meio-fio da praça, a fonte, os adereços e os detalhes (pedregulhos e rochas).
- A grama tem controle próprio, por células (ver Grama - Script GramaViva).

## Código
```lua
-- NevoaDistante: a neblina (Lighting.FogEnd) esconde o que está longe; aqui o que está além
-- dela também deixa de ser carregado, e volta quando o jogador caminha em direção a isso.
-- A neblina em si acompanha a câmera automaticamente.

local camera = workspace.CurrentCamera
local vila = workspace:WaitForChild("Vila")

local LOAD_DIST, UNLOAD_DIST = 140, 160
local units = {}

local function add(inst, parent, pos)
	units[#units + 1] = { inst = inst, parent = parent, pos = pos, loaded = true }
end

for _, nome in ipairs({ "Casas", "Lampioes", "Mobiliario", "Pedras" }) do
	local f = vila:WaitForChild(nome, 10)
	if f then
		for _, m in ipairs(f:GetChildren()) do
			if m:IsA("Model") then add(m, f, m:GetPivot().Position) end
		end
	end
end
local praca = vila:WaitForChild("Praca", 10)
if praca then
	for _, p in ipairs(praca:GetChildren()) do
		if p.Name == "Rua" or p.Name == "MeioFioRua" then add(p, praca, p.Position) end
	end
end

local function atualiza()
	local cp = camera.CFrame.Position
	for _, u in ipairs(units) do
		local dx, dz = u.pos.X - cp.X, u.pos.Z - cp.Z
		local d2 = dx * dx + dz * dz
		if u.loaded then
			if d2 > UNLOAD_DIST * UNLOAD_DIST then
				u.loaded = false
				u.inst.Parent = nil
			end
		elseif d2 < LOAD_DIST * LOAD_DIST then
			u.loaded = true
			u.inst.Parent = u.parent
		end
	end
end

while true do
	atualiza()
	task.wait(0.4)
end
```

## Observações
- As distâncias LOAD/UNLOAD devem ser mantidas iguais às da grama e coerentes com o FogEnd (135 studs).
- Se novos Models forem adicionados às pastas citadas depois do início do jogo, o script não os vê; ele monta a lista uma vez.

## Models novos e pivôs
- O script usa `GetPivot()` uma única vez, ao iniciar. Models criados depois (casas, postes, pedras e mobiliário da expansão) precisam de `WorldPivot` explícito, senão chegam ao cliente vazios, com o pivô na origem, e são descarregados longe do centro (ver Carregamento por distância - Pivôs dos Models novos). O script em si não foi alterado.

## Luzes dos Models descarregados
- Quando o script tira um Model do mundo (`Parent = nil`) e o devolve, as peças com a tag `Luz` saem e voltam ao DataModel; o `LuzesCliente` as registra de novo pelos sinais da tag, aplicando o estado certo. O brilho-base de cada PointLight fica guardado numa tabela de chaves fracas, para não ser lido de um valor já animado (ver Luzes - Animação no cliente e falhas de carregamento).
- Os Models de pedra do passeio da muralha têm 36 pedras, pequenos o bastante para o descarregamento por posição do pivô (ver Passeio da muralha - Lajes, pedras e postes).

## Script desativado
- O script `NevoaDistante` está com `Enabled = false`: nenhum Model é mais descarregado por distância, e o mapa inteiro fica carregado no cliente. O código e as observações acima descrevem o comportamento quando ele é reativado. A nota de neblina (em Relacionados) descreve o que mudou junto: fog, streaming e grama.

## Revisão - guarda do interior
- Dentro da casa da cobertura a câmera fica a mais de 2000 studs da vila, e este laço descarregaria todas as casas; na saída elas voltariam de uma só vez, junto com as luzes (tudo escuro e aparecendo tarde). O script (2010 bytes) ganhou, entre a função `atualiza` e o laço final, a leitura do atributo `InteriorAtivo` do Workspace, que o `CasaCobertura` mantém em `true` enquanto o jogador está dentro (ver Casa da cobertura - Mundo mantido carregado ao entrar e sair). O trecho final do script passa a ser:

```lua
-- Dentro da casa da cobertura a câmera fica a mais de 2000 studs da vila e este laço descarregaria todas as casas; na saída elas
-- voltariam de uma só vez, junto com as luzes (tudo escuro e aparecendo tarde). O CasaCobertura mantém o mundo carregado e marca o
-- interior no atributo InteriorAtivo: enquanto ele vale true nada é descarregado; ao voltar a false, uma passada imediata.
local function noInterior() return workspace:GetAttribute("InteriorAtivo") == true end
workspace:GetAttributeChangedSignal("InteriorAtivo"):Connect(function()
	if not noInterior() then atualiza() end
end)

while true do
	if not noInterior() then atualiza() end
	task.wait(0.4)
end
```

- O script continua com `Enabled = false`; a guarda vale se ele for reativado.

## Relacionados
- Neblina - Parâmetros e comportamento
- Roblox Studio - Streaming e SurfaceGui à distância
