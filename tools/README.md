# Tools for managing MultiROM cartridge

This directory contains BeebASM code and tools for programming and erasing the MultiROM cartridge.

## Files

[`flashio.6502`](flashio.6502) - a set of routines for programming, erasing, and querying the chip ID.

[`miniprog.6502`](miniprog.6502) - a bare-bones programmer utility using the routines from `flashio.6502`.

[`listroms.bbc`](listroms.bbc) - a BASIC program to list all Sideways ROMs, identifying their contents and whether they are ROM, Sideways RAM, or Flash (similar to the `*ROMS` command on the B+ and Master).

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

Miniprog requires free memory between `&1D00`-`&5FFF`. If Miniprog is started in a screen mode that does not allow for enough room, it will exit with a `No room` error message.

Second Processors are not supported and must be disabled before running Miniprog. If Miniprog is started on a Second Processor, it will exit with a `Tube not supported` error message.

Before programming, Miniprog attempts to make sure that the chosen ROM slot contains a supported memory device. If not, it exits with one of the following error messages:

- `Can't: SWRAM` - the chosen ROM slot appears to be Sideways RAM.

- `Can't: ROM` - the chosesn ROM slot is either a regular ROM, write-protected Sideways RAM, or is empty.

- `Unknown chip` - a chip ID was read, but it does not match the expected ID. Only the SST39SF010 (manufacturer ID `&BF`, part ID `&B5`) is supported by this tool.

After programming, Miniprog verifies the programmed ROM against the buffer. If the data does not match, it will exit with the message `Verify failed`

## Listroms

`listroms` is a BBC Basic program that produces a list of installed ROMs, similar to the `*ROMS` command on the B+ and Master. However, it additionally attempts to determine whether each ROM slot is ROM, sideways RAM, or a supported Flash memory.

Here you can see the output on my Master, with a ROM loaded into Sideways RAM, and a MultiROM in the rear cartridge slot:

```
> CHAIN "listrom"
ROM   F TERMINAL
ROM   E VIEW
ROM   D Acorn ADFS 150
ROM   C BASIC
ROM   B Edit 1.00
ROM   A ViewSheet
ROM   9 DFS 2.24
?     8
SWRAM 7
SWRAM 6
SWRAM 5
SWRAM 4 65C02 ASSEMBLER 1.60
?     3
?     2
Flash 1
Flash 0 The BASIC Editor 1.45
```

As with Miniprog, Listroms should work on an Electron, but does not support running on a Second Processor.
