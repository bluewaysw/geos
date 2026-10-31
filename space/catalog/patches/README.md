# GeoSpace catalogs and GEOS65 patches

## Catalog files

The catalogs are GEOS VLIR data files (class "GSCatalog   V1.0", format
version 2), opened and closed in GeoSpace like documents; the Makefile
puts them on the GEOS disk, "Default Add-ons" first (GeoSpace opens the
first catalog of the drive at the start), both in the "Other Data" folder:

    record 0  info: "GSC", 2, entries, pages, host, first entry of each page
    record 1  disk path table (url prefix + disk paths)
    record 2  patch table of this catalog (see below)
    record 3  catalog pages

Entries whose GEOS name has a patch in the catalog's table are marked M65;
after downloading such an entry GeoSpace asks and applies the patch (the
patch code is record 3 of GEOSPACE, the table comes from the catalog).

## Patch tables

    cd space/catalog
    python3 mkpatches.py patches/finke.bin \
        "GeoCalc 128" "GeoCalc 128.cvt" GeoCalc_128_GEOS65.cvt \
        --info "GEOPUBLISH" " @184D" --info "GeoChart" " @19A0"
    python3 mkpatches.py patches/extra.bin \
        --info "GEOPUBLISH" " @184D" \
        "GEOFILE 128" "GEOFILE 128.cvt" GEOFILE_128_en.cvt \
        "GEOCALC 128" GEOCALC128_vtda.cvt GEOCALC128_vtda_GEOS65.cvt \
        "calculator" calc128.cvt calc128_GEOS65.cvt

Sequential GEOS files (like desk accessories) are patched along their
data chain ("record 0"); VLIR files along the record chains.

A pair "name original.cvt patched.cvt" becomes byte runs (original bytes
are checked before anything is written); --info only appends to the info
text (GEOS65 takes the serial number from "@xxxx").

## Generating the catalogs (committed as CVT)

    python3 mkcatalog.py --page <saved finke page.htm> --name "Finke Collection" \
        --info "GeoSpace catalog: applications and desk accessories of Klaus Finke's GEOS collection (pagetable.com)" \
        --cvt catalog_finke.cvt --json-out catalog.json --patches patches/finke.bin
    python3 mkcatalog.py --extra extra.json --name "Default Add-ons" \
        --info "GeoSpace catalog: GEOS files from other sources, english versions" \
        --cvt catalog_extra.cvt --patches patches/extra.bin

`python3 checkcatalog.py catalog_finke.cvt catalog.json` checks a file.

Entries in extra.json may be catalog files ("path" below the url prefix),
any file on the catalog host ("urlpath": absolute request path), or GEOS files
inside an uncompressed .d64 image ("d64path": absolute request path of the
image on the catalog host; "name" is the GEOS file name in the image).
GeoSpace reads such an image as a stream (2-3 times, nothing is stored) and
writes the file directly to the target drive.

## GeoCalc 128 (Finke Collection)

`GeoCalc_128_GEOS65.cvt` is made from the original with

    ca65 --cpu 4510 geocalc128_bridge.s -o bridge.o
    ld65 -t none -S 0x041F -o bridge.bin bridge.o
    python3 geocalc128_patch.py "GeoCalc 128.cvt" GeoCalc_128_GEOS65.cvt bridge.bin

- new ROM bridge $041F-$05B1: C64 BASIC/KERNAL of the MEGA65 ROM image
  ($2A000/$2E000) mapped to $A000/$E000 with MAP instead of the C128 MMU
- function table ($3B15/$3B35) and fixed calls: C128 $AFxx -> C64 ROM
- info text: " @71B9"

## GEOPUBLISH, GeoChart

Info text only: " @184D" (GEOPUBLISH, both catalogs), " @19A0" (GeoChart).

## GEOFILE 128 (Default Add-ons: english)

The copy in the Finke collection is a partly german version (menus
english, 92 messages and dialog texts german). The Default Add-ons entry
downloads the same file and patches it to english; the Finke Collection entry
stays unchanged. GEOFILE_128_en.cvt: the Finke copy with only the german
texts replaced in place by `geofile128_translate.py` (wording from the
english geoFile 64 V1.4, lyonlabs geofile.d64). Record 1 (encrypted,
installed serial number) is not touched: a different serial makes
geoFile ask for a system registration.

## GEOCALC 128 (Default Add-ons, vtda.org GEOCALC128.D64)

An older build than the Finke copy: same ROM bridge, some helper routines
moved and no L08E0 call; the bridge area is $041F-$05AB.
`geocalc128v_bridge.s` (the Finke bridge with this build's addresses) and
`geocalc128v_patch.py` make GEOCALC128_vtda_GEOS65.cvt; the original as
CVT comes from `d64tocvt.py GEOCALC128.D64 "GEOCALC 128" ...`.
Function table $3AD3/$3AF3, fixed LOG calls $3B42/$3B56/$3FA4,
GIVAYF/FOUT $05BB/$05BE. No serial number added.

## calculator (Default Add-ons, cbmfiles CALC128.CVT)

Calculator 128 V2.0 (David Durran), a desk accessory at $1000-$2000.
`calc_patch.py` with `calc_bridge.s` (assembled to $1E80, the former
$0380 save area): enter ($16BB) maps the C64 BASIC/KERNAL ROMs in (MAP,
sei) and copies CHRGET to $73, exit ($16EE) restores the GEOS65 mapping;
VAL becomes STRVAL $B7B5 with the pointer moved from $24 to $22; the C128
math jump table calls become C64 ROM calls (FOUT, MOVMF, MOVFM, CONUPK,
FMULTT, FDIVT, FADDT, FSUBT).

## GEOCHART (Default Add-ons, lyonlabs geocalc.d64)

geoChart for the C64, as on the image (no patch).
