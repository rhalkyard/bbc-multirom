This disc contains tools for managing Sideways ROMs and programming the
MultiROM flash cartridge.

These tools are all suitable to run on either the BBC Master or the Acorn
Electron. They require a PAGE of &1D00, making them suitable for ADFS
Electrons, and file I/O is done only using whole buffers, making them also
suitable for tape systems without motor control.

===============================================================================
LISTROM queries each Sideways ROM slot and outputs a table showing the type of
memory in each slot, and the name and version of the ROM (if present).

Columns are:
    Slot #    Type    Version byte (hex)    Name + Version string

Types are:
    R: ROM    W: Writeable RAM    F: Flash    -: empty    ?: unknown

===============================================================================
SAVEROM saves the contents of a Sideways ROM to tape or disc.

===============================================================================
CARTPRG writes the contents of a file to a Sideways ROM slot on a MultiROM
flash cartridge.

During programming, CARTPRG will print a '*' character for every 512 bytes
programmed, followed by a '#' character for every 512 bytes verified.

