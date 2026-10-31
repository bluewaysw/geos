# D64 + GEOS VLIR reader used by d64tocvt.py
import sys
SPT=[0]+[21]*17+[19]*7+[18]*6+[17]*5+[17]*5
def off(t,s): return (sum(SPT[1:t])+s)*256
def sec(img,t,s): o=off(t,s); return img[o:o+256]
def chain(img,t,s):
    out=b''
    while t:
        b=sec(img,t,s)
        if b[0]==0: out+=b[2:b[1]+1]; break
        out+=b[2:]; t,s=b[0],b[1]
    return out
def entries(img):
    t,s=18,1
    while t:
        b=sec(img,t,s)
        for k in range(8):
            e=b[k*32:k*32+32]
            if e[2]: yield e
        t,s=b[0],b[1]
def geosinfo(img,e):
    name=e[5:21].split(b'\xa0')[0].decode('latin1')
    hdr=sec(img,e[21],e[22])
    cls=hdr[0x4d:0x4d+20].split(b'\0')[0].decode('latin1')
    auth=hdr[0x61:0x61+20].split(b'\0')[0].decode('latin1')
    info=hdr[0xa0:0xa0+96].split(b'\0')[0].decode('latin1')
    recs=[]
    if e[23]==1:
        idx=sec(img,e[3],e[4])
        for i in range(127):
            t,s=idx[2+2*i],idx[3+2*i]
            recs.append(chain(img,t,s) if t else None)
    else:
        recs=[chain(img,e[3],e[4])]
    return name,cls,auth,info,e[24],recs,hdr
