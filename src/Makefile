#
# Makefile for Camlhighlight.
#

#
# Configuration options
#

PROJECT=camlhighlight

CORE=camlhighlight_core
PARSER=camlhighlight_parser
WRITER=camlhighlight_writer
LOWLEVEL=camlhighlight_lowlevel
CAMLPARTS=$(CORE) $(PARSER) $(WRITER) $(LOWLEVEL)

FOREIGN=highlight
FOREIGN_STUBS=highlight_stubs
FOREIGN_INCLUDE=$(HOME)/software/highlight-2.10/src/core
FOREIGN_LIB=$(HOME)/.local/lib

TARGETS_FOREIGN=lib$(FOREIGN_STUBS).a dll$(FOREIGN_STUBS).so
TARGETS_CAML=$(foreach PART, $(CAMLPARTS), $(PART).cmi $(PART).cmo $(PART).cmx)
TARGETS_PROJECT=$(foreach EXT, cma cmxa a, $(PROJECT).$(EXT))
TARGETS=$(TARGETS_FOREIGN) $(TARGETS_CAML) $(TARGETS_PROJECT)

OBJS_FOREIGN=$(FOREIGN_STUBS).o
OBJS_CAML=$(foreach PART, $(CAMLPARTS), $(PART).cmo $(PART).cmx)

CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC
OCAML_LIBS=$(shell ocamlc -where)


#
# Rules.
#

all: lib

lib: $(TARGETS)

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
	g++ $(CCOPT) -I $(OCAML_LIBS) -I $(FOREIGN_INCLUDE) -o $@ -c $<


#
# Rules for the Ocaml modules.
#

$(CORE).cmi $(CORE).cmo $(CORE).cmx: $(CORE).ml
	ocamlfind ocamlc -package sexplib.syntax,bin_prot.syntax -syntax camlp4o -o $@ -c $<
	ocamlfind ocamlopt -package sexplib.syntax,bin_prot.syntax -syntax camlp4o -o $@ -c $<

$(PARSER).cmi: $(PARSER).mli $(CORE).cmi
	ocamlfind ocamlc -o $@ -c $<

$(PARSER).cmo $(PARSER).cmx: $(PARSER).ml $(PARSER).cmi $(CORE).cmi $(LOWLEVEL).cmi
	ocamlfind ocamlc -package extlib,pxp-engine,pxp-ulex-utf8 -o $@ -c $<
	ocamlfind ocamlopt -package extlib,pxp-engine,pxp-ulex-utf8 -o $@ -c $<

$(WRITER).cmi: $(WRITER).mli $(CORE).cmi
	ocamlfind ocamlc -package extlib,ocsigen.xhtml -o $@ -c $<

$(WRITER).cmo $(WRITER).cmx: $(WRITER).ml $(WRITER).cmi $(CORE).cmi
	ocamlfind ocamlc -package extlib,ocsigen.xhtml -o $@ -c $<
	ocamlfind ocamlopt -package extlib,ocsigen.xhtml -o $@ -c $<

$(LOWLEVEL).cmi $(LOWLEVEL).cmo $(LOWLEVEL).cmx: $(LOWLEVEL).ml
	ocamlfind ocamlc -o $@ -c $<
	ocamlfind ocamlopt -o $@ -c $<

