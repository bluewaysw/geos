#!/usr/bin/env python3
"""Patch Calculator 128 V2.0 (CALC128.CVT, cbmfiles) for GEOS65: float
maths with the C64 BASIC ROM of the MEGA65 ROM image (MAP).
usage: calc_patch.py calc128.cvt out.cvt calc_bridge.bin"""
import sys
src, dst, br = sys.argv[1:4]
d = bytearray(open(src, 'rb').read()); bridge = open(br, 'rb').read()
assert d[21] == 0 and d[3:13] == b'calculator'
LOAD = 0x1000
def off(a): return 508 + a - LOAD
def patch(a, old, new, what):
    o = off(a)
    assert bytes(d[o:o+len(old)]) == bytes(old), '%s: $%04X has %s' % (what, a, d[o:o+len(old)].hex(' '))
    d[o:o+len(new)] = bytes(new)
    print('  $%04X %-30s %s -> %s' % (a, what, bytes(old).hex(' '), bytes(new).hex(' ')))
# enter (L16BB, 51 bytes) and exit (L16EE, 18 bytes)
patch(0x16BB, [0xA2, 0x0C, 0xBD, 0x26, 0x1E], [0x4C, 0x80, 0x1E, 0xEA, 0xEA], 'enter: jmp mapC64')
patch(0x16EE, [0xAD, 0x1E, 0x1E, 0x8D, 0x00, 0xFF], [0x4C, 0x80 + 0, 0x1E, 0xEA, 0xEA, 0xEA], 'exit: jmp unmapC64')
# unmapC64 address from the bridge layout
um = 0x1E80 + bridge.index(bytes([0xAD, 0x98, 0x88]))   # lda highMap
d[off(0x16EF)] = um & 255; d[off(0x16F0)] = um >> 8
print('  unmapC64 at $%04X' % um)
# bridge into the old $0380 save area
o = off(0x1E80)
assert o + len(bridge) <= off(0x1ED0)   # $1ED0 is used elsewhere
d[o:o+len(bridge)] = bridge
print('  $1E80 bridge (%d bytes)' % len(bridge))
# VAL: jsr $00AC -> jsr $1E26; $1E26: ($24) -> ($22), A = length, STRVAL
patch(0x1578, [0x20, 0xAC, 0x00], [0x20, 0x26, 0x1E], 'VAL call')
patch(0x1E26, [0xAD, 0x00, 0xFF, 0x48, 0x8A, 0x20, 0x09, 0xAF, 0x68, 0x8D, 0x00, 0xFF, 0x60],
      [0xA5, 0x24, 0x85, 0x22, 0xA5, 0x25, 0x85, 0x23, 0x8A, 0x4C, 0xB5, 0xB7, 0xEA], 'VAL -> STRVAL $B7B5')
# C128 math jump table -> C64 BASIC ROM
calls = {0x1103: (0xAF06, 0xBDDD, 'FOUT'), 0x15A2: (0xAF66, 0xBBD4, 'MOVMF'), 0x15D1: (0xAF66, 0xBBD4, 'MOVMF'),
         0x15F2: (0xAF63, 0xBBA2, 'MOVFM'), 0x161D: (0xAF5D, 0xBA8C, 'ROMUPK->CONUPK'), 0x162E: (0xAF21, 0xBA2B, 'FMULTT'),
         0x1639: (0xAF27, 0xBB12, 'FDIVT'), 0x1644: (0xAF1B, 0xB86A, 'FADDT'), 0x164F: (0xAF15, 0xB853, 'FSUBT'),
         0x165E: (0xAF66, 0xBBD4, 'MOVMF')}
for a, (o_, n_, what) in sorted(calls.items()):
    patch(a, [0x20, o_ & 255, o_ >> 8], [0x20, n_ & 255, n_ >> 8], what)
open(dst, 'wb').write(d)
print('written', dst)
