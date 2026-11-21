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
