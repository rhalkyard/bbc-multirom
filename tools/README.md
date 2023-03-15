# Tools for managing MultiROM cartridge

This directory contains BeebASM code and tools for programming and erasing the MultiROM cartridge.

## Files

[`flashio.6502`](flashio.6502) - a set of routines for programming, erasing, and querying the chip ID.

[`miniprog.6502`](miniprog.6502) - a bare-bones programmer utility using the routines from `flashio.6502`.

## Miniprog

Miniprog is an absolute bare-bones utility designed to cover 'extreme' use cases where more fancy tools might not work. It loads the entirety of the ROM image into a RAM buffer in one go, rather than piecewise. This allows ROM images to be loaded from tape without motor control, which helps, for example, when loading from audio files on a digital recorder. Additionally, despite having a 16K buffer, it only uses memory from `&1D00`-`&5FFF`, allowing it to fit on an Electron with ADFS.

By defining the `ROM_IMAGE` assembly variable, Miniprog can be preloaded with a ROM image, turning it into a self-contained 'installer' that programs the image onto a cartridge when run.

Miniprog is designed to run either on a Master or Electron, and patches itself at runtime to use the appropriate address for `ROMSEL`.

### Usage

Miniprog uses memory up to `&5FFF`. On a Master, `MODE`s 6, 7, or any shadow mode are suitable. On the Electron, Miniprog must be loaded and run in `MODE 6`.

Miniprog has a load and start address of `&1D00`.

```
> *RUN MINIPRG
MultiROM flash cartridge mini-programmer

ROM Filename (blank to erase)? BASICED
Slot # (0-3)? 3
Done.
> 
```

In this example, Sideways ROM slot 3 will be erased, and programmed with the file `BASICED`.

If no filename is given, then the chosen ROM slot will be erased.

Escape can be pressed at any prompt to cancel and exit.

### Error Messages

Before programming, Miniprog attempts to make sure that the chosen ROM slot contains a valid flash IC. If not, it exits with one of the following error messages:

`Can't program SWRAM.` - the chosen ROM slot appears to be Sideways RAM.

`Can't program ROM.` - the chosesn ROM slot appears to be either a regular ROM, write-protected Sideways RAM, or is empty.

`Unknown chip.` - a chip ID was read, but it does not match the expected ID. Only the SST39SF010 (manufacturer ID `&BF`, part ID `&B5`) is supported by this tool.

After programming, Miniprog verifies the programmed ROM against the buffer. If the data does not match, it will exit with the message `Verify failed.`
