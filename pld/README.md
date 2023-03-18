# PLD files for MultiROM

This directory contains CUPL and GALasm source for the 16V8 GAL used to provide selection and addressing logic.

## Building

### Building with WinCUPL

CUPL source suitable for WinCUPL can be found in the `cupl/` subdirectory

WinCUPL can be [downloaded](https://www.microchip.com/en-us/products/fpgas-and-plds/spld-cplds/pld-design-resources) free from Atmel, but is available only for Windows, and the GUI is broken on anything newer than Windows XP.

[cupl/build.bat](cupl/build.bat) builds the source using WinCUPL's command-line compiler, which does still work on modern systems.

### Building with GALasm

GALasm source and a `Makefile` to build it can be found in the `GALasm/` directory.

[GALasm](https://github.com/daveho/GALasm) is a free cross-platform tool for compiling GAL logic. It's just as old and crusty as WinCUPL, but it will at least run on OSes other than Windows. However, its license strictly forbids any commercial use.

## Programming

CUPL and GALasm both produce numerous output files, but the one that matters is the JEDEC fuse map with a `.jed` extension.

The cheap and ubiquitous [XGecu](http://www.autoelectric.cn/en/TL866_main.html) (a.k.a. TL866) USB programmers are capable of programming this file onto the chip.
