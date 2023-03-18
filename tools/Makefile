include ../vars.mk

all: MultiROM-tools.ssd
.PHONY: version.txt

MultiROM-tools.ssd: toolsdisc.6502 README_disc.txt cartprg saverom listrom
	$(BEEBASM) -i $< -do $@ -opt 3

cartprg cartprg.lst: cartprg.6502 flashio.6502 common.6502
	$(BEEBASM) -i $< -o cartprg -v > cartprg.lst

saverom saverom.lst: saverom.6502 flashio.6502 common.6502
	$(BEEBASM) -i $< -o saverom -v > saverom.lst

listrom listrom.lst: listroms.6502 flashio.6502 common.6502
	$(BEEBASM) -i $< -o listrom -v > listrom.lst

README_disc.txt: README.txt version.txt
	cat $+ > $@

version.txt:
	echo "$(NAME) $(VERSION)" > version.txt

clean:
	rm -f *.ssd *.lst version.txt README_disc.txt cartprg saverom listrom
