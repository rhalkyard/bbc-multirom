include vars.mk

all: pcb/all pld/all tools/all

clean: pcb/clean pld/clean tools/clean
	rm -rf release/

.PHONY: all clean release

pcb/%:
	$(MAKE) -C pcb $(@:pcb/%=%)

pld/%:
	$(MAKE) -C pld $(@:pld/%=%)

tools/%:
	$(MAKE) -C tools $(@:tools/%=%)

RELEASE_FILES = \
	pcb/build/$(NAME)-bom.html \
	pcb/build/$(NAME)-bom.csv \
	pcb/build/$(NAME)-ibom.html \
	pcb/build/$(NAME)-pcb.pdf \
	pcb/build/$(NAME)-schematic.pdf \
	pld/$(NAME)-U2.jed \
	tools/$(NAME)-tools.ssd

release: $(RELEASE_FILES)
	rm -rf release/
	mkdir release/
	cp $(foreach file, $(RELEASE_FILES), $(file)) release/
