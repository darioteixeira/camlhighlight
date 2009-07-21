#
# Makefile for Camlhighlight.
#

#
# Configure directory locations and options for C compiler.
#

export HIGHLIGHT_INC=$(HOME)/software/highlight-2.10/src/core
export HIGHLIGHT_LIB=$(HOME)/.local/lib
export HIGHLIGHT_DEF=$(HOME)/.local/share/highlight

export CCOPT=-O2 -fno-defer-pop -D_FILE_OFFSET_BITS=64 -D_REENTRANT -fPIC
export OCAML_LIB=$(shell ocamlc -where)

#
# Rules.
#

.DEFAULT all:
	make $(MAKECMDGOALS) -C src

