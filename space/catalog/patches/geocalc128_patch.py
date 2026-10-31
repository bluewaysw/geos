#!/usr/bin/env python3
"""Patch 'GeoCalc 128' (geoCalc V1.0, Finke collection) for GEOS65.

usage: geocalc128_patch.py GeoCalc_128.cvt out.cvt [bridge.bin]

- floating point: C128 ROM math -> C64 BASIC/KERNAL ROM of the MEGA65 ROM
  image, mapped in with MAP by a new ROM bridge ($041F-$05B1, bridge.s)
- function table and fixed calls: C128 $AFxx entries -> C64 addresses
- info text: ' @71B9' appended (GEOS65 sets the serial number from it)
Every change checks the original bytes first; nothing is written if the
file is not the expected version.
"""
import sys, os

def records(d):
    t = d[508:762]; pos = 762; out = []
    for i in range(127):
        b, l = t[2*i], t[2*i+1]
        if b == 0:
            out.append(None); continue
        size = (b - 1) * 254 + (l - 1)
        out.append([pos, size]); pos += b * 254
    return out

def main():
    src, dst = sys.argv[1], sys.argv[2]
    bridge = open(sys.argv[3] if len(sys.argv) > 3 else
                  os.path.join(os.path.dirname(__file__), 'bridge.bin'), 'rb').read()
    d = bytearray(open(src, 'rb').read())
    assert d[21] == 1, 'not a VLIR file'
    rec0_pos, rec0_len = records(d)[0]
    def off(addr):                      # record 0 is loaded at $0400
        assert 0x400 <= addr < 0x400 + rec0_len
        return rec0_pos + addr - 0x400
    def patch(addr, old, new, what):
        o = off(addr)
        assert bytes(d[o:o+len(old)]) == bytes(old), '%s: unexpected bytes at $%04X: %s' % (what, addr, d[o:o+len(old)].hex())
        d[o:o+len(new)] = bytes(new)
        print('  $%04X %-34s %s -> %s' % (addr, what, bytes(old).hex(' '), bytes(new).hex(' ')))

    print('record 0 at file offset %d, %d bytes' % (rec0_pos, rec0_len))
    # 1. ROM bridge (check the start and the end of the original code)
    patch(0x041F, [0x78, 0xAD, 0xFF, 0xFF], bridge[:4], 'bridge start (sei/lda $FFFF)')
    o = off(0x041F)
    assert d[off(0x0525):off(0x0525)+3] == b'\x6c\x02\x00', 'bridge: JMP ($0002) not at $0525'
    d[o:o+len(bridge)] = bridge
    assert len(bridge) == 0x05B2 - 0x041F
    print('  $041F-$05B1 ROM bridge replaced (%d bytes)' % len(bridge))
    # 2. integer -> float -> text in $05BA
    patch(0x05C1, [0x20, 0x03, 0xAF], [0x20, 0x91, 0xB3], 'GIVAYF $AF03 -> $B391')
    patch(0x05C4, [0x20, 0x06, 0xAF], [0x20, 0xDD, 0xBD], 'FOUT   $AF06 -> $BDDD')
    # 3. function table: lo bytes at $3B15, hi bytes at $3B35
    table = {9: (0xAF48, 0xE30E, 'ATN'), 10: (0xAF3F, 0xE264, 'COS'), 11: (0xAF3C, 0xBFED, 'EXP'),
             12: (0xAF2A, 0xB9EA, 'LOG'), 13: (0xAF57, 0xE0D3, 'RND'), 14: (0xAF42, 0xE26B, 'SIN'),
             15: (0xAF30, 0xBF71, 'SQR'), 16: (0xAF45, 0xE2B4, 'TAN')}
    for i, (old, new, name) in table.items():
        patch(0x3B15 + i, [old & 255], [new & 255], 'table[%d] %s lo' % (i, name))
        patch(0x3B35 + i, [old >> 8], [new >> 8], 'table[%d] %s hi' % (i, name))
    # 4. fixed LOG calls: lda #>$AF2A / sta $0F / lda #<$AF2A / sta $0E
    pat = bytes([0xA9, 0xAF, 0x85, 0x0F, 0xA9, 0x2A, 0x85, 0x0E])
    r0 = bytes(d[rec0_pos:rec0_pos+rec0_len]); n = 0; p = r0.find(pat)
    while p >= 0:
        patch(0x400 + p, pat, [0xA9, 0xB9, 0x85, 0x0F, 0xA9, 0xEA, 0x85, 0x0E], 'LOG call $AF2A -> $B9EA')
        n += 1; p = r0.find(pat, p + 1)
    assert n == 3, 'expected 3 fixed LOG calls, found %d' % n
    # 5. info text in the GEOS header block (CVT offset 254 + $A0 - 2)
    io = 254 + 0xA0 - 2
    info = bytes(d[io:io+96]).split(b'\0')[0]
    assert info == b'geoCalc 128 is a powerful and easy to use spreadsheet.', info
    new = info + b' @71B9'
    assert len(new) < 96
    d[io:io+len(new)+1] = new + b'\0'
    print('  info text: %r' % new.decode())
    open(dst, 'wb').write(d)
    print('written', dst)

if __name__ == '__main__':
    main()
