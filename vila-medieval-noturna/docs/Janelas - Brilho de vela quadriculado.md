---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, janelas, vela]
---
# Janelas - Brilho de vela quadriculado
Índice: Jogos - Gerais

## Conceito
- As janelas acesas não brilham como lâmpadas: parecem ter uma vela por trás de um vidro quadriculado (como vitrais de pequenos quadrados). A transição de cor do centro (amarelo-alaranjado) para as bordas (marrom escuro) é feita em degraus de quadrados, e não em um gradiente redondo.

## Implementação
- O vidro é uma peça Glass escura (16,20,28); sobre sua face Back há um Decal chamado "Vela" com a textura rbxassetid://124780722048553 (grade de 6 colunas por 8 linhas, juntas escuras de 3 px).
- Decal.Color3 = (255,255,255) (sem tinta extra).
- Transparência do Decal: 0,4 na maior parte do tempo (escuro e discreto), variando entre 0,3 e 0,5 com o tremulado; 1 (invisível) quando apagada.
- A PointLight do vidro (quando existe) tem Range 13, Brightness 0,3 e cor (255,176,84).
- Gerador da imagem: Imagem do vidro quadriculado - Código gerador em Python.

## Cores e escala
- Centro: (255,214,124) e (248,178,78); mais afastado: (190,118,48), depois (96,62,30), até (40,28,18) nas bordas; as juntas são (22,17,13).
- Cada quadrado ganha uma variação aleatória de ±0,06 na distância, para que a grade não pareça mecânica.
- A "chama" fica um pouco abaixo do centro (fator 0,62 na vertical), como uma vela sobre o peitoril.

## Aplicação nas casas existentes
```lua
for _, d in ipairs(workspace.Vila.Casas:GetDescendants()) do
	if d:IsA("Decal") and d.Name == "Vela" then
		d.Texture = "rbxassetid://124780722048553"
	end
end
```
- A função `janela` do módulo já cria o Decal com esse id.

## Exceções e limites
- A textura deve ser aplicada na face Back do vidro; em outras faces fica espelhada ou oculta.
- Janelas muito grandes (escala maior que 1) esticam a grade; manter a proporção 3,2 x 4,4.

## Relacionados
- Janelas - Evolução do vidro
- Casa - Janelas e venezianas
- Luzes - Sistema de estados
