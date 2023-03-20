GALASM?=galasm

all: pld/MultiROM-U2.jed
CLEAN += pld/*.jed pld/*.chp pld/*.fus pld/*.pin

%.jed %.chp %.fus %.pin: %.pld
	$(GALASM) $<
