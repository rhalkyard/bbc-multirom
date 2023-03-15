BEEBASM:=beebasm

miniprog.ssd miniprg miniprg.lst &: miniprog.6502 flashio.6502
	$(BEEBASM) -i $< -o miniprg -do miniprog.ssd
	$(BEEBASM) -i $< -o miniprg -v > miniprg.lst

clean:
	rm -f *.ssd *.lst miniprg
