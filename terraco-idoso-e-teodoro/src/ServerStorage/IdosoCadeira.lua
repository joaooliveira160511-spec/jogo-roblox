-- IdosoCadeira: constroi o idoso sentado na cadeira de balanco do terraco da casa da cobertura, com o banquinho de pes, a almofada
-- de encosto e a bengala. Tudo e filho do Model CadeiraBalanco: balanca junto com ela e sai e volta com a casa (troca de mundo).
-- O NPC e marcado com a tag "NPCVila" (o LocalScript NPCsVila registra por ela) e usa a pose "sentado_cadeira".
-- Uso, em Edit, com uma COPIA do modulo (o require guarda o codigo em cache):
--   require(game.ServerStorage.IdosoCadeira:Clone()).construir(workspace.Vila.Casas.CasaNorteCobertura)
-- Refazer a fachada pelo ConstrutorCasaFachada recria a cadeira e apaga o idoso: rode construir de novo depois.
local ServerStorage = game:GetService("ServerStorage")
local CS = game:GetService("CollectionService")

local M = {}

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local V3 = Vector3.new
local CF = CFrame.new

local MADEIRA = rgb(104, 78, 54) -- a mesma madeira da cadeira
local MADEIRA_ESC = rgb(78, 58, 40)
local ALMOFADA = rgb(112, 42, 38) -- a mesma almofada do assento
local LINHO = rgb(148, 126, 96)

-- referencial da cadeira: origem no piso sob o centro, assento voltado para -Z; topo da almofada do assento em y 2,31
M.RAIZ = CF(0, 3.68, 0.3) -- posicao da raiz do NPC: coxas sobre a almofada, costas a ~0,7 do encosto

local NOMES = { "NPC_idosoCadeira", "BanquinhoPes", "AlmofadaEncosto", "Bengala" }

M.spec = {
	id = "idosoCadeira", nome = "Anacleto", titulo = "Ancião", papel = "velho", genero = "H", idade = "idoso", interativo = false,
	pos = Vector2.new(0, -300), mira = Vector2.new(0, -310),
	pele = rgb(214, 168, 128), face = "i2", esc = { h = 1.0, w = 0.82 },
	roupa = { camisa = rgb(128, 112, 86), calca = rgb(56, 50, 50), mangaCurta = false, sujo = "torso1", botas = rgb(48, 40, 34), xale = rgb(96, 84, 74) },
	cabelo = { estilo = "calvo", cor = rgb(170, 166, 160) },
	pose = "sentado_cadeira",
	-- caixa de colisao do corpo sentado, acima do assento (o assento e os apoios ja colidem)
	colisor = { tam = V3(2.0, 3.4, 2.2), y = 0.8 },
}

function M.construir(casa)
	local cad = casa:FindFirstChild("CadeiraBalanco")
	assert(cad, "CadeiraBalanco nao encontrada em " .. casa.Name)
	for _, n in ipairs(NOMES) do
		for _, c in ipairs(cad:GetChildren()) do
			if c.Name == n then c:Destroy() end
		end
	end
	local base = cad:GetPivot()

	local function peca(nome, tam, cf, cor, mat, colide, forma)
		local p = Instance.new("Part")
		p.Name = nome
		p.Size = tam
		p.CFrame = base * cf
		p.Color = cor
		p.Material = mat or Enum.Material.Wood
		p.Anchored = true
		p.CanCollide = colide == true
		p.CanTouch = false
		p.CastShadow = false
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		if forma then p.Shape = forma end
		return p
	end

	-- banquinho de pes: o topo da almofada fica em y 2,27, na altura dos calcanhares do idoso (medido pela pose)
	local banco = Instance.new("Model")
	banco.Name = "BanquinhoPes"
	local zc = -2.08
	-- sem colisao: o banquinho balanca junto com a cadeira e, solido, empurrava para cima o jogador parado diante dele (cerca de 0,4 a cada ciclo)
	peca("Tampo", V3(1.9, 0.22, 1.35), CF(0, 2.0, zc), MADEIRA, Enum.Material.Wood, false).Parent = banco
	peca("Almofada", V3(1.7, 0.16, 1.15), CF(0, 2.19, zc), ALMOFADA, Enum.Material.Fabric, false).Parent = banco
	for _, sx in ipairs({ -1, 1 }) do
		for _, sz in ipairs({ -1, 1 }) do
			peca("Perna", V3(0.26, 1.81, 0.26), CF(sx * 0.68, 0.08 + 1.81 / 2, zc + sz * 0.5), MADEIRA, Enum.Material.Wood, false).Parent = banco
		end
	end
	for _, sz in ipairs({ -1, 1 }) do
		peca("Travessa", V3(1.1, 0.16, 0.16), CF(0, 0.9, zc + sz * 0.5), MADEIRA_ESC, Enum.Material.Wood, false).Parent = banco
	end
	for _, sx in ipairs({ -1, 1 }) do
		peca("Travessa", V3(0.16, 0.16, 0.84), CF(sx * 0.68, 0.9, zc), MADEIRA_ESC, Enum.Material.Wood, false).Parent = banco
	end
	banco.Parent = cad

	-- almofada de encosto: preenche o vao entre as costas do idoso e as ripas do encosto (inclinado 12 graus para tras)
	local alm = peca("AlmofadaEncosto", V3(1.9, 1.6, 0.7), CF(0, 3.5, 1.10) * CFrame.Angles(math.rad(12), 0, 0), LINHO, Enum.Material.Fabric, false)
	alm.Parent = cad

	-- bengala encostada no apoio de braco esquerdo (lado de fora)
	local b0, b1 = V3(-1.95, 0.08, 0.7), V3(-1.62, 4.08, 0.7)
	local d = b1 - b0
	local meio = (b0 + b1) / 2
	local beng = Instance.new("Model")
	beng.Name = "Bengala"
	local haste = peca("Haste", V3(d.Magnitude, 0.16, 0.16), CFrame.lookAt(meio, meio + d) * CFrame.Angles(0, math.rad(90), 0), MADEIRA_ESC, Enum.Material.Wood, false, Enum.PartType.Cylinder)
	haste.Parent = beng
	peca("Cabo", V3(0.34, 0.34, 0.34), CF(b1), MADEIRA_ESC, Enum.Material.Wood, false, Enum.PartType.Ball).Parent = beng
	beng.Parent = cad

	-- o idoso
	local Construtor = require(ServerStorage.ConstrutorNPCs:Clone())
	local m = Construtor.criar(M.spec, cad)
	m:PivotTo(base * M.RAIZ)
	m:SetAttribute("Fase", 0.35)
	CS:AddTag(m, "NPCVila")
	return m
end

return M
