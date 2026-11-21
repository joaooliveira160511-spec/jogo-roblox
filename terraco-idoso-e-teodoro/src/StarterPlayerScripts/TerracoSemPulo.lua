-- TerracoSemPulo: no terraco da casa da cobertura (a varanda da rua Norte) o jogador nao pode pular.
-- Pular ali empurra o personagem contra a barreira invisivel (BarreiraTerraco) e a faz falhar. Enquanto o centro do personagem
-- esta dentro da caixa do terraco, o estado Jumping do Humanoid fica desligado, JumpPower e JumpHeight vao a zero e o salto
-- automatico do celular e desligado; ao sair da caixa (ou quando o mundo e descarregado ao entrar na casa) tudo volta ao que era.
-- Tudo no cliente; nada replica.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local jogador = Players.LocalPlayer

-- caixa do terraco no espaco local do Model CasaNorteCobertura (frente = -Z local; x lateral; y altura).
-- O piso do terraco fica em y 22; a barreira vai de 21 a 46; z de -15,4 (face externa da parede da frente) a -2,0 (parede da sala).
local CAIXA_MIN = Vector3.new(-12.2, 21.0, -15.4)
local CAIXA_MAX = Vector3.new(12.2, 47.0, -2.0)
local INTERVALO = 0.1 -- segundos entre verificacoes

local casa -- Model da casa, procurado de novo quando some (o mundo e descarregado ao entrar)
local function acharCasa()
	if casa and casa:IsDescendantOf(workspace) then return casa end
	local vila = workspace:FindFirstChild("Vila")
	local casas = vila and vila:FindFirstChild("Casas")
	casa = casas and casas:FindFirstChild("CasaNorteCobertura") or nil
	return casa
end

local function noTerraco(pos)
	local c = acharCasa()
	if not c then return false end
	local p = c:GetPivot():PointToObjectSpace(pos)
	return p.X >= CAIXA_MIN.X and p.X <= CAIXA_MAX.X
		and p.Y >= CAIXA_MIN.Y and p.Y <= CAIXA_MAX.Y
		and p.Z >= CAIXA_MIN.Z and p.Z <= CAIXA_MAX.Z
end

local travado -- { hum, estado, poder, altura, auto } enquanto o pulo esta desligado

local function travar(hum)
	if travado and travado.hum == hum then return end
	travado = {
		hum = hum,
		estado = hum:GetStateEnabled(Enum.HumanoidStateType.Jumping),
		poder = hum.JumpPower,
		altura = hum.JumpHeight,
		auto = hum.AutoJumpEnabled,
	}
	hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	hum.JumpPower = 0
	hum.JumpHeight = 0
	hum.AutoJumpEnabled = false
end

local function destravar()
	local t = travado
	travado = nil
	if not t or not t.hum.Parent then return end -- o personagem anterior sumiu: o novo ja vem com os valores padrao
	t.hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, t.estado)
	t.hum.JumpPower = t.poder
	t.hum.JumpHeight = t.altura
	t.hum.AutoJumpEnabled = t.auto
end

local acumulado = 0
RunService.Heartbeat:Connect(function(dt)
	acumulado += dt
	if acumulado < INTERVALO then return end
	acumulado = 0

	local char = jogador.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not (hum and hrp) or hum.Health <= 0 then
		travado = nil
		return
	end
	if travado and travado.hum ~= hum then travado = nil end

	if noTerraco(hrp.Position) then
		travar(hum)
	elseif travado then
		destravar()
	end
end)
