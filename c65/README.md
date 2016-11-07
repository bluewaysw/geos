# Commodore-65 / Mega65

Now, for C65 build, you need CA65 (from the CC65 package) which knowns about
65CE02/4510 opcodes, maybe the GIT version from github.org. Thus file
`c65/c65.inc` is gone which had some intent to provide several 65CE02 opcodes
for the old CA65 versions.

## Loader

`c65/loader.s` and `c65/loader.cfg` are the source and LD65 linker configuration
file for the C65 loader, which is a standard "BASIC stub" loader must be started
from C65 mode (**not from C64 mode **). It does:

* standard BASIC "SYS stub" stuff, also used BANK 0
* turn fancy C65 memory mappings (`MAP`, VIC-III port $30, std CPU port ...) off
* uses exomizer's decruncher routine to derunch compressed GEOS kernal image.
  Exomizer is used, as - at least for me - pucrunch didn't worked because of the
  overlap between the compressed kernal and the uncompressing target area (on
  C65, the BASIC are starts at a higher address than on C64), I have no idea if
  pucrunch supports backward uncrunching at all to avoid this problem. Also
  exomizer seems to give a better result of compression, so the situation is
  good enough for me. File `uncrunch.s` is simply the source of the Exomizer's
  uncrunch routine, with the settings we need.

## Kernal

`c65/start.s` is an extension of the "purgeable init code" from address $5000.
Call to `InitC65` is done from `kernal/start.s`. Because I liked the idea to be
able to be complied with `trap=1` as well in `config.inc`, I used another memory
segment (modified `kernal/kernal.cfg`) and the C65 specific stuff purges itself
after its turn, giving control back to `_ResetHandle` which should found the
original state.

Currently this code does almost nothing, later it can do more (ie, M65 detection
and change disk driver to M65 specific one, so C65 is also supported this way
still).

## Makefile and building

Makefile was modified by me for *my* taste :-) Also the "glue" of binary fragments
done with the assembler itself, so the config.inc can be used to customize this
process, instead of hacking the Makefile ... Modifications: `Makefile` and
new file `constructor.s` in the top directory.

## Disk driver code

Well, that's simply borrowed from here: https://github.com/frehwagen/geos

Source is `c65/drvf011.s`, LD65 linker configuration file is `c65/drvf011.s`.
