NAME = MultiROM

MODULES = pcb pld tools

CLEAN=dist/ version.txt

TAG_COMMIT := $(shell git rev-list --abbrev-commit --tags --max-count=1)
TAG := $(shell git describe --abbrev=0 --tags ${TAG_COMMIT} 2>/dev/null || true)
COMMIT := $(shell git rev-parse --short HEAD)
DATE := $(shell git log -1 --format=%cd --date=format:"%Y%m%d")
VERSION := $(TAG:v%=%)
ifneq ($(COMMIT), $(TAG_COMMIT))
    VERSION_SHORT := $(VERSION)+$(shell git log --oneline $(TAG_COMMIT)..$(COMMIT) | wc -l)
    VERSION := $(VERSION_SHORT)-$(COMMIT)-$(DATE)
endif
ifeq ($(VERSION),)
    VERSION := $(COMMIT)-$(DATE)
    VERSION_SHORT := $(COMMIT)-$(DATE)
endif
ifneq ($(shell git status --porcelain),)
    VERSION := $(VERSION)-dirty
    VERSION_SHORT := $(VERSION_SHORT)*
endif

include $(patsubst %,%/module.mk,$(MODULES))

clean:
	rm -rf $(CLEAN)

.PHONY: all clean dist dist-zip version.txt

RELEASE_FILE_DEPS = \
	pcb/build/$(NAME)-bom.html \
	pcb/build/$(NAME)-bom.csv \
	pcb/build/$(NAME)-ibom.html \
	pcb/build/$(NAME)-pcb.pdf \
	pcb/build/$(NAME)-schematic.pdf \
	pcb/build/Manufacturers/$(NAME)-Elecrow.zip \
	pcb/build/Manufacturers/$(NAME)-FusionPCB.zip \
	pcb/build/Manufacturers/$(NAME)-JLCPCB.zip \
	pcb/build/Manufacturers/$(NAME)-PCBWay.zip \
	pld/$(NAME)-U2.jed \
	tools/$(NAME)-tools.ssd \
	README.md

RELEASE_PHONY_DEPS = pcb/all

RELEASE_EXTRA_FILES = pcb/build/Gerbers_and_Drill

RELEASE_DEPS = $(RELEASE_FILE_DEPS) $(RELEASE_PHONY_DEPS)

RELEASE_FILES = $(RELEASE_FILE_DEPS) $(RELEASE_EXTRA_FILES)

version.txt:
	$(shell echo $(VERSION) > version.txt)

dist: dist/$(NAME)-$(VERSION)
dist-zip: dist/$(NAME)-$(VERSION).zip

dist/$(NAME)-$(VERSION): $(RELEASE_DEPS)
	rm -rf dist/$(NAME)-$(VERSION)
	mkdir -p dist/$(NAME)-$(VERSION)
	cp -r $(foreach file, $(RELEASE_FILES), $(file)) dist/$(NAME)-$(VERSION)

dist/$(NAME)-$(VERSION).zip: dist/$(NAME)-$(VERSION)
	zip -r $@ $<
