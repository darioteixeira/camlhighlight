STATIC_PKGS=ocsigen.parsecommandline,ocsigen.server,ocsigen.ext.ocsipersist-sqlite,ocsigen.ext.eliom,ocsigen.ext.staticmod,extlib,camlhighlight

all: myserver myserver.opt

myserver: test.cmo
	ocamlfind ocamlc -package $(STATIC_PKGS) $+ -o $@ -linkpkg -thread

myserver.opt: test.cmx
	ocamlfind ocamlopt -package $(STATIC_PKGS) $+ -o $@ -linkpkg -thread

%.cmo: %.ml
	ocamlfind ocamlc -thread -package extlib,lwt,ocsigen,camlhighlight -c $<

%.cmx: %.ml
	ocamlfind ocamlopt -thread -package extlib,lwt,ocsigen,camlhighlight -c $<

clean:
	rm -f *.cm[ioax] *.cmx[as] *.[oa] myserver myserver.opt

