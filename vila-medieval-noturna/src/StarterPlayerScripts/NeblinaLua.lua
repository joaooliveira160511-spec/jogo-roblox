-- NeblinaLua: uma neblina bem fina, em volta da direção da Lua, para suavizá-la sem escondê-la.
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local part = Instance.new("Part")
part.Name = "NeblinaDaLua"
part.Anchored = true
part.CanCollide = false
part.CanQuery = false
part.CanTouch = false
part.Transparency = 1
part.Size = Vector3.new(170, 26, 170)
part.Parent = workspace

local e = Instance.new("ParticleEmitter")
e.Texture = "rbxasset://textures/particles/smoke_main.dds"
e.Shape = Enum.ParticleEmitterShape.Box
e.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
e.Rate = 1.4
e.Lifetime = NumberRange.new(30, 40)
e.Speed = NumberRange.new(0.4, 0.9)
e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 70), NumberSequenceKeypoint.new(1, 110) })
e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.95), NumberSequenceKeypoint.new(0.8, 0.94), NumberSequenceKeypoint.new(1, 1) })
e.Color = ColorSequence.new(Color3.fromRGB(150, 170, 215))
e.LightEmission = 0.1
e.LightInfluence = 0
e.Parent = part

local moonDir = Lighting:GetMoonDirection().Unit
RunService.RenderStepped:Connect(function()
	local cp = camera.CFrame.Position
	part.Position = cp + moonDir * 120 + Vector3.new(0, 8, 0)
end)
