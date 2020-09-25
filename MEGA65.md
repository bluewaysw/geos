The memory mapping of the GEOS implementation for MEGA65 is as following:

bank 0:
bank 1: 
  - $0000-$2000 DOS vars
  - $2000-$FFFF Background video bitmap
bank 2: C65 ROM bank 0
bank 3: C65 ROM bank 1
bank 4: 
  - $0000-$DFFF Foreground video bitmap
  - $E000-$FFFF color RAM
bank 5: GEOS bank 0
  - $0000-$1FFF maps to $6000-$7FFF in bank 0