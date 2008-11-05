#
# Configuration options.
#

LIB_NAME=highlight
PKG_NAME=camlhighlight

SRC_DIR=src
DOC_DIR=doc/apidoc
BUILD_DIR=$(SRC_DIR)/_build

TARGETS=$(foreach EXT, cmi cma cmxa a, $(LIB_NAME).$(EXT))
FQTARGETS=$(foreach TARGET, $(TARGETS), $(BUILD_DIR)/$(TARGET))

OCAMLBUILS_OPTS=

#
# Rules
#

all: lib

lib:
	cd $(SRC_DIR) && ocamlbuild $(OCAMLBUILS_OPTS) $(TARGETS)

apidoc: lib
	mkdir -p $(DOC_DIR)
	cd $(SRC_DIR) && ocamlfind ocamldoc -package extlib,ocsigen.xhtml,pxp -v -html -d ../$(DOC_DIR) -I _build/ $(LIB_NAME).mli $(LIB_NAME).ml

install: lib
	ocamlfind install $(PKG_NAME) META $(FQTARGETS)

uninstall:
	ocamlfind remove $(PKG_NAME)

reinstall: lib
	ocamlfind remove $(PKG_NAME)
	ocamlfind install $(PKG_NAME) META $(FQTARGETS)

clean:
	cd $(SRC_DIR) && ocamlbuild $(OCAMLBUILS_OPTS) -clean

