-- LuzesDaVila: estado inicial das luzes (atributo "Estado": ligada, piscando, apagada).
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
