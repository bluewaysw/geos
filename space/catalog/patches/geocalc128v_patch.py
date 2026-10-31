#!/usr/bin/env python3
"""Patch GEOCALC 128 from vtda.org GEOCALC128.D64 (older build than the
Finke copy) for GEOS65: C64 BASIC floats, as geocalc128_patch.py.
usage: geocalc128v_patch.py GEOCALC128_vtda.cvt out.cvt bridge_v.bin
  (python3 d64tocvt.py GEOCALC128.D64 "GEOCALC 128" GEOCALC128_vtda.cvt;
   ca65 --cpu 4510 geocalc128v_bridge.s; ld65 -t none -S 0x041F -o bridge_v.bin)"""
import sys
src, dst, br = sys.argv[1:4]
d = bytearray(open(src, 'rb').read()); base = 762
def off(a): return base + a - 0x400
def patch(a, old, new, what):
    o = off(a); assert bytes(d[o:o+len(old)]) == bytes(old), (what, hex(a)); d[o:o+len(new)] = bytes(new)
bridge = open(br, 'rb').read(); assert len(bridge) == 0x05AC - 0x041F
patch(0x041F, [0x78, 0xAD, 0xFF, 0xFF], bridge[:4], 'bridge'); d[off(0x041F):off(0x041F)+len(bridge)] = bridge
patch(0x05BB, [0x20, 0x03, 0xAF], [0x20, 0x91, 0xB3], 'GIVAYF')
patch(0x05BE, [0x20, 0x06, 0xAF], [0x20, 0xDD, 0xBD], 'FOUT')
tab = {9: (0xAF48, 0xE30E), 10: (0xAF3F, 0xE264), 11: (0xAF3C, 0xBFED), 12: (0xAF2A, 0xB9EA),
       13: (0xAF57, 0xE0D3), 14: (0xAF42, 0xE26B), 15: (0xAF30, 0xBF71), 16: (0xAF45, 0xE2B4)}
for k, (o_, n_) in tab.items():
    patch(0x3AD3 + k, [o_ & 255], [n_ & 255], 'table lo'); patch(0x3AF3 + k, [o_ >> 8], [n_ >> 8], 'table hi')
for a in (0x3B42, 0x3B56, 0x3FA4):
    patch(a, [0xA9, 0xAF, 0x85, 0x0F, 0xA9, 0x2A, 0x85, 0x0E], [0xA9, 0xB9, 0x85, 0x0F, 0xA9, 0xEA, 0x85, 0x0E], 'LOG')
open(dst, 'wb').write(d); print('written', dst)
