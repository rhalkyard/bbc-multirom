CLEAN += pcb/build/ pcb/Makefile.kibot kibot_error.log

PCB_FILES = pcb/$(NAME).kicad_pcb pcb/$(NAME).kicad_pro pcb/$(NAME).kicad_sch

.PHONY: pcb/all

all: pcb/all

pcb/all: pcb/Makefile.kibot $(PCB_FILES)
	$(MAKE) --file=$< all

# Kibot/Kicad seems to get unhappy when invoked in parallel, which is a shame
# since it takes a really long time to build some of its outputs.
.NOTPARALLEL:

# Kibot generates its own makefile with all its build targets; generate it and
# recurse into it for any target in the kibot output directory
pcb/Makefile.kibot: pcb/default.kibot.yaml
	kibot -d pcb/build -c $< -m $@ -b pcb/$(NAME).kicad_pcb
# The Kibot makefile disables preflight checks, re-enable them
	sed -i -e 's/-s all//' pcb/Makefile.kibot

pcb/build/%: pcb/Makefile.kibot $(PCB_FILES)
	$(MAKE) --file=$< $@
