import math, struct, zlib, os

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


# brilho de vela, tom entre amarelado e alaranjado, sem vermelho, escuro nas bordas
W, H = 128, 160
pix = []
for y in range(H):
    row = []
    for x in range(W):
        u = (x + 0.5 - W / 2) / (W / 2)
        v = (y + 0.5 - H * 0.64) / (H * 0.58)
        d = min(1.0, math.hypot(u, v))
        if d < 0.10:
            col = lerp((255, 226, 156), (255, 206, 118), d / 0.10)
        elif d < 0.42:
            col = lerp((255, 206, 118), (236, 160, 66), (d - 0.10) / 0.32)
        elif d < 0.78:
            col = lerp((236, 160, 66), (120, 82, 38), (d - 0.42) / 0.36)
        else:
            col = lerp((120, 82, 38), (34, 26, 18), (d - 0.78) / 0.22)
        row.append((int(col[0]), int(col[1]), int(col[2]), 245))
    pix.append(row)
png(os.path.join(OUT, "vela2.png"), W, H, pix)
print("ok")
