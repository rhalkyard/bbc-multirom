include ../vars.mk

all: build/all
KICAD_EXTS=kicad_pcb kicad_pro kicad_sch

build/all: Makefile.kibot
	make --file=$< all

clean:
	rm -rf build/ Makefile.kibot version.txt

.PHONY: all build/all clean

# Kibot/Kicad seems to get unhappy when invoked in parallel, which is a shame
# since it takes a really long time to build some of its outputs.
.NOTPARALLEL:

version.txt:
	echo $(VERSION) > version.txt

Makefile.kibot: default.kibot.yaml version.txt $(foreach ext, $(KICAD_EXTS), $(NAME).$(ext)) $(NAME).kicad_pro
	kibot -d build -c $< basic_pdf_sch_print
	kibot -d build -c $< -m $@

build/%: Makefile.kibot
	make --file=$< $@
