all: test.byte test.native

test.byte: test.cmo
	ocamlfind ocamlc -package extlib,camlhighlight -linkpkg -o $@ $<

test.native: test.cmx
	ocamlfind ocamlopt -package extlib,camlhighlight -linkpkg -o $@ $<

test.cmo: test.ml
	ocamlfind ocamlc -package extlib,camlhighlight -c $<

test.cmx: test.ml
	ocamlfind ocamlopt -package extlib,camlhighlight -c $<

clean:
	rm -f *.cm[iox] *.o *.byte *.native

