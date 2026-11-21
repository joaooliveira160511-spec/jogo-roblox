-- LuzesCliente: anima as luzes da vila só no cliente (piscar fraco das casas e dos postes, tremor de vela).
-- O servidor só define o estado inicial (atributos Estado e Grupo); nenhuma mudança por quadro é replicada.
-- Os Models que o carregamento por distância descarrega e recarrega voltam a ser registrados pelo sinal de tag.
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
