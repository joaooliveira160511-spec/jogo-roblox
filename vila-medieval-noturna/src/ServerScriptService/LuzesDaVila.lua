-- LuzesDaVila: luzes das casas, lampiões e barracas.
-- Estados (atributo "Estado"): ligada, piscando, apagada. Cada grupo (atributo "Grupo") acende e apaga junto.
-- Janelas têm um Decal "Vela" (brilho de vela no vidro); lanternas são Neon.

local CS = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local WARM = Color3.fromRGB(255, 112, 28)
local DARK = Color3.fromRGB(16, 20, 28)
local rng = Random.new()

local grupos = {}
for _, inst in ipairs(CS:GetTagged("Luz")) do
	local id = inst:GetAttribute("Grupo") or inst.Name
	local g = grupos[id]
	if not g then
		g = { id = id, estado = inst:GetAttribute("Estado"), itens = {}, on = true }
		grupos[id] = g
	end
	local luz = inst:FindFirstChildOfClass("PointLight")
	table.insert(g.itens, { part = inst, luz = luz, base = luz and luz.Brightness or 0, vela = inst:FindFirstChildOfClass("Decal") })
end

local function aplica(g, on, fator)
	g.on = on
	for _, it in ipairs(g.itens) do
		if it.vela then
			it.vela.Transparency = on and (0.4 + (1 - (fator or 1)) * 0.5) or 1
		else
			it.part.Material = on and Enum.Material.Neon or Enum.Material.Glass
			it.part.Color = on and WARM or DARK
		end
		if it.luz then
			it.luz.Enabled = on
			it.luz.Brightness = it.base * (fator or 1)
		end
	end
end

for _, g in pairs(grupos) do
	if g.estado == "apagada" then
		aplica(g, false)
	elseif g.estado == "piscando" then
		-- estável por um tempo, depois uma rajada de falhas; às vezes apaga de vez por instantes
		task.spawn(function()
			task.wait(rng:NextNumber(0, 5))
			while true do
				aplica(g, true)
				task.wait(rng:NextNumber(2, 9))
				for _ = 1, rng:NextInteger(3, 9) do
					aplica(g, false)
					task.wait(rng:NextNumber(0.04, 0.25))
					aplica(g, true, rng:NextNumber(0.4, 1))
					task.wait(rng:NextNumber(0.04, 0.3))
				end
				if rng:NextNumber() < 0.3 then
					aplica(g, false)
					task.wait(rng:NextNumber(0.8, 2.5))
				end
			end
		end)
	else
		aplica(g, true)
	end
end

-- chama de vela: tremulado suave na luz e no brilho do vidro
local acc = 0
RunService.Heartbeat:Connect(function(dt)
	acc += dt
	if acc < 0.1 then return end
	acc = 0
	local t = os.clock()
	for id, g in pairs(grupos) do
		if g.estado ~= "apagada" and g.on then
			local f = 0.86 + 0.28 * math.noise(t * 1.5, #id * 3.7)
			for _, it in ipairs(g.itens) do
				if it.luz then it.luz.Brightness = it.base * f end
				if it.vela then it.vela.Transparency = math.clamp(0.64 - f * 0.4, 0.3, 0.5) end
			end
		end
	end
end)
