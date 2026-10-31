#!/usr/bin/env python3
"""Generate a GeoSpace download catalog file (GEOS VLIR data file, as CVT)
from the Finke collection page (https://www.pagetable.com/docs/finke/,
saved as HTML) and/or a JSON list of entries.

usage: mkcatalog.py <page.htm> <outdir> [--types Application,Desk Acc]
                    [--page-size 2048] [--first-record 4]
                    [--host web.archive.org]
                    [--url-prefix /web/<timestamp>id_/https://www.pagetable.com/docs/finke/]
The download URL is http://<host><url-prefix><disk>/<file>; the default is
the Wayback Machine copy of pagetable.com (plain http, no https redirect).
The timestamp 29991231235959 makes the Wayback Machine redirect to the
newest capture (an older failed capture would otherwise be picked if it
is closer to the requested time).

Writes to <outdir>:
  catalog.inc         constants + page table for the catalog overlay
  catalog_data.s      VLIR records: disk path table + catalog pages
  catalog.json        the selected entries (for review / tests)

Record layout (all little endian):
  disk table record:  n, url prefix, then n disk paths relative to
                      /docs/finke/ (e.g. "geos-apps/geos-app_xyz"), zero-terminated
  catalog page:       n, n words: entry offset from page start, entries:
     flags (bit0 VLIR, bit1 explicit file name follows, bit2 desk accessory,
            bit3 GEOS65 patch available, bit4 GEOS file inside a .d64 image,
            bit5 tested on GEOS65 ("tested": true in the JSON)), kb,
     year-1900, month, day, disk index,
     name, class, author, description [, file name]   (zero-terminated)
  Without an explicit file name the download file is
  quote(name) + ".cvt", quote = %XX for every byte not in A-Za-z0-9_.-~
"""
import re, os, sys, html, json, argparse, urllib.parse

PREFIX = '/docs/finke/'
TRANS = {'ä': 'ae', 'ö': 'oe', 'ü': 'ue', 'Ä': 'Ae', 'Ö': 'Oe', 'Ü': 'Ue',
         'ß': 'ss', 'é': 'e', 'è': 'e', 'à': 'a', '´': "'", '`': "'",
         '“': '"', '”': '"', '„': '"', '’': "'", '–': '-', '—': '-'}

def text(s):
    s = re.sub(r'<br\s*/?>', ' ', s)
    s = re.sub(r'<[^>]+>', '', s)
    return re.sub(r'\s+', ' ', html.unescape(s)).strip()

def ascii(s, maxlen=None):
    out = ''.join(TRANS.get(c, c) for c in s)
    out = ''.join(c if 32 <= ord(c) < 127 else '?' for c in out)
    return out[:maxlen] if maxlen else out

def quote(name):
    return urllib.parse.quote(name, safe='')       # same rule as on the C64 side

def parse(page):
    rows = re.split(r'<tr\b', page)
    out = []
    for i, r in enumerate(rows):
        if 'class="dc-filename"' not in r:
            continue
        m = re.search(r'class="dc-dl"><a href="([^"]+\.cvt)"', r)
        if not m:
            continue
        def cell(cls):
            mm = re.search(r'<td class="%s">(.*?)</td>' % cls, r, re.S)
            return text(mm.group(1)) if mm else ''
        tds = re.findall(r'<td[^>]*>(.*?)</td>', r, re.S)
        desc = ''
        if i + 1 < len(rows) and 'class="dc-desc"' in rows[i + 1]:
            dm = re.search(r'class="dc-desc">(.*?)</td>', rows[i + 1], re.S)
            desc = text(dm.group(1)) if dm else ''
        url = html.unescape(m.group(1))
        out.append(dict(name=cell('dc-filename'),
                        kb=int(re.sub(r'\D', '', cell('dc-kb')) or 0),
                        type=cell('dc-geos-type'),
                        cls=re.sub(r'\s+', ' ', cell('dc-class')),
                        struct=text(tds[6]) if len(tds) > 6 else '',
                        date=cell('dc-date')[:10], author=cell('dc-author'),
                        path=urllib.parse.urlsplit(url).path, desc=desc))
    return out

def select(entries, types):
    seen = {}
    for e in entries:
        if e['type'] not in types:
            continue
        k = (e['name'].lower(), e['cls'].lower())
        seen.setdefault(k, e)
    return sorted(seen.values(), key=lambda e: (ascii(e['name']).lower(), e['cls'].lower()))

def diskkey(e):
    # .d64 entries: the absolute request path of the image; "urlpath"
    # entries: the absolute directory of the file
    if 'd64path' in e: return e['d64path']
    if 'urlpath' in e: return e['urlpath'].rsplit('/', 1)[0]
    return e['path'][len(PREFIX):].rsplit('/', 1)[0]

def encode(cat, patched=()):
    disks = sorted({diskkey(e) for e in cat})
    assert all('d64path' in e or 'urlpath' in e or e['path'].startswith(PREFIX) for e in cat)
    assert len(disks) < 256
    dix = {d: i for i, d in enumerate(disks)}
    blobs = []
    for e in cat:
        if 'd64path' in e:          # file name = GEOS name inside the image
            fname = ''; derivable = True
            assert e['d64path'].startswith('/') and ascii(e['name']) == e['name']
        elif 'urlpath' in e:        # any file on the catalog host, explicit name
            fname = e['urlpath'].rsplit('/', 1)[1]; derivable = False
            assert e['urlpath'].startswith('/')
        else:
            fname = e['path'].rsplit('/', 1)[1]
            derivable = (fname == quote(e['name']) + '.cvt' and ascii(e['name']) == e['name'])
        flags = (1 if e['struct'] == 'VLIR' else 0) | (0 if derivable else 2) | \
                (4 if e['type'] == 'Desk Acc' else 0) | (8 if e.get('m65', e['name'] in patched) else 0) | \
                (16 if 'd64path' in e else 0) | (32 if e.get('tested') else 0)
        y, mo, d = (e['date'] + '-0-0-0').split('-')[:3] if e['date'] else ('1900', '0', '0')
        b = bytes([flags, min(e['kb'], 255), max(0, int(y or 1900) - 1900), int(mo or 0), int(d or 0),
                   dix[diskkey(e)]])
        for s, mx in ((e['name'], 16), (e['cls'], 20), (e['author'], 24), (e['desc'], 160)):
            b += ascii(s, mx).encode('ascii') + b'\0'
        if not derivable:
            assert all(32 < ord(c) < 127 for c in fname), fname
            b += fname.encode('ascii') + b'\0'
        blobs.append(b)
    return disks, blobs

def paginate(blobs, page_size):
    pages, cur, size = [], [], 1
    for b in blobs:
        need = 2 + len(b)
        if cur and size + need > page_size:
            pages.append(cur); cur, size = [], 1
        cur.append(b); size += need
    if cur:
        pages.append(cur)
    out = []
    for p in pages:
        hdr = 1 + 2 * len(p)
        offs, pos = [], hdr
        for b in p:
            offs.append(pos); pos += len(b)
        data = bytes([len(p)]) + b''.join(o.to_bytes(2, 'little') for o in offs) + b''.join(p)
        assert len(data) <= page_size and page_size <= 2048
        out.append(data)
    return out


CAT_CLASS = 'GSCatalog   V1.0'          # GEOS class of catalog files (16 chars)
MAX_LOC, MAX_FILE, MAX_PAGES, MAX_HOST = 160, 31, 64, 39   # GeoSpace buffers

def petname(n):
    return n.encode('ascii')[:16].ljust(16, b'\xa0')

def write_cvt(fn, name, records, info, author='bluewaysw'):
    """GEOS VLIR data file (APPL_DATA, class CAT_CLASS) in CVT format"""
    import time
    blocks = [(len(r) + 253) // 254 for r in records]
    lt = time.localtime()
    de = bytearray(254)
    de[0] = 0x83                                     # USR, closed
    de[3:19] = petname(name)
    de[21] = 1                                       # VLIR
    de[22] = 7                                       # APPL_DATA
    de[23:28] = bytes([lt.tm_year % 100, lt.tm_mon, lt.tm_mday, lt.tm_hour, lt.tm_min])
    size = sum(blocks) + 2
    de[28], de[29] = size & 255, size >> 8
    de[30:58] = b'PRG formatted GEOS file V1.0'
    hd = bytearray(254)                              # header block without link
    h = lambda o: o - 2
    hd[h(2)], hd[h(3)], hd[h(4)] = 3, 21, 0x80 | 63  # icon 24x21, 63 bytes follow
    icon = bytearray(63)
    for y in range(21):                              # a simple "list" icon
        row = [0xFF, 0xFF, 0xFF] if y in (0, 20) else [0x80, 0x00, 0x01]
        if y % 4 == 2 and 1 < y < 19:
            row = [0x9F, 0xFF, 0xF9]
        icon[3*y:3*y+3] = bytes(row)
    hd[h(5):h(5)+63] = icon
    hd[h(0x44)], hd[h(0x45)], hd[h(0x46)] = 0x83, 7, 1
    hd[h(0x4D):h(0x4D)+len(CAT_CLASS)] = CAT_CLASS.encode('ascii')
    hd[h(0x61):h(0x61)+len(author)] = author.encode('ascii')
    hd[h(0x75):h(0x75)+16] = b'GeoSpace    V1.0'          # parent application
    ib = info.encode('ascii')[:95]
    hd[h(0xA0):h(0xA0)+len(ib)] = ib
    rt = bytearray(254)
    for i, r in enumerate(records):
        b = blocks[i]
        rt[2*i] = b
        rt[2*i+1] = (len(r) - (b - 1) * 254) + 1
    data = b''.join(r + bytes(blocks[i] * 254 - len(r)) for i, r in enumerate(records))
    open(fn, 'wb').write(bytes(de) + bytes(hd) + bytes(rt) + data)

def patch_names(t):
    """GEOS names in a patch table (format: see mkpatches.py)"""
    p = 0
    while t[p]:
        e = t.index(0, p); yield t[p:e].decode('ascii'); p = e + 1
        while t[p]:
            if t[p] == 1:
                n = t[p+4]; p += 5 + 2 * n
            else:
                p = t.index(0, p + 1) + 1
        p += 1

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--page', help='saved HTML of https://www.pagetable.com/docs/finke/')
    ap.add_argument('--json-in', help='entries from a JSON list (e.g. a previous --json-out)')
    ap.add_argument('--extra', help='JSON list of additional entries; a "d64path" (absolute request path of a .d64 image) makes the entry a GEOS file extracted from that image')
    ap.add_argument('--types', default='Application,Desk Acc')
    ap.add_argument('--name', required=True, help='GEOS file name of the catalog')
    ap.add_argument('--info', default='GeoSpace download catalog')
    ap.add_argument('--cvt', required=True, help='catalog file to write (CVT)')
    ap.add_argument('--json-out', help='write the selected entries as JSON')
    ap.add_argument('--page-size', type=int, default=2048)
    ap.add_argument('--host', default='web.archive.org')
    ap.add_argument('--url-prefix', default='/web/29991231235959id_/https://www.pagetable.com/docs/finke/')
    ap.add_argument('--patches', help='patch table (mkpatches.py .bin): becomes record 2 of the catalog; entries with these GEOS names get the M65 flag')
    ap.add_argument('--without', default='', help='comma separated GEOS names that get no M65 flag in this catalog')
    a = ap.parse_args()
    cat = []
    if a.page:
        cat = select(parse(open(a.page, encoding='utf-8', errors='replace').read()),
                     {t.strip() for t in a.types.split(',')})
    if a.json_in:
        cat += json.load(open(a.json_in))
    if a.extra:
        extra = json.load(open(a.extra))
        for e in extra:
            e.setdefault('path', e.get('d64path', e.get('urlpath', '')))
            e.setdefault('struct', 'VLIR'); e.setdefault('desc', ''); e.setdefault('type', 'Application')
        cat += extra
        print('%d entries from %s' % (len(extra), a.extra))
    cat = sorted(cat, key=lambda e: (ascii(e['name']).lower(), e['cls'].lower()))
    assert cat, 'no entries'
    ptab = open(a.patches, 'rb').read() if a.patches else b'\0'
    patched = set(patch_names(ptab))
    patched -= {n.strip() for n in a.without.split(',') if n.strip()}
    disks, blobs = encode(cat, patched)
    pages = paginate(blobs, a.page_size)
    assert len(pages) <= MAX_PAGES and len(pages) + 3 <= 127
    assert a.url_prefix.startswith('/') and a.url_prefix.endswith('/')
    assert len(a.host) <= MAX_HOST
    for e in cat:                   # must fit the buffers of GeoSpace
        loc = len(diskkey(e)) + 1 if ('d64path' in e or 'urlpath' in e) else len(a.url_prefix) + len(diskkey(e)) + 1
        assert loc <= MAX_LOC, e['path']
        assert 'd64path' in e or len(e['path'].rsplit('/', 1)[1]) <= MAX_FILE, e['path']
    firsts, n = [], 0
    for p in pages:
        firsts.append(n); n += p[0]
    info = (b'GSC\x02' + bytes([len(cat) & 255, len(cat) >> 8, len(pages)]) +
            a.host.encode('ascii') + b'\0' +
            bytes([f & 255 for f in firsts]) + bytes([f >> 8 for f in firsts]))
    disk_rec = bytes([len(disks)]) + a.url_prefix.encode('ascii') + b'\0' + \
               b''.join(d.encode('ascii') + b'\0' for d in disks)
    assert len(disk_rec) <= 0xC00, 'disk table must fit $5400-$5FFF'
    assert len(ptab) <= 0x1400, 'patch table must fit $6C00-$7FFF'
    write_cvt(a.cvt, a.name, [info, disk_rec, ptab] + pages, a.info)
    if a.json_out:
        json.dump(cat, open(a.json_out, 'w'), ensure_ascii=False, indent=1)
    print('%s: "%s", %d entries, %d pages, disk table %d bytes, M65: %s' %
          (a.cvt, a.name, len(cat), len(pages), len(disk_rec), ', '.join(sorted({e['name'] for e in cat if e.get('m65', e['name'] in patched)})) or '-'))

if __name__ == '__main__':
    main()
