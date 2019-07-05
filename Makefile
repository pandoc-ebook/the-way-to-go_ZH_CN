COVER ?= R
DEVICE ?= pc
DIVISION = --top-level-division=part
DEBUG ?= -d
HIGHLIGHT = --highlight-style=tango
all: ctexbook elegantbook clean

prepare:
	rm -fr src
	rm -fr directory.md
	bash ./prepare.sh
ctexbook: prepare
	panbook book -V cover:$(COVER) -V device:$(DEVICE) $(DIVISION) $(DEBUG) $(HIGHLIGHT)
elegantbook: prepare
	panbook book --style=elegantbook -V device:$(DEVICE) $(DIVISION) $(DEBUG) $(HIGHLIGHT)

clean:
	panbook clean
	rm -fr src
	rm -fr directory.md