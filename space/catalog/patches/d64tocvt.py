import sys
src={}
exec(open(__file__.rsplit('/',1)[0]+'/d64read.py').read(), src)
def d64_to_cvt(d64, name, out):
    img=open(d64,'rb').read()
    e=next(x for x in src['entries'](img) if x[5:5+len(name)]==name.encode() and x[5+len(name)] in (0xA0,))
    nm,cls,auth,info,gt,recs,hdr=src['geosinfo'](img,e)
    de=bytearray(254); de[0:30]=e[2:32]; de[30:58]=b'PRG formatted GEOS file V1.0'
    hd=bytes(hdr[2:256])
    rt=bytearray(254); data=b''
    for i,r in enumerate(recs):
        if r is None: continue
        b=(len(r)+253)//254; rt[2*i]=b; rt[2*i+1]=len(r)-(b-1)*254+1
        data+=r+bytes(b*254-len(r))
    open(out,'wb').write(bytes(de)+hd+bytes(rt)+data)
if __name__=='__main__': d64_to_cvt(sys.argv[1], sys.argv[2], sys.argv[3])
