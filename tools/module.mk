BEEBASM?=beebasm

all: tools/MultiROM-tools.ssd
.PHONY: tools/version.txt

CLEAN += tools/*.ssd tools/*.lst tools/README_disc.txt tools/cartprg tools/saverom tools/listrom

tools/MultiROM-tools.ssd: tools/toolsdisc.6502 tools/README_disc.txt tools/cartprg tools/saverom tools/listrom
	$(BEEBASM) -i $< -do $@ -opt 3

tools/cartprg: tools/cartprg.6502 tools/flashio.6502 tools/common.6502
	$(BEEBASM) -i $< -o $@ -v > $@.lst

tools/saverom: tools/saverom.6502 tools/flashio.6502 tools/common.6502
	$(BEEBASM) -i $< -o $@ -v > $@.lst

tools/listrom: tools/listroms.6502 tools/flashio.6502 tools/common.6502
	$(BEEBASM) -i $< -o $@ -v > $@.lst

tools/README_disc.txt: tools/README.txt version.txt
	cat $+ > $@
