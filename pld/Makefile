GALASM:=galasm

default: MultiROM-U2.jed
.PHONY: default clean

clean:
	rm -f *.jed *.chp *.fus *.pin

%.jed %.chp %.fus %.pin: %.pld
	$(GALASM) $<
