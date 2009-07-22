all: test.byte test.native

test.byte: test.cmo
	ocamlfind ocamlc -package extlib,sexplib,camlhighlight -linkpkg -o $@ $<

test.native: test.cmx
	ocamlfind ocamlopt -package extlib,sexplib,camlhighlight -linkpkg -o $@ $<

test.cmo: test.ml
	ocamlfind ocamlc -package extlib,sexplib,camlhighlight -c $<

test.cmx: test.ml
	ocamlfind ocamlopt -package extlib,sexplib,camlhighlight -c $<

clean:
	rm -f *.cm[iox] *.o *.byte *.native

