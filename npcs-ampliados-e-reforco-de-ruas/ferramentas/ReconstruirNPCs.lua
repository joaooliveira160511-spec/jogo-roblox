-- ReconstruirNPCs: recria os modelos de Workspace.NPCs em Edit. `require` guarda o codigo em cache, entao os
-- modulos sao CLONADOS para uma pasta temporaria, com as chamadas de require apontadas para as copias.
-- Uso: local R = require(clone); R.preparar() -> lista de specs; R.construir(inicio, fim, limpar); R.fim()
local SS = game:GetService("ServerStorage")
local RS = game:GetService("ReplicatedStorage")

local M = {}
local tmp, Construtor, specs

local function troca(src, a, b)
	local i, j = src:find(a, 1, true)
	assert(i, "nao achei: " .. a)
	return src:sub(1, i - 1) .. b .. src:sub(j + 1)
end

function M.preparar()
	if tmp then tmp:Destroy() end
	tmp = Instance.new("Folder"); tmp.Name = "_TmpNPCs"; tmp.Parent = SS
	for _, n in ipairs({ "PapeisNPC", "PosicoesNPC", "GeradorNPCs", "ElencoNPCs", "ConstrutorNPCs" }) do
		local c = SS[n]:Clone(); c.Parent = tmp
	end
	RS.NPCVila.Assets:Clone().Parent = tmp
	tmp.GeradorNPCs.Source = troca(troca(tmp.GeradorNPCs.Source, "require(SS.PapeisNPC)", "require(script.Parent.PapeisNPC)"), "require(SS.PosicoesNPC)", "require(script.Parent.PosicoesNPC)")
	tmp.ElencoNPCs.Source = troca(troca(tmp.ElencoNPCs.Source, "require(SS.PosicoesNPC)", "require(script.Parent.PosicoesNPC)"), "require(SS.GeradorNPCs)", "require(script.Parent.GeradorNPCs)")
	tmp.ConstrutorNPCs.Source = troca(tmp.ConstrutorNPCs.Source, "require(ReplicatedStorage.NPCVila.Assets)", "require(script.Parent.Assets)")
	specs = require(tmp.ElencoNPCs)
	Construtor = require(tmp.ConstrutorNPCs)
	return specs
end

function M.construir(inicio, fim, limpar)
	local pasta = workspace.NPCs
	if limpar then pasta:ClearAllChildren() end
	local feitos, erros = 0, {}
	for i = inicio, math.min(fim, #specs) do
		local ok, err = pcall(Construtor.criar, specs[i], pasta)
		if ok then feitos += 1 else table.insert(erros, specs[i].id .. ": " .. tostring(err)) end
		if i % 8 == 0 then task.wait() end
	end
	return feitos, erros
end

function M.fim()
	if tmp then tmp:Destroy(); tmp = nil end
end

return M
