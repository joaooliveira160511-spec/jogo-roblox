---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, cframe, orientacao]
---
# Roblox - Convenções de orientação, CFrame e formas
Índice: Jogos - Gerais

## Conceito
- A construção por código depende de convenções de orientação que não são óbvias. Elas foram verificadas por teste e usadas em todo o módulo.

## Faces e eixos de uma Part
- Frente (Front) = -Z local; Trás (Back) = +Z local; Topo = +Y; Direita = +X.
- `CFrame.lookAt(pos, alvo)` aponta o -Z local para o alvo; portanto a face Front olha para o alvo. Para que uma peça olhe "para fora", usa-se `lookAt` para o centro e a face visível é a de trás ou se gira em pi.
- Convenção do projeto para janelas e faces: o +Z local aponta para fora; por isso o Decal da janela fica na face Back.
- Casas: a frente é o -Z local do CFrame da casa; `lookAt(pos, centro)` deixa a porta voltada para a praça.

## Cilindros e esferas
- Uma Part com `Shape = Cylinder` tem o eixo ao longo do X local e `Size.X` é o comprimento. Para um cilindro vertical: `CFrame.Angles(0, 0, pi/2)` e `Size = (altura, diâmetro, diâmetro)`.
- Cilindro deitado (fardo de feno): sem a rotação de pi/2 em Z, com a guinada desejada.
- Roda de carroça: cilindro com eixo em Z, obtido por `CFrame.Angles(0, pi/2, 0)` sobre o cilindro padrão.
- Esfera: `Shape = Ball` com `Size` uniforme.

## WedgePart
- A cunha padrão tem o lado vertical em +Z e a altura cai para -Z (verificado por raycast: altura +1,8 em z = +1,8 e -1,8 em z = -1,8). Uso: metades de empenas; a metade oposta gira pi em Y.

## Rotação em torno de eixos
- Rotação positiva em X por θ leva o +Z local a `(0, -sin θ, cos θ)`: o lado +Z desce. Usado em beirais e vigas de empena.
- `CFrame.fromAxisAngle(eixo, θ)`: o vetor de cima gira em direção ao vetor perpendicular ao eixo; para inclinar uma lâmina de grama em direção à curvatura `(x, z)`, o eixo é `(z, 0, -x)` normalizado.
- `CFrame.fromMatrix(pos, Vector3.xAxis, n)` cria um quadro com a normal `n` e o eixo X como direção da cumeeira; o eixo Z é calculado; usado em telhas.

## Terreno
- `Terrain:FillCylinder(cframe, altura, raio, material)` tem o eixo no Y do `cframe`.
- Uma coluna de Ground com topo em y = 0 tem superfície em y = 2 (ver Terreno - Material Ground e altura real da superfície).

## Escala do personagem
- O Humanoid padrão tem cerca de 5 studs de altura; o HumanoidRootPart fica a cerca de 3 studs acima do piso. Portas devem ter pelo menos 7 a 8 studs; degraus de até 1 stud são transponíveis.

## Relacionados
- Módulo ConstrutorVilaGrande - Código parte 1 base e luzes
- Casa - Empenas, trapeiras e chaminés
