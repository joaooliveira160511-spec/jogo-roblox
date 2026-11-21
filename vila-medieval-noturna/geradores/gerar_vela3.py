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
LINE = 3  # espessura das juntas escuras entre os quadrados (vidro "quadriculado")

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


# cor de cada quadrado: distância até a chama (centro, um pouco abaixo), em degraus
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
            col = lerp(col, (22, 17, 13), 0.35)  # chanfro suave junto à junta
        row.append((int(col[0]), int(col[1]), int(col[2]), 250))
    pix.append(row)
png(os.path.join(OUT, "vela3.png"), W, H, pix)
print("ok", W, H)
