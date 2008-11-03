LIB_NAME=highlight
PKG_NAME=camlhighlight
SRC_DIR=src
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

clean:
	cd $(SRC_DIR) && ocamlbuild $(OCAMLBUILS_OPTS) -clean

