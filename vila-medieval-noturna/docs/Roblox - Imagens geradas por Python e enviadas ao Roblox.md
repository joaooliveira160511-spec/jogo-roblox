---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, imagens, python, upload]
---
# Roblox - Imagens geradas por Python e enviadas ao Roblox
Índice: Jogos - Gerais

## Conceito
- As texturas do projeto (Lua e vidro das janelas) são desenhadas por código Python puro, sem bibliotecas externas, e enviadas ao Roblox com a ferramenta `upload_image`. O resultado é um identificador `rbxassetid://...` usado em propriedades de Sky e Decal.

## Por que Python puro
- O ambiente não tinha PIL nem numpy. A gravação de PNG é feita com `struct` e `zlib`: assinatura de 8 bytes, chunks IHDR, IDAT (linhas com filtro 0 e pixels RGBA) e IEND, cada chunk com CRC32.
- A função `png(path, w, h, pix)` recebe uma matriz de linhas de tuplas (r, g, b, a).

## Fluxo de envio
1. Gerar o PNG em uma pasta temporária (a pasta de rascunho da sessão).
2. Subir um servidor HTTP local na pasta, por exemplo `python -m http.server 8766 --bind 127.0.0.1`.
3. Chamar `upload_image` com as URLs `http://127.0.0.1:PORTA/arquivo.png`.
4. Anotar os ids devolvidos (ver Roblox - Assets enviados e identificadores).
5. Encerrar o servidor local.

## Observações
- Logo após o envio, o console pode mostrar "Asset content representation is being generated"; a imagem ainda está sendo processada e pode aparecer vazia por alguns instantes.
- Os geradores usados estão em Imagem da Lua - Código gerador em Python e Imagem do vidro quadriculado - Código gerador em Python.

## Revisão - Pillow e numpy para as imagens mais ricas
- A regra do Python puro vale para a Lua e o vidro. As imagens dos NPCs e a do pergaminho envelhecido da fala do ancião usam Pillow e numpy, que dão desfoque, suavização e ruído fractal. O Pillow é instalado numa pasta local (`pip install --target pylib pillow`), sem tocar no Python global, e o script a põe no `sys.path`; a execução é com `python -I` (ver NPCs da vila - Rostos, sujeira e pergaminho e Imagem do pergaminho velho - Código gerador em Python).
- Uma imagem de 1800 por 600 com fundo transparente, do tamanho do pergaminho, pesa cerca de 1 MB e foi enviada por `upload_image` pelo mesmo fluxo, sem mudanças.

## Exceções e limites
- `upload_image` exige URLs HTTP; arquivos locais não são aceitos diretamente.
- O HttpService do jogo está desligado e não serve para esse envio (ver Roblox Studio via MCP - Limitações de permissão).

## Relacionados
- Lua - Textura no Sky
- Janelas - Brilho de vela quadriculado
