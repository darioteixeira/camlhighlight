#
# Makefile for Camlhighlight.
#

#
# Configure directory locations and options for C compiler.
#

export HIGHLIGHT_INC=$(HOME)/software/highlight-2.12/src/core
export HIGHLIGHT_LIB=$(HOME)/.local/lib
export HIGHLIGHT_DEF=$(HOME)/.local/share/highlight

export CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC
export OCAML_LIB=$(shell ocamlc -where)

#
# Internal configuration options.
#

PROJECT=camlhighlight

CORE=camlhighlight_core
LOWLEVEL=camlhighlight_lowlevel
PARSER=camlhighlight_parser
WRITE_XHTML=camlhighlight_write_xhtml
CAMLPARTS=$(CORE) $(LOWLEVEL) $(PARSER) $(WRITE_XHTML)
CAMLSRCS=$(CORE).mli $(CORE).ml $(LOWLEVEL).ml $(PARSER).mli $(PARSER).ml $(WRITE_XHTML).mli $(WRITE_XHTML).ml

FOREIGN=highlight
FOREIGN_STUBS=highlight_stubs
FOREIGN_INC=$(HIGHLIGHT_INC)
FOREIGN_LIB=$(HIGHLIGHT_LIB)
FOREIGN_DEF=$(HIGHLIGHT_DEF)

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
	rm -f *.cm* *.a *.o *.so $(PARSER).ml


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

$(CORE).cmi: $(CORE).mli
	ocamlfind ocamlc -package sexplib.syntax -syntax camlp4o -o $@ -c $<

$(CORE).cmo $(CORE).cmx: $(CORE).ml $(CORE).cmi
	ocamlfind ocamlc -package sexplib.syntax -syntax camlp4o -o $@ -c $<
	ocamlfind ocamlopt -package sexplib.syntax -syntax camlp4o -o $@ -c $<

$(LOWLEVEL).cmi $(LOWLEVEL).cmo $(LOWLEVEL).cmx: $(LOWLEVEL).ml
	ocamlfind ocamlc -o $@ -c $<
	ocamlfind ocamlopt -o $@ -c $<

$(PARSER).cmi: $(PARSER).mli $(CORE).cmi
	ocamlfind ocamlc -o $@ -c $<

$(PARSER).cmo $(PARSER).cmx: $(PARSER).ml $(PARSER).cmi $(CORE).cmi $(LOWLEVEL).cmi
	ocamlfind ocamlc -package extlib,pcre,ulex -syntax camlp4o -o $@ -c $<
	ocamlfind ocamlopt -package extlib,pcre,ulex -syntax camlp4o -o $@ -c $<

$(PARSER).ml: $(PARSER).ml.in
	sed "s%__CONFIG_BASEDIR__%$(FOREIGN_DEF)%" $< > $@

$(WRITE_XHTML).cmi: $(WRITE_XHTML).mli $(CORE).cmi
	ocamlfind ocamlc -package extlib,ocsigen.xhtml -o $@ -c $<

$(WRITE_XHTML).cmo $(WRITE_XHTML).cmx: $(WRITE_XHTML).ml $(WRITE_XHTML).cmi $(CORE).cmi
	ocamlfind ocamlc -package extlib,ocsigen.xhtml -o $@ -c $<
	ocamlfind ocamlopt -package extlib,ocsigen.xhtml -o $@ -c $<


#
# Special rules.
#

.PHONY: $(PARSER).ml.in

