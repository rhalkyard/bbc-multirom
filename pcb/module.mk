all: pcb/build/all

CLEAN += pcb/build/ pcb/Makefile.kibot kibot_error.log

PCB_FILES = pcb/$(NAME).kicad_pcb pcb/$(NAME).kicad_prl pcb/$(NAME).kicad_pro pcb/$(NAME).kicad_sch

# Kibot/Kicad seems to get unhappy when invoked in parallel, which is a shame
# since it takes a really long time to build some of its outputs.
.NOTPARALLEL:

# Workaround for https://gitlab.com/kicad/code/kicad/-/issues/14360 - PCB text
# does not get updated with project variables
pcb/$(NAME).kicad_pcb: version.txt
	sed -i -e 's/(property "VERSION" ".*")/(property "VERSION" "$(VERSION)")/' pcb/$(NAME).kicad_pcb

# Kibot generates its own makefile with all its build targets; generate it and
# recurse into it for any target in the kibot output directory
pcb/Makefile.kibot: pcb/default.kibot.yaml $(PCB_FILES)
	kibot -d pcb/build -c $< -m $@ -b pcb/$(NAME).kicad_pcb
	sed -i -e 's/-s all//' pcb/Makefile.kibot

export VERSION
pcb/build/%: pcb/Makefile.kibot pcb/$(NAME).kicad_pcb pcb/$(NAME).kicad_prl pcb/$(NAME).kicad_pro pcb/$(NAME).kicad_sch
	$(MAKE) --file=$< $@
