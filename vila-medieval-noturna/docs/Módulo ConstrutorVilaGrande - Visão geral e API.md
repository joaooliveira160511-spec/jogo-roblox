---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, modulo, api, codigo]
---
# Módulo ConstrutorVilaGrande - Visão geral e API
Índice: [[Jogos - Gerais]]

## Conceito
- O ModuleScript `ServerStorage.ConstrutorVilaGrande` concentra a construção da vila. Retorna uma tabela `M`. Roda em modo Edit por `require` (sempre numa cópia clonada, ver [[Roblox Studio - ModuleScript, require e cache]]) e deixa os resultados salvos no Workspace.
- O código completo está dividido em seis notas de código para a vila original (partes 1 a 6), na ordem em que aparece no arquivo, e em três notas para a extensão (partes 7 a 9, ver abaixo).

## Ordem no arquivo
1. [[Módulo ConstrutorVilaGrande - Código parte 1 base e luzes]]: constantes, funções auxiliares (`P`, `Cyl`, `Wedge`), luzes, janela, enxaimel e placa.
2. [[Módulo ConstrutorVilaGrande - Código parte 2 casa]]: `M.casa`.
3. [[Módulo ConstrutorVilaGrande - Código parte 3 poste e objetos]]: `M.poste`, `M.barril`, `M.caixa`, `M.banco`.
4. [[Módulo ConstrutorVilaGrande - Código parte 4 praça, pedras e detalhes]]: versões finais de `M.praca`, `M.pedras` e `M.detalhes`.
5. [[Módulo ConstrutorVilaGrande - Código parte 5 adereços]]: `M.aderecos` e funções auxiliares.
6. [[Módulo ConstrutorVilaGrande - Código parte 6 fonte]]: emissor de partículas e `M.fonte`.

## API
- `M.casa(parent, cf, o)`: cria um Model de casa; `o = {w, d, andares, plaster, gableFront, estado, grupo, name, seed, placa}`.
- `M.poste(parent, cf, estado, grupo, nome)`: poste com lampião.
- `M.barril(parent, pos)`, `M.caixa(parent, cf)`, `M.banco(parent, cf)`: objetos de cena (o banco não deve ser usado).
- `M.praca(parent)`: discos do piso, meio-fio e segmentos das ruas.
- `M.pedras(parent)`: pedras individuais em anéis e ruas.
- `M.detalhes(parent)`: pedregulhos, rochas, musgo e poças (remover musgo e poças depois).
- `M.aderecos(parent)`: carroças, fenos, cercas e barracas.
- `M.fonte(parent, pos)`: a fonte gigante.
- Dados: `M.C` (paleta), `M.plasters` (seis cores de parede) e `M.variant` (material para MaterialVariant).

## Extensão da vila (partes 7 a 9)
- Depois de `M.fonte` o módulo recebe a extensão para as quatro direções, em três blocos de código:
  - [[Módulo ConstrutorVilaGrande - Código parte 7 piso, praça circular, postes e poço]]: `M.paramsPiso`, `M.ruaExtensao`, `M.calcada`, `M.pedrasCampo`, `M.pedrasAneis`, `M.limpaPedras`, `M.pracaCirculo`, `M.postesRua`, `M.postesCirculo`, `M.lenha`, `M.poco` e `M.pedregulhosNovos`.
  - [[Módulo ConstrutorVilaGrande - Código parte 8 casas variadas e ruína]]: `M.casaVelha`, `M.entulho`, `M.fileiraRua` e `M.circuloCasas`, mais `M.plastersVelhos`.
  - [[Módulo ConstrutorVilaGrande - Código parte 9 orquestração por direção]]: `M.NOMES_DIR`, `M.limparExtensao`, `M.pisoDirecao`, `M.casasDirecao`, `M.pedregulhosDirecao`, `M.limpaGrama` e `M.fixaPivos`.
- Visão geral do que a extensão constrói: [[Vila Medieval - Expansão pelas quatro direções]].

## Vila circular (parte 10)
- Depois da orquestração por direção, o módulo recebe um quarto bloco: [[Módulo ConstrutorVilaGrande - Código parte 10 vila circular]]. Funções: `M.ANEL`, `M.RF_MURO`, `M.baseLateral`, `M.limpaCruzamentos`, `M.removeCirculoCasas`, `M.completaMeioFio`, `M.ruaLateral`, `M.postesBase`, `M.anelPiso`, `M.anelCasas`, `M.anelPedregulhos`, `M.pedrasAneis2`, `M.passeioMuro`, `M.postesMuro`, `M.planoMuralha`, `M.muralhaCasas`, `M.fixaPivos2` e `M.limparAnel`.
- Duas funções antigas mudam: `M.fileiraRua` aceita `cfg.base` (referencial livre) e `sorteiaEstado` dá mais luzes ligadas e piscando.
- Descrição: [[Vila circular - Muralha de casas voltadas para o centro]] e [[Ruas laterais - Anel viário entre as ruas cardeais]].

## Observações importantes
- O arquivo contém versões antigas de `M.praca`, `M.pedras`, `M.detalhes` e `M.fonte` (praça de raio 80, pedras 2,4 a 2,95 e fonte com câmara habitável) antes das versões finais, redefinidas mais abaixo. Como a última definição prevalece, as notas de código reproduzem só as versões finais.
- A construção usa `Random.new(seed)` por função para ser repetível.
- O módulo não cria scripts além do "FonteFalha" da fonte; os demais scripts do projeto são criados à parte.

## Relacionados
- [[Vila Medieval - Ordem de reconstrução passo a passo]]
- [[Casas - Posicionamento no anel da praça]]
