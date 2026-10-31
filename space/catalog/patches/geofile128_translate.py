#!/usr/bin/env python3
"""geoFile 128: replace the german messages of the copies in circulation
(Finke collection, planetemu d64) with english ones.

usage: geofile128_translate.py  (in a directory with GEOFILE_128_finke.cvt,
       the copy from the Finke collection)
       -> GEOFILE_128_en.cvt

Only texts are replaced; record 1 (encrypted, installed serial number),
the directory entry and the header block stay unchanged.

The english texts follow the english geoFile 64 V1.4 (lyonlabs
geofile.d64) where they fit; every text is replaced in place and is at
most as long as the german one; the rest is filled with spaces, never
NUL: geoFile finds messages by counting NUL-terminated strings, so an
extra NUL shifts every following message (crash when saving).
"""
import sys
T = [  # record, offset, german, english
 (0,6694,'Austausch','swapping'),
 (0,6745,'Ladefehler','loading'),
 (0,6757,'keine Datendisk','No data-disk'),
 (0,9950,'Geht nicht bei Sortierfeld.',"Can't do this to sort field"),
 (0,9987,'Geht nicht im Sub-Layout',"Can't do in a sub-layout"),
 (0,10106,'Buffor voll','Buffer full'),
 (0,10257,'Grafikfeld nicht wiederherstelbar.',"Can't recover a picture field"),
 (0,10757,'Kein platz f.Felder.','No space for fields.'),
 (0,14547,'Progr. & Daten m}ssen','GeoFile & data file'),
 (0,14572,'bei i-Laufw.-Systemen auf','on one-drive systems'),
 (0,14601,'selber Disk sein.','must share a disk'),
 (2,3862,'Sortierfeld unl|schbar!',"Can't delete sort field"),
 (2,3957,'Nur alphanumerische Sortierfelder.','Sort field must be text/number.'),
 (2,3993,'Kann lange dauern.','May take a while.'),
 (2,4013,'Weiter?','Go on?'),
 (2,4023,'Felddaten','fld. data'),
 (2,4035,'Feldname','fld name'),
 (2,4046,'fett','bold'),
 (2,4053,'unterstrichen','underline'),
 (2,4069,'kursiv','italic'),
 (3,3879,'Vor Dateneingabe m}ssen','Before entering data,'),
 (3,3903,'Sie im Men} ','use in menu '),
 (3,3916,"'Feld'",'field:'),
 (3,3925,"'Sortierfeld setzen'","'set sort field'"),
 (3,3947,'w{hlen.','first.'),
 (3,3956,'Kein Ersetzen im Sortierfeld.',"Can't replace in sort field."),
 (5,1706,'Dennoch weiter drucken?','Continue printing?'),
 (5,1732,'Blatt ist','Form is'),
 (5,1743,'Punkte zu gro~ f}r','pixels too big for'),
 (5,1764,'Karteikrt.','index card'),
 (5,1777,'Etik.','label'),
 (5,2139,'Druck','Print'),
 (5,2147,'Spalten-','Column'),
 (5,2165,'Endlospapier','tractor feed'),
 (5,2180,'Etik.','label'),
 (5,2188,'Karteikart.','index cards'),
 (6,2270,'Drucker nicht verf}gbar.','Printer not accessible.'),
 (7,999,'Einf}gung','Merge'),
 (7,1011,'Alle Bl.','All frm.'),
 (7,1022,'Ausgew{hlte Bl.','Selected forms'),
 (7,1040,'Aktl Blatt','Curr. form'),
 (7,1053,'Wlch. Scrap?','Which scrap?'),
 (7,1068,'Wlch. Blatt?','Which form?'),
 (7,1447,'Geht nicht bei Grafik',"Can't copy a picture"),
 (7,2432,'b.Gener.V. Einsetzdatei.','creating merge data.'),
 (7,2487,'Text nicht in Bild einf}gbar',"Can't paste text on picture"),
 (7,2630,'Kein Text-Scrap auf Disk.','No text scrap on disk.'),
 (7,2984,'Scrap zu gro~.','Scrap too big.'),
 (7,3101,'bei Scrap.','on scrap.'),
 (7,3259,'Kein Druckertreiber ausgew{hlt.','No printer driver is selected.'),
 (7,3294,'Bitte unter desktop','On the deskTop use'),
 (7,3317,"'Drucker w{hlen' w{hlen","'select printer'"),
 (7,3342,'bei Druckertreiber','with printer drv.'),
 (7,3361,'Finde keinen Druckertreiber namens:',"Can't find printer driver named:"),
 (7,3399,'b. Text-Scrap-Generierung','while creating text scrap'),
 (8,869,'Datens{tz zu gro~ z. Speichern.','Record too big to be saved.'),
 (8,1015,' Bl{tter in Datenbank',' form(s) in database'),
 (9,1439,'Datei wird aktualisiert.','Updating file on disk.'),
 (9,2144,'Diskette fast voll:','Disk near full.'),
 (9,2167,'zuerst Dateien von Diskette','Please move/delete files'),
 (9,2198,'l|schen/kopieren.','from disk first.'),
 (9,3571,'geoFile 128 von John Wedgwood','geoFile 128 by John Wedgwood'),
 (9,3643,'Kein Speicher auf Disk','No free space on disk'),
 (9,3669,'f}r Hilfsmittel','for desk acc.'),
 (9,3686,'in Hilfsmittel','in desk acc.'),
 (9,3702,'Bitte ausw{hlen:','Please select:'),
 (9,3720,'Neue Datei','New file'),
 (9,3731,'Vorhandene Datei','Existing file'),
 (9,3748,'Zum desktop','To deskTop'),
 (9,3761,'Neue Diskette einlegen.','Insert new disk.'),
 (9,3786,'Dateiname schon vergeben.','File exists, choose new.'),
 (9,3814,'Datei h|her als V1.0','File beyond V1.0'),
 (9,3844,'ACHTUNG!','WARNING!'),
 (9,3853,'Datei schreibgesch}tzt.','File write protected.'),
 (9,3878,'Neuer Dateiname:','New filename:'),
 (9,3896,'beim |ffnen','on opening'),
 (9,3908,'b. Erstellen','on creating'),
 (9,3922,'Foto-Scrap h|her als V1.0','photoScrap beyond V1.0'),
 (9,3949,'Datei-Bildspeicher voll.','File picture area full.'),
 (9,3975,'Kein Foto-Scrap auf Disk.','No photoScrap on disk.'),
 (9,4002,'Foto-Scrap zu gro~.','photoScrap too big.'),
 (9,4034,'b. }bernahme von','while copying'),
 (9,4054,'Foto-Scrap.','photoScrap.'),
 (10,56,'Erst Sortierfeld w{hlen.','Select sort field first.'),
 (10,93,'Layout {ndern','change layout'),
 (10,1380,'Neuer Layout Name...','New layout name...'),
 (10,1404,'Layout leer.','Empty layout'),
 (10,1830,'Leeres Layout unverwendbar.',"Can't use an empty layout."),
 (10,1867,'Originallayout unl|schbar.',"Can't delete orig. layout."),
 (10,1923,'Dieser Befehl l|scht','This will delete'),
 (10,1946,'das Layout.','the layout.'),
 (10,1958,'Fortfahren?','Continue?'),
]
def rec_offsets(d):
    t=d[508:762]; pos=762; out=[]
    for i in range(127):
        b,l=t[2*i],t[2*i+1]
        out.append(pos if b else None); pos+=b*254
    return out
d=bytearray(open('GEOFILE_128_finke.cvt','rb').read()); ro=rec_offsets(d)
nul=sp=0
for r,o,g,e in T:
    p=ro[r]+o
    assert bytes(d[p:p+len(g)])==g.encode(), (r,o,g,bytes(d[p:p+len(g)]))
    assert len(e)<=len(g), (g,e)
    after=d[p+len(g)]
    pad = b' '        # never NUL: geoFile finds messages by counting strings
    if after==0: nul+=1
    else: sp+=1
    d[p:p+len(g)] = e.encode() + pad*(len(g)-len(e))
open('GEOFILE_128_en.cvt','wb').write(d)
print('%d texts replaced (%d padded with NUL, %d with spaces)'%(len(T),nul,sp))
