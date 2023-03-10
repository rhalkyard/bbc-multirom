# PLD files for MultiROM

This directory contains the WinCUPL project for the 16V8 GAL used to provide selection and addressing logic.

## Building

WinCUPL is available free from Microchip at https://www.microchip.com/en-us/products/fpgas-and-plds/spld-cplds/pld-design-resources. However, the graphical frontend is broken on modern version of Windows (I run it in an XP VM and even then it's only barely usable).

The included [build.bat](build.bat) script invokes the CUPL compiler from the command line to build and test the logic without having to mess around with the WinCUPL GUI. It assumes that WinCUPL is installed to the default `C:\WINCUPL` directory, if you have installed it somewhere else, you'll need to change `WINCUPL_DIR` on the first line of the script.

WinCUPL is Windows-only, sorry.
