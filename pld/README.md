# PLD files for MultiROM

This directory contains GALasm source for the 16V8 PLD used to provide selection and addressing logic.

## Building

Install [GALasm](https://github.com/daveho/GALasm) or [galette](https://github.com/simon-frankau/galette), then run `make` in this directory.

GALasm produces several output files of varying usefulness:

- `.chp` - ASCII-art of chip, with pin names

- `.fus` - tabular description of fuse states

- `.jed` - JEDEC fuse-map file, for programming onto device

- `.pin` - ASCII table of pin names

## Programming

Note that the GAL16V8 device specified in the source is out of production. The [Atmel ATF16V8B](https://www.microchip.com/en-us/product/ATF16V8B) is a compatible in-production equivalent.

The ubiquitous [XGecu](http://www.autoelectric.cn/en/TL866_main.html) (a.k.a. TL866) USB programmers are probably the cheapest and easiest way to program small PLDs (and numerous other chips).
