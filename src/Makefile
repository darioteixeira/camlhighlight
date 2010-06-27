#
# Makefile for Camlhighlight.
#

#
# Configure directory locations and options for C compiler.
#

FOREIGN_INC=/usr/include
FOREIGN_LIB=source-highlight

CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC
OCAML_LIB=$(shell ocamlc -where)

#
# Checking for OCamlduce
#
ifndef DUCE
  DUCE := $(shell if [ `which ocamlduce` ]; then echo yes; else echo no; fi)
endif

#
# Internal configuration options.
#

PROJECT=camlhighlight

CORE=camlhighlight_core
PARSER=camlhighlight_parser
WRITE_XHTML=camlhighlight_write_xhtml
WRITE_DUCE=camlhighlight_write_xhtml_duce
CAMLPARTS=$(CORE) $(PARSER) $(WRITE_XHTML)
DUCEPARTS=$(WRITE_DUCE)
CAMLSRCS=$(CORE).ml $(PARSER).mli $(PARSER).ml $(WRITE_XHTML).mli $(WRITE_XHTML).ml
DUCESRC=$(WRITE_DUCE).mli

FOREIGN=source-highlight
FOREIGN_STUBS=source-highlight_stubs

TARGETS_FOREIGN=lib$(FOREIGN_STUBS).a dll$(FOREIGN_STUBS).so
TARGETS_CAML=$(foreach PART, $(CAMLPARTS), $(PART).cmi $(PART).cmo $(PART).cmx $(PART).o)
TARGETS_DUCE=$(foreach PART, $(DUCEPARTS), $(PART).cmi $(PART).cmo $(PART).cmx $(PART).o)
TARGETS_PROJECT=$(foreach EXT, cma cmxa a, $(PROJECT).$(EXT))
ifeq "$(DUCE)" "yes"
TARGETS=$(TARGETS_FOREIGN) $(TARGETS_CAML) $(TARGETS_PROJECT) $(TARGETS_DUCE)
else
TARGETS=$(TARGETS_FOREIGN) $(TARGETS_CAML) $(TARGETS_PROJECT)
endif

OBJS_FOREIGN=$(FOREIGN_STUBS).o
OBJS_CAML=$(foreach PART, $(CAMLPARTS), $(PART).cmo $(PART).cmx)


#
# Rules.
#

all: lib

lib: $(TARGETS) META

ifeq "$(DUCE)" "yes"
META: META.in META.duce
	cat META.in META.duce > META
else
META: META.in
	cp META.in META
endif

ifeq "$(DUCE)" "yes"
apidoc: lib $(CAMLSRCS) $(DUCESRC)
	mkdir -p temp
	camlp4o -I `ocamlfind query sexplib` -I `ocamlfind query type-conv.syntax` pa_type_conv.cmo nums.cma bigarray.cma sexplib.cma pa_sexp_conv.cmo camlhighlight_core.ml -o temp/$(CORE).ml
	mkdir -p ../doc/apidoc
	ocamlducefind ocamldoc -package extlib,ocsigen.xhtml,sexplib.syntax -html -d ../doc/apidoc temp/$(CORE).ml $(PARSER).mli $(PARSER).ml $(WRITE_XHTML).mli $(WRITE_XHTML).ml $(DUCESRC)
	rm -r temp
else
apidoc: lib $(CAMLSRCS)
	mkdir -p ../doc/apidoc
	ocamlfind ocamldoc -package extlib,ocsigen.xhtml,sexplib.syntax -syntax camlp4o -html -d ../doc/apidoc $(CAMLSRCS)
endif

install: lib
	ocamlfind install $(PROJECT) META $(TARGETS)

uninstall:
	ocamlfind remove $(PROJECT)

reinstall: lib
	ocamlfind remove $(PROJECT)
	ocamlfind install $(PROJECT) META $(TARGETS)

clean:
	rm -f *.cm* *.a *.o *.so META


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

$(WRITE_DUCE).cmi: $(WRITE_DUCE).mli $(CORE).cmi
	ocamlducefind ocamlc -thread -package ocsigen -o $@ -c $<

$(WRITE_DUCE).cmo $(WRITE_DUCE).cmx: $(WRITE_DUCE).ml $(WRITE_DUCE).cmi $(CORE).cmi
	ocamlducefind ocamlc -thread -package extlib,sexplib,ocsigen -o $@ -c $<
	ocamlducefind ocamlopt -thread -package extlib,sexplib,ocsigen -o $@ -c $<

