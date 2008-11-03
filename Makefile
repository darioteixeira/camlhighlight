LIB_NAME=highlight
PKG_NAME=camlhighlight
SRC_DIR=src
DOC_DIR=apidoc
BUILD_DIR=$(SRC_DIR)/_build
TARGETS=$(foreach EXT, cmi cma cmxa a, $(LIB_NAME).$(EXT))
FQ_TARGETS=$(foreach TARGET, $(TARGETS), $(BUILD_DIR)/$(TARGET))
OCAMLBUILS_OPTS=

all: lib

lib:
	cd $(SRC_DIR) && ocamlbuild $(OCAMLBUILS_OPTS) $(TARGETS)

install: lib
	ocamlfind remove $(PKG_NAME)
	ocamlfind install $(PKG_NAME) META $(FQ_TARGETS)

doc: lib
	mkdir -p $(DOC_DIR)
	cd $(SRC_DIR) && ocamlfind ocamldoc -package extlib,ocsigen.xhtml,pxp -v -html -d ../$(DOC_DIR) -I _build/ $(LIB_NAME).mli $(LIB_NAME).ml

clean:
	cd $(SRC_DIR) && ocamlbuild $(OCAMLBUILS_OPTS) -clean

allclean: clean
	rm -rf $(DOC_DIR)
