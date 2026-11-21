import math, struct, zlib, os

OUT = os.path.dirname(os.path.abspath(__file__))


def png(path, w, h, pix):
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        row = pix[y]
        for r, g, b, a in row:
            raw += bytes((r, g, b, a))
    def chunk(t, d):
        c = struct.pack(">I", len(d)) + t + d
        return c + struct.pack(">I", zlib.crc32(t + d) & 0xFFFFFFFF)
    data = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
    data += chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + chunk(b"IEND", b"")
    open(path, "wb").write(data)


def smooth(e0, e1, x):
    t = max(0.0, min(1.0, (x - e0) / (e1 - e0)))
    return t * t * (3 - 2 * t)


def lerp(a, b, t):
    return tuple(a[i] + (b[i] - a[i]) * t for i in range(3))


# ---------- Lua desenhada (disco opaco + halo suave) ----------
N = 512
C = N / 2
R = 150.0
craters = [  # (x, y, raio) em fração do raio do disco, relativas ao centro
    (-0.38, -0.30, 0.20), (0.22, -0.52, 0.12), (-0.50, 0.28, 0.14),
    (-0.10, 0.05, 0.09), (0.30, 0.22, 0.17), (-0.22, 0.58, 0.07), (0.55, -0.12, 0.08),
    (0.05, -0.20, 0.06), (0.48, 0.55, 0.09),
]
maria = [(-0.15, -0.10, 0.40, 0.55), (0.30, 0.15, 0.32, 0.45)]
pix = []
for y in range(N):
    row = []
    for x in range(N):
        dx, dy = x + 0.5 - C, y + 0.5 - C
        d = math.hypot(dx, dy)
        # halo
        halo_a = 0.0
        if d > R - 2:
            halo_a = 0.30 * (1 - smooth(R, N / 2, d)) ** 2
        r_, g_, b_, a_ = 175, 195, 255, halo_a
        cov = 1 - smooth(R - 1.2, R + 1.2, d)
        if cov > 0:
            # base com leve sombreamento (claro em cima à esquerda)
            sh = (-dx - dy) / (R * 1.6) * 0.07
            base = (238 + sh * 255 * 0.2, 233 + sh * 255 * 0.2, 214 + sh * 255 * 0.2)
            col = base
            u, v = dx / R, dy / R
            for (mx, my, mr, ma) in maria:
                dd = math.hypot(u - mx, v - my)
                col = lerp(col, (204, 198, 176), (1 - smooth(mr * 0.6, mr, dd)) * ma)
            for (cx, cy, cr) in craters:
                dd = math.hypot(u - cx, v - cy)
                if dd < cr:
                    inner = lerp((210, 204, 182), (196, 189, 165), smooth(0, cr, dd))
                    col = lerp(col, inner, 1 - smooth(cr - 0.015, cr, dd))
                rim = abs(dd - cr)
                if rim < 0.022:
                    col = lerp(col, (176, 170, 148), (1 - smooth(0.006, 0.022, rim)) * 0.9)
                # brilho na borda oposta
                if abs(dd - cr * 0.98) < 0.018 and (u - cx) + (v - cy) > 0:
                    col = lerp(col, (252, 249, 236), 0.5)
            # contorno claro desenhado
            ring = abs(d - (R - 3))
            if ring < 3.2:
                col = lerp(col, (252, 250, 240), (1 - smooth(1.0, 3.2, ring)) * 0.9)
            a_ = cov + halo_a * (1 - cov)
            if a_ > 0:
                mix = cov / a_
                r_ = col[0] * mix + 175 * (1 - mix)
                g_ = col[1] * mix + 195 * (1 - mix)
                b_ = col[2] * mix + 255 * (1 - mix)
        row.append((int(max(0, min(255, r_))), int(max(0, min(255, g_))), int(max(0, min(255, b_))), int(max(0, min(255, a_ * 255)))))
    pix.append(row)
png(os.path.join(OUT, "lua.png"), N, N, pix)

# ---------- brilho de vela (primeira versão, descartada) ----------
W, H = 128, 160
pix = []
for y in range(H):
    row = []
    for x in range(W):
        u = (x + 0.5 - W / 2) / (W / 2)
        v = (y + 0.5 - H * 0.62) / (H * 0.55)
        d = min(1.0, math.hypot(u, v))
        # chama: núcleo quente, laranja, castanho escuro nas bordas
        if d < 0.12:
            col = lerp((255, 226, 160), (255, 196, 110), d / 0.12)
        elif d < 0.45:
            col = lerp((255, 196, 110), (226, 112, 40), (d - 0.12) / 0.33)
        elif d < 0.8:
            col = lerp((226, 112, 40), (96, 44, 20), (d - 0.45) / 0.35)
        else:
            col = lerp((96, 44, 20), (34, 18, 12), (d - 0.8) / 0.2)
        a = 0.96 if d < 0.8 else 0.96
        row.append((int(col[0]), int(col[1]), int(col[2]), int(a * 255)))
    pix.append(row)
png(os.path.join(OUT, "vela.png"), W, H, pix)
print("ok", os.listdir(OUT))
