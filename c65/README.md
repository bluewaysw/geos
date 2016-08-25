# Commodore-65 / Mega65

`c65/c65.inc` sets 65C02 CPU type for CA65. Ideally, there should be 65CE02 (better
say, 4502/4510) CPU support in CA65, but till that, 65C02 is also nice, at least
we have `STZ` works this way :) Also, it defines macros for some simple opcodes,
like `MAP`, etc.

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

Currently this code does almost nothing, later it can do more.

## Disk driver code

Well, that's simply borrowed from here: https://github.com/frehwagen/geos

Source is `c65/drvf011.s`, LD65 linker configuration file is `c65/drvf011.s`.
