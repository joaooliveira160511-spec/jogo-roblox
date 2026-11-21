-- Alteracao feita neste chat no LocalScript StarterPlayer.StarterPlayerScripts.NPCsVila.
-- Este arquivo NAO e o script inteiro: o restante do NPCsVila nao foi alterado aqui e fica no Studio.
-- Como aplicar:
--   1) No topo do script, junto aos outros servicos (depois de local RunService = ...):
local CS = game:GetService("CollectionService")

--   2) Logo depois das duas linhas que registram a pasta workspace.NPCs
--      (pasta.ChildAdded e pasta.ChildRemoved), colocar o bloco abaixo.
--      NPCs que vivem fora da pasta (o idoso da cadeira de balanco e filho do Model da cadeira e sai e volta com a casa):
--      marcados com a tag "NPCVila", sao registrados e removidos por ela. Mover o Model pai (a cadeira balanca) move o NPC junto.
for _, m in ipairs(CS:GetTagged("NPCVila")) do registra(m) end
CS:GetInstanceAddedSignal("NPCVila"):Connect(function(m) task.defer(registra, m) end)
CS:GetInstanceRemovedSignal("NPCVila"):Connect(function(m) npcs[m] = nil end)
