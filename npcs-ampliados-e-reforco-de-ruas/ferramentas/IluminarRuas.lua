-- IluminarRuas: acrescenta postes de rua (clones de Lampioes.Poste3, que esta "ligada") onde a iluminacao das
-- avenidas e dos aneis esta abaixo da meta. A conta e a do projeto (soma de brilho * (1 - distancia / alcance)),
-- com luz "ligada" valendo 1 e "piscando" valendo 0,6; "apagada" nao conta.
-- Uso: require(clone)(true) cria os postes (apaga antes os PosteRua* de rodadas anteriores); (false) so simula.
local CS = game:GetService("CollectionService")

local META = 0.9          -- iluminacao efetiva desejada nas amostras de rua
local OFFSET_POSTE = 11   -- distancia do poste ao eixo da rua (mesma dos postes originais)
local SEP_MIN = 16        -- distancia minima entre postes
local MAX_POSTES = 170
local ALTURA_LUZ = 13.5 - 1.5

return function(GRAVAR)
	local L = workspace.Vila.Lampioes
	if GRAVAR then
		for _, c in ipairs(L:GetChildren()) do if c.Name:match("^PosteRua%d+$") then c:Destroy() end end
	end
	local molde = L.Poste3
	assert(molde:FindFirstChild("Chama", true):GetAttribute("Estado") == "ligada", "molde precisa estar ligado")

	-- ===== fontes de luz (peso por estado) =====
	local fontes, polos = {}, {}
	local function add(x, y, z, R, B, w) table.insert(fontes, { x = x, y = y, z = z, R = R, B = B * w }) end
	for _, p in ipairs(CS:GetTagged("Luz")) do
		local luz = p:FindFirstChildWhichIsA("PointLight")
		if p:IsA("BasePart") and luz and luz.Range >= 16 and not p:IsDescendantOf(workspace.NPCs) then
			local e = p:GetAttribute("Estado")
			local w = (e == "ligada" and 1) or (e == "piscando" and 0.6) or 0
			if w > 0 then add(p.Position.X, p.Position.Y, p.Position.Z, luz.Range, luz.Brightness, w) end
		end
	end
	for _, c in ipairs(L:GetChildren()) do
		local p = c:IsA("Model") and c:GetPivot().Position or (c:IsA("BasePart") and c.Position)
		if p then table.insert(polos, { x = p.X, z = p.Z }) end
	end
	local function ilum(x, z)
		local I = 0
		for _, f in ipairs(fontes) do
			local dx, dz, dy = f.x - x, f.z - z, f.y - 1.5
			local d = math.sqrt(dx * dx + dz * dz + dy * dy)
			if d < f.R then I += f.B * (1 - d / f.R) end
		end
		return I
	end

	-- ===== ruas: eixo "x" varia x com z = c; eixo "z" varia z com x = c =====
	local ruas = {
		{ k = "x", c = 0, a = 60, b = 245, nome = "AvLeste" }, { k = "x", c = 0, a = -245, b = -60, nome = "AvOeste" },
		{ k = "z", c = 0, a = 60, b = 245, nome = "AvSul" }, { k = "z", c = 0, a = -245, b = -60, nome = "AvNorte" },
		{ k = "z", c = 200, a = -214, b = 214, nome = "AnelLeste" }, { k = "z", c = -200, a = -214, b = 214, nome = "AnelOeste" },
		{ k = "x", c = 200, a = -214, b = 214, nome = "AnelSul" }, { k = "x", c = -200, a = -214, b = 214, nome = "AnelNorte" },
	}
	local function pt(r, t, o) if r.k == "x" then return t, r.c + o else return r.c + o, t end end

	local amostras = {}
	for _, r in ipairs(ruas) do
		for t = r.a, r.b, 8 do
			for _, o in ipairs({ -18, -9, 0, 9, 18 }) do
				local x, z = pt(r, t, o)
				table.insert(amostras, { x = x, z = z, I = ilum(x, z), rua = r.nome })
			end
		end
	end
	local antes = 0
	for _, s in ipairs(amostras) do if s.I < META then antes += 1 end end

	-- ===== candidatos validos =====
	local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { L, workspace.NPCs }
	local ov = OverlapParams.new(); ov.FilterType = Enum.RaycastFilterType.Exclude
	ov.FilterDescendantsInstances = { workspace.Vila.Pedras, workspace.Vila.Praca, workspace.Vila.Pracas, workspace.Grama, workspace.NPCs }
	local base0 = molde.BasePoste.Position
	local chama0 = molde:FindFirstChild("Chama", true).Position
	local a0 = Vector3.new(chama0.X - base0.X, 0, chama0.Z - base0.Z)
	local rg0 = workspace:Raycast(Vector3.new(base0.X, 40, base0.Z), Vector3.new(0, -80, 0), rp)
	local chao0 = rg0.Position.Y
	local braco = a0.Magnitude

	local cands = {}
	for _, r in ipairs(ruas) do
		for t = r.a, r.b, 4 do
			for _, lado in ipairs({ -1, 1 }) do
				local x, z = pt(r, t, lado * OFFSET_POSTE)
				local ok = true
				for _, p in ipairs(polos) do if (p.x - x) ^ 2 + (p.z - z) ^ 2 < SEP_MIN ^ 2 then ok = false break end end
				local g
				if ok then
					local res = workspace:Raycast(Vector3.new(x, 40, z), Vector3.new(0, -80, 0), rp)
					if res and (res.Instance:IsDescendantOf(workspace.Vila.Pedras) or res.Instance:IsDescendantOf(workspace.Vila.Praca)) then g = res.Position.Y else ok = false end
				end
				if ok and #workspace:GetPartBoundsInBox(CFrame.new(x, g + 4.5, z), Vector3.new(3.6, 7, 3.6), ov) > 0 then ok = false end
				if ok then
					-- direcao do braco: do poste para o eixo da rua
					local ax, az = 0, 0
					if r.k == "x" then az = -lado else ax = -lado end
					local lx, lz = x + ax * braco, z + az * braco
					local viz = {}
					for i, s in ipairs(amostras) do
						local dx, dz = lx - s.x, lz - s.z
						local d = math.sqrt(dx * dx + dz * dz + ALTURA_LUZ ^ 2)
						if d < 44 then viz[#viz + 1] = { i, 1.25 * (1 - d / 44) } end
					end
					table.insert(cands, { x = x, z = z, g = g, ax = ax, az = az, viz = viz, rua = r.nome, vivo = true })
				end
			end
		end
	end

	-- ===== guloso =====
	local deficit = {}
	for i, s in ipairs(amostras) do deficit[i] = math.max(0, META - s.I) end
	local escolhidos = {}
	while #escolhidos < MAX_POSTES do
		local melhor, mg = nil, 0
		for _, c in ipairs(cands) do
			if c.vivo then
				local g = 0
				for _, v in ipairs(c.viz) do g += math.min(deficit[v[1]], v[2]) end
				if g > mg then melhor, mg = c, g end
			end
		end
		if not melhor or mg < 0.12 then break end
		table.insert(escolhidos, melhor)
		for _, v in ipairs(melhor.viz) do deficit[v[1]] = math.max(0, deficit[v[1]] - v[2]) end
		for _, c in ipairs(cands) do if c.vivo and (c.x - melhor.x) ^ 2 + (c.z - melhor.z) ^ 2 < SEP_MIN ^ 2 then c.vivo = false end end
	end
	local depois, porRua = 0, {}
	for i in ipairs(amostras) do if deficit[i] > 0.001 then depois += 1 end end
	for _, c in ipairs(escolhidos) do porRua[c.rua] = (porRua[c.rua] or 0) + 1 end

	-- ===== criacao =====
	if GRAVAR then
		for i, c in ipairs(escolhidos) do
			local clone = molde:Clone()
			clone.Name = "PosteRua" .. i
			local A = CFrame.lookAt(Vector3.zero, a0.Unit)
			local B = CFrame.lookAt(Vector3.zero, Vector3.new(c.ax, 0, c.az))
			local R = B * A:Inverse()
			local T = CFrame.new(c.x, 0, c.z) * R * CFrame.new(-base0.X, -base0.Y + (c.g - chao0), -base0.Z)
			-- T leva o ponto base0 para (c.x, base0.Y + (c.g - chao0), c.z)
			T = CFrame.new(c.x, base0.Y + (c.g - chao0), c.z) * R * CFrame.new(-base0.X, -base0.Y, -base0.Z)
			clone:PivotTo(T * clone:GetPivot())
			local ch = clone:FindFirstChild("Chama", true)
			ch:SetAttribute("Grupo", "posteRua" .. i)
			ch:SetAttribute("Estado", "ligada")
			for _, l in ipairs(clone:GetDescendants()) do if l:IsA("PointLight") then l.Shadows = false end end -- so os 28 postes originais projetam sombra (desempenho)
			clone:SetAttribute("PosteRua", true)
			clone.Parent = L
		end
	end
	local txt = {}
	for k, v in pairs(porRua) do table.insert(txt, k .. "=" .. v) end
	table.sort(txt)
	return string.format("amostras=%d abaixo da meta antes=%d | candidatos=%d postes=%d | ainda abaixo depois=%d | %s | gravado=%s",
		#amostras, antes, #cands, #escolhidos, depois, table.concat(txt, " "), tostring(GRAVAR)), escolhidos
end
