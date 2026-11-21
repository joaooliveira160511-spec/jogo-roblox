-- FonteFalha: Script filho do Model "Fonte" (criado por ConstrutorVilaGrande.M.fonte).
-- Faz a fonte falhar de tempos em tempos: engasga, perde pressão ou pinga, e volta gradualmente.
-- Cada nível (Nivel 0 a 3) tem seu próprio ciclo independente.

local fonte = script.Parent
local niveis = {}
for _, d in ipairs(fonte:GetDescendants()) do
	if d:IsA("ParticleEmitter") then
		local n = d:GetAttribute("Nivel")
		if n then
			niveis[n] = niveis[n] or {}
			table.insert(niveis[n], { e = d, base = d.Rate })
		end
	end
end
local rng = Random.new()

local function pressao(list, f)
	for _, it in ipairs(list) do it.e.Rate = math.max(it.base * f, 0.5) end
end
local function liga(list, on)
	for _, it in ipairs(list) do it.e.Enabled = on end
end

-- cada nível (0 = jato central, 1..3 = bicas das bacias) falha por conta própria
local function ciclo(n, minOn, maxOn)
	local list = niveis[n]
	if not list then return end
	task.spawn(function()
		task.wait(rng:NextNumber(0, 6))
		while true do
			pressao(list, 1); liga(list, true)
			task.wait(rng:NextNumber(minOn, maxOn))
			local tipo = rng:NextInteger(1, 3)
			if tipo == 1 then
				for _ = 1, rng:NextInteger(4, 8) do
					pressao(list, rng:NextNumber(0.3, 1)); liga(list, true)
					task.wait(rng:NextNumber(0.08, 0.35))
					liga(list, false)
					task.wait(rng:NextNumber(0.1, 0.55))
				end
				task.wait(rng:NextNumber(2, 6))
			elseif tipo == 2 then
				for i = 10, 3, -1 do pressao(list, i / 10); task.wait(0.2) end
				task.wait(rng:NextNumber(3, 7))
			else
				for i = 10, 1, -1 do pressao(list, i / 10); task.wait(0.18) end
				liga(list, false)
				local pingo = list[rng:NextInteger(1, #list)]
				pingo.e.Rate = 4; pingo.e.Enabled = true
				task.wait(rng:NextNumber(3, 6))
				pingo.e.Enabled = false
			end
			liga(list, true)
			for i = 1, 10 do
				pressao(list, i / 10)
				if rng:NextNumber() < 0.2 then liga(list, false); task.wait(0.12); liga(list, true) end
				task.wait(0.12)
			end
		end
	end)
end
ciclo(0, 6, 14)
ciclo(3, 10, 22)
ciclo(2, 12, 26)
ciclo(1, 14, 30)
