-- Alteracao feita neste chat no ModuleScript ReplicatedStorage.NPCVila.Poses.
-- Este arquivo NAO e o modulo inteiro: colocar o bloco abaixo no Poses, logo depois do bloco de D.cambaleante
-- e antes do comentario "poses de marcha".
-- ----- pose de cadeira alta -----
-- sentado_cadeira: a raiz NAO desce (nenhum dy): o NPC ja e posicionado na altura do assento. Quadril a 90 graus, pernas quase
-- estendidas com o tornozelo compensado (pe plano sobre um banquinho), tronco recostado e antebracos nos apoios de braco.
-- Medido por cinematica direta com o rig de altura 1,0 e largura 0,82; a cabeca olha devagar para um lado e para o outro.
D.sentado_cadeira = {
	dur = 9,
	base = { Cint = { 12 }, Pesc = { -12 }, QuaE = { 90, 0, 4 }, QuaD = { 90, 0, 4 }, JoeE = { -10 }, JoeD = { -10 }, TorE = { -80 }, TorD = { -80 },
		OmbE = { 20, 0, 6 }, OmbD = { 20, 0, 6 }, CotE = { 70 }, CotD = { 70 } },
	keys = {
		{ 0.28, { Cint = { 13 }, Pesc = { -14, 16, 0 } } },
		{ 0.52, { Cint = { 12 }, Pesc = { -12, 0, 0 } } },
		{ 0.78, { Cint = { 11 }, Pesc = { -13, -14, 0 }, CotD = { 66 } } },
	},
}
