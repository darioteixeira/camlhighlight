#
# Makefile for Camlhighlight.
#

#
# Configure directory locations and options for C compiler.
#

export CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC
export OCAML_LIB=$(shell ocamlc -where)

#
# Internal configuration options.
#

PROJECT=camlhighlight

CORE=camlhighlight_core
PARSER=camlhighlight_parser
WRITE_XHTML=camlhighlight_write_xhtml
CAMLPARTS=$(CORE) $(PARSER) $(WRITE_XHTML)
CAMLSRCS=$(CORE).ml $(PARSER).mli $(PARSER).ml $(WRITE_XHTML).mli $(WRITE_XHTML).ml

FOREIGN=source-highlight
FOREIGN_STUBS=source-highlight_stubs
FOREIGN_INC=/usr/include
FOREIGN_LIB=$(FOREIGN)

TARGETS_FOREIGN=lib$(FOREIGN_STUBS).a dll$(FOREIGN_STUBS).so
TARGETS_CAML=$(foreach PART, $(CAMLPARTS), $(PART).cmi $(PART).cmo $(PART).cmx $(PART).o)
TARGETS_PROJECT=$(foreach EXT, cma cmxa a, $(PROJECT).$(EXT))
TARGETS=$(TARGETS_FOREIGN) $(TARGETS_CAML) $(TARGETS_PROJECT)

OBJS_FOREIGN=$(FOREIGN_STUBS).o
OBJS_CAML=$(foreach PART, $(CAMLPARTS), $(PART).cmo $(PART).cmx)


#
# Rules.
#

all: lib

lib: $(TARGETS)

apidoc: lib $(CAMLSRCS)
	mkdir -p ../doc/apidoc
	ocamlfind ocamldoc -package extlib,pcre,ocsigen.xhtml,ulex,sexplib.syntax -syntax camlp4o -html -d ../doc/apidoc $(CAMLSRCS)

install: lib
	ocamlfind install $(PROJECT) META $(TARGETS)

uninstall:
	ocamlfind remove $(PROJECT)

reinstall: lib
	ocamlfind remove $(PROJECT)
	ocamlfind install $(PROJECT) META $(TARGETS)

clean:
	rm -f *.cm* *.a *.o *.so


#
# Build library using ocamlmklib.
#

$(TARGETS_FOREIGN) $(TARGETS_PROJECT): $(OBJS_FOREIGN) $(OBJS_CAML)
	ocamlmklib -verbose -L$(FOREIGN_LIB) -lstdc++ -l$(FOREIGN) -o $(PROJECT) -oc $(FOREIGN_STUBS) $+


#
# Rules for the low-level interface.
#

$(FOREIGN_STUBS).o: $(FOREIGN_STUBS).cpp
	g++ $(CCOPT) -I $(OCAML_LIB) -I $(FOREIGN_INC) -o $@ -c $<


#
# Rules for the Ocaml modules.
#

$(CORE).cmi $(CORE).cmo $(CORE).cmx: $(CORE).ml
	ocamlfind ocamlc -package sexplib.syntax -syntax camlp4o -o $@ -c $<
	ocamlfind ocamlopt -package sexplib.syntax -syntax camlp4o -o $@ -c $<

$(PARSER).cmi: $(PARSER).mli $(CORE).cmi
	ocamlfind ocamlc -o $@ -c $<

$(PARSER).cmo $(PARSER).cmx: $(PARSER).ml $(PARSER).cmi $(CORE).cmi
	ocamlfind ocamlc -package extlib,sexplib -o $@ -c $<
	ocamlfind ocamlopt -package extlib,sexplib -o $@ -c $<

$(WRITE_XHTML).cmi: $(WRITE_XHTML).mli $(CORE).cmi
	ocamlfind ocamlc -package ocsigen.xhtml -o $@ -c $<

$(WRITE_XHTML).cmo $(WRITE_XHTML).cmx: $(WRITE_XHTML).ml $(WRITE_XHTML).cmi $(CORE).cmi
	ocamlfind ocamlc -package extlib,sexplib,ocsigen.xhtml -o $@ -c $<
	ocamlfind ocamlopt -package extlib,sexplib,ocsigen.xhtml -o $@ -c $<

