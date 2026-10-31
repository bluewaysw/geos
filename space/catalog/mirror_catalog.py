#!/usr/bin/env python3
"""Download every file of the GeoSpace catalog from www.pagetable.com (https)
into a local directory tree with the same paths, ready to be copied to a
plain-HTTP web server (GeoSpace cannot do https).

usage: mirror_catalog.py catalog.json <outdir>
  -> <outdir>/docs/finke/<category>/<disk>/<file>.cvt
Then generate the catalog for the mirror and rebuild GeoSpace:
  mkcatalog.py <page.htm> space/catalog --host www.bluewaysw.de --url-prefix /docs/finke/
The server must answer plain http on port 80 with "HTTP/1.1 200" (no
redirect to https) and map %20 in the URL to a space in the file name
(all common web servers do).
"""
import json, os, sys, time, urllib.parse, urllib.request

cat = json.load(open(sys.argv[1]))
out = sys.argv[2]
ok = fail = 0
for e in cat:
    rel = urllib.parse.unquote(e['path']).lstrip('/')
    dst = os.path.join(out, rel)
    if os.path.exists(dst) and os.path.getsize(dst) > 0:
        ok += 1; continue
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    url = 'https://www.pagetable.com' + e['path']
    try:
        data = urllib.request.urlopen(url, timeout=30).read()
        open(dst, 'wb').write(data); ok += 1
    except Exception as x:
        print('FAILED', url, x); fail += 1
    time.sleep(0.5)                      # be gentle with pagetable.com
print('%d files ok, %d failed' % (ok, fail))
