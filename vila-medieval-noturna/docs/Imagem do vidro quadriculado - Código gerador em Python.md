---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, python, janelas, codigo]
---
# Imagem do vidro quadriculado - Código gerador em Python
Índice: Jogos - Gerais

## Conceito
- Gera um PNG RGBA de 192x256 com uma grade de 6 colunas por 8 linhas de quadrados de 32 px. Cada quadrado é uma cor uniforme que depende da distância à "chama" da vela, em degraus, com pequena variação aleatória; entre os quadrados há juntas escuras de 3 px com um chanfro suave.
- O resultado é o Decal "Vela" das janelas (ver Janelas - Brilho de vela quadriculado).

## Código
```python
import math, random, struct, zlib, os

OUT = os.path.dirname(os.path.abspath(__file__))


def png(path, w, h, pix):
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        for r, g, b, a in pix[y]:
            raw += bytes((r, g, b, a))
    def chunk(t, d):
        c = struct.pack(">I", len(d)) + t + d
        return c + struct.pack(">I", zlib.crc32(t + d) & 0xFFFFFFFF)
    data = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
    data += chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + chunk(b"IEND", b"")
    open(path, "wb").write(data)


def lerp(a, b, t):
    return tuple(a[i] + (b[i] - a[i]) * t for i in range(3))


random.seed(7)
COLS, ROWS, CELL = 6, 8, 32
W, H = COLS * CELL, ROWS * CELL
LINE = 3  # espessura das juntas escuras entre os quadrados

# paleta do calor da vela: entre amarelo e laranja, escurecendo para marrom
RAMP = [
    (0.00, (255, 214, 124)),
    (0.30, (248, 178, 78)),
    (0.60, (190, 118, 48)),
    (0.85, (96, 62, 30)),
    (1.00, (40, 28, 18)),
]


def ramp(t):
    t = max(0.0, min(1.0, t))
    for i in range(len(RAMP) - 1):
        t0, c0 = RAMP[i]
        t1, c1 = RAMP[i + 1]
        if t <= t1:
            return lerp(c0, c1, (t - t0) / (t1 - t0))
    return RAMP[-1][1]


cells = {}
for j in range(ROWS):
    for i in range(COLS):
        u = ((i + 0.5) / COLS - 0.5) * 2.0
        v = ((j + 0.5) / ROWS - 0.62) * 1.7
        d = math.hypot(u, v) / 1.25
        d = round(d * 6) / 6  # quantiza em degraus (transição quadriculada)
        d += random.uniform(-0.06, 0.06)
        cells[(i, j)] = ramp(d)

pix = []
for y in range(H):
    row = []
    for x in range(W):
        i, j = x // CELL, y // CELL
        lx, ly = x % CELL, y % CELL
        col = cells[(i, j)]
        edge = min(lx, CELL - 1 - lx, ly, CELL - 1 - ly)
        if edge < LINE:
            col = (22, 17, 13)
        elif edge < LINE + 2:
            col = lerp(col, (22, 17, 13), 0.35)
        row.append((int(col[0]), int(col[1]), int(col[2]), 250))
    pix.append(row)
png(os.path.join(OUT, "vela3.png"), W, H, pix)
```

## Parâmetros que definem o estilo
- A chama fica um pouco abaixo do centro (fator 0,62 na vertical) e a distância é achatada na vertical (fator 1,7), o que alonga o brilho.
- Quantização da distância em sextos produz os degraus quadriculados; a variação aleatória de ±0,06 quebra a regularidade.
- Paleta: (255,214,124) amarelo-claro no centro, passando por (248,178,78) e (190,118,48), até (40,28,18) nas bordas.

## Relacionados
- Roblox - Imagens geradas por Python e enviadas ao Roblox
- Imagem da Lua - Código gerador em Python
