#!/usr/bin/env python3
"""Decode a GeoSpace catalog file (CVT) the way GeoSpace reads it and
compare every reconstructed download URL with the JSON entries.
usage: checkcatalog.py catalog.cvt [entries.json]"""
import sys, json, re

def cvt_records(d):
    assert d[21] == 1, 'not a VLIR file'
    table = d[508:762]
    recs, pos = [], 762
    for i in range(127):
        blocks, last = table[2 * i], table[2 * i + 1]
        if blocks == 0:
            recs.append(None if last == 0 else b''); continue
        size = (blocks - 1) * 254 + (last - 1)
        recs.append(d[pos:pos + size]); pos += blocks * 254
    return recs

def cstr(b, p):
    e = b.index(0, p); return b[p:e].decode('ascii'), e + 1

def quote6502(name):                     # same rule as the 6502 code will use
    out = ''
    for c in name.encode('ascii'):
        ch = chr(c)
        out += ch if (ch.isalnum() or ch in '_.-~') else '%%%02X' % c
    return out

def main():
    d = open(sys.argv[1], 'rb').read()
    want_json = json.load(open(sys.argv[2])) if len(sys.argv) > 2 else None
    recs = cvt_records(d)
    info = recs[0]
    assert info[:4] == b'GSC\x02', 'not a GeoSpace catalog (version 2)'
    n = info[4] | info[5] << 8; npages = info[6]
    host, p = cstr(info, 7)
    firsts = [info[p + k] | info[p + npages + k] << 8 for k in range(npages)]
    dt = recs[1]; prefix, p = cstr(dt, 1); disks = []
    for _ in range(dt[0]):
        s_, p = cstr(dt, p); disks.append(s_)
    entries = []
    for pg in range(npages):
        r = recs[3 + pg]
        assert len(entries) == firsts[pg], 'page table'
        for k in range(r[0]):
            off = r[1 + 2 * k] | r[2 + 2 * k] << 8
            flags, kb, y, mo, dd, di = r[off:off + 6]; p = off + 6
            name, p = cstr(r, p); cls, p = cstr(r, p); auth, p = cstr(r, p); desc, p = cstr(r, p)
            fname = cstr(r, p)[0] if flags & 2 else quote6502(name) + '.cvt'
            url = disks[di] if flags & 16 else (disks[di] if disks[di].startswith('/') else prefix + disks[di]) + '/' + fname
            entries.append(dict(name=name, flags=flags, url=url))
    hdr = d[254:508]
    print('catalog "%s" class %r: %d entries, %d pages, host %s' % (
        d[3:19].split(b'\xa0')[0].decode(), hdr[0x4D-2:0x4D-2+16].decode(), n, npages, host))
    assert len(entries) == n
    srt = [e['name'].lower() for e in entries]
    print('sorted: %s' % (srt == sorted(srt)))
    if want_json:
        want = lambda c: c.get('d64path') or c.get('urlpath') or prefix + c['path'][len('/docs/finke/'):]
        bad = [(e['name'], e['url'], want(c)) for e, c in zip(entries, want_json) if e['url'] != want(c)]
        print('URL mismatches: %d' % len(bad))
        for b in bad[:5]: print('  ', b)
        return 1 if bad else 0
    for e in entries: print('  %-16s flags %02x  http://%s%s' % (e['name'], e['flags'], host, e['url']))
    return 0

if __name__ == '__main__':
    sys.exit(main())
