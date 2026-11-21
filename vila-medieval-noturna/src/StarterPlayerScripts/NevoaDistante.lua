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
