COVER ?= R
DEVICE ?= pc
DIVISION = --top-level-division=part
DEBUG ?= -d
HIGHLIGHT = --highlight-style=tango
MEM ?= --memory=2000m
all: ctexbook elegantbook clean

prepare:
	rm -fr src
	rm -fr directory.md
	bash ./prepare.sh
ctexbook: prepare
	panbook book -V cover:$(COVER) -V device:$(DEVICE) $(DIVISION) $(DEBUG) $(HIGHLIGHT) $(MEM)
elegantbook: prepare
	panbook book --style=elegantbook -V device:$(DEVICE) -V cover:images/cover.jpg -V logo:images/logo.png $(DIVISION) $(DEBUG) $(HIGHLIGHT) $(MEM)

clean:
	panbook clean
	rm -fr src
	rm -fr directory.md