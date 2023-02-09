# MultiROM: Yet Another BBC Master / Electron ROM Cartridge

There are plenty of perfectly-good options for building ROM cartridges for the BBC Master and Acorn Electron Plus One. However, I am a stubborn git and decided to come up with my own take on the idea.

In this day and age, 27x EPROMS and their 28x EEPROM cousins are getting expensive and harder to find. If you've got a junk drawer full of them, that's just grand, but sourcing them is a pain. Phillip Pearson has developed an [alternative cartridge](https://github.com/google/myelin-acorn-electron-hardware/tree/main/32kb_flash_cartridge) that uses the cheaper and more readily available SST39SF010A flash memory, and is programmable in-system using a simple program. However, due to subtle differences in the cartridge-slot wiring between the Electron and Master, it is unlikely that Pearson's cartridge would work correctly on the Master.

Additionally, the SST39SF010A has a whopping 128 kilobytes of storage, while a Beeb cartridge can only address 32 kilobytes (technically, two banks of 16k). Pearson's cartridge leaves the other 96k unused, but since we are using a GAL anyway to handle compatibility issues between the Master and Electron, we might as well use the spare logic to address the remainder of the chip.

## A quick primer on cartridges

'BBC' style 8-bit machines (BBC Model A, B, B+, Master, Master Compact, Acorn Electron) had a 16 kilobyte segment of their address space referred to as the "sideways" address space. Rather than being mapped directly to RAM, ROM or I/O devices, the Sideways address space is bank-switched between 16 'slots', each with its own 16 kilobyte address space.

These slots were originally intended for ROM-based software and operating system extensions, and were mapped directly to ROM sockets on the system motherboard. Later on, additional RAM would also be made available in Sideways slots, first as third-party add-ons, and then as built-in functionality in the B+ and Master.

On the Model A, B and B+, Sideways ROMs were simply bare  EPROMs inserted into sockets inside the machine.

The "Plus 1" hardware expansion for the Electron added two cartridge sockets as a more user-friendly alternative to handling bare EPROMs. Each cartridge socket can address 32k as two banks of 16k mapped into two slots in the Sideways address space - the frontmost cartridge to slots 0 and 1, the rear cartridge to slots 2 and 3.

The Master had a pair of cartridge sockets that were broadly compatible with the Electron, although with subtle implementation differences.

The important pins that we're working with are as follows:

Signal Name     | Function
----------------|----
A0..A12         | Bits 0-12 of the processor address bus 
ROMQA           | ROM low/high select
~ROMOE          | Active-low cartridge select
Phi2            | Phi_2 clock from 6502
MADET           | Master/Electron sense - floating on Electron systems, grounded on Master
RnW/READY       | CPU R/W on Master, CPU stall control input on Electron
CSRW            | Active-high cartridge select on Master, CPU R/W on Electron

The differences in RnW/READY and CSRW between Electron and Master systems mean we need different logic to support writes on the Electron and Master!

## Switching banks

The switches on the front side of the cartridge allow ROM banks to be selected independently for each of the two ROM slots. 'High' and 'Low' denote the Sideways ROM slots occupied by the cartridge. I.e. if the cartridge is inserted into the front socket, the 'Low' ROM will appear in Slot 0, and the 'High' ROM in Slot 1. In the rear socket, they will appear in slots 2 and 3 respectively.

Note that while eight ROMs can be stored in the MultiROM, and two can be selected at one time, each ROM bank is selected from its own set - i.e. a ROM that has been programmed into a particular position, can only be selected for that same position. 

## Memory Map

Address Range   | ROM Slot  |Bank
----------------|-----------|----
00000-03FFF     | Low       | 0
04000-07FFF     | High      | 0
08000-0BFFF     | Low       | 1
0C000-0FFFF     | High      | 1
10000-13FFF     | Low       | 2
14000-17FFF     | High      | 2
18000-1BFFF     | Low       | 3
1C000-1FFFF     | High      | 3

## How to build

### Bill of Materials

Reference   | Part
------------|------
C1, C2      | Capacitor, 0.1μF
RN1         | SIP6 resistor network, bussed, 10KΩ
SW1         | SPST DIP switch module, 4 switches
U1          | SST39SF010 1Mbit flash memory, DIP32 package
U2          | GAL16V8 or ATF16V8 programmable logic device, DIP20 package

### PCB

Any PCB shop such as PCBWay, OSHPark or JLCPCB should be able to fabricate the PCB. For best results and longer contact life, the edge connector should be gold-plated - with JLCPCB this means selecting the "ENIG Finish" and "Gold Fingers" options.

### GAL

WinCUPL source for U2 can be found in the `PLD/` directory, along with a build script.

## Programming

The flash IC can be removed and programmed in an external programmer according to the memory map above. The IC may also be programmed in-situ using the procedure described below. A subsequent update to this repo will include programming software.

### Interfacing

The SST39SF010A is flash memory, and cannot be programmed like a regular EEPROM. Data can only be erased in 4kb sectors, and each write must be preceded by a special '3 byte load' sequence. Writes can only be made to erased memory. After issuing an erase or write command, the chip must be allowed to complete the operation before continuing.

Completion can be determined by repeatedly reading back the written byte and either:

* Monitoring the value of bit 6, repeated reads will cause this value to toggle while the operation is in progress.

* Comparing Bit 7 of some address against the known value, it will be inverted while operation is in progress.

Alternatively, a hard delay loop of the worst-case time:

Operation       | Delay
----------------|-------
Byte program    | 20 μs
Sector Erase    | 25 ms
Chip Erase      | 100 ms

Since the programming process is so convoluted, and regular writes are ignored, a write protection jumper is not provided.


### Flash Commands

Writing, erasing, chip-status and chip-ID functions are accessed by performing a 'magic' sequence of writes, as described in the datasheet, to addresses `5555` and `2AAA`

Because the cartridge slots are mapped into memory starting at address `&8000`, and the low/high ROM select line is used as the 14th address bit, when programming flash on the machine, use the following addresses:

Flash address   | ROM Slot | Effective Address
----------------|----------|------------------
`5555`          | 0 / 2    | `9555`
`2AAA`          | 1 / 3    | `AAAA`

E.g., to write a byte to ROM 0 (i.e. the low ROM in the front cartridge socket), assuming that the sector has been erased:

1. Page in ROM 1
2. Write `&AA` to `&9555`
3. Page in ROM 0
4. Write `&55` to `&AAAA`
5. Page in ROM 1
6. Write `&A0` to `&9555`
7. Page in ROM 0
8. Write a byte to the desired address
9. Repeatedly read back the written data, and wait for bit 6 to stop toggling

This process must be repeated for each byte.

Any spurious reads or writes occurring during this process will cancel the operation - to prevent MOS from interfering with this process while serving interrupts, it is advisable to disable IRQ interrupts with an `SEI` instruction, and (if we're being really cautious) claim the NMI code area (`OSBYTE &8F, &0C, &FF`) and write an `RTI` instruction to `&D00` to make sure that we aren't bothered. Remember to `CLI` and release NMIs when finished!

## References

* [Phillip Pearson's Electron flash cartridge](https://github.com/google/myelin-acorn-electron-hardware/tree/main/32kb_flash_cartridge) - uses SST39SF010A, but can't be written on a Master, and has a complicated address map.

* [Stardot thread for Retro Hardware ARA III](https://stardot.org.uk/forums/viewtopic.php?t=15629) - writeable cartridge that uses a GAL to support both Electron and Master, but uses expensive and obsolete 28C256 EEPROMs

* [Acorn Application Note 014: Acorn Electron Cartridge Interface Specification](http://chrisacorns.computinghistory.org.uk/docs/Acorn/AN/014.pdf) - cartridge interface specs, including differences between Electron and Master. [AN 035](http://chrisacorns.computinghistory.org.uk/docs/Acorn/AN/035.pdf) appears to be more or less the same doc but with less info.