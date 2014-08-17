NAME=test
PKGS=camlhighlight
LINK_PKGS=camlhighlight

all: $(NAME).byte $(NAME).native

$(NAME).byte: $(NAME).cmo
	ocamlfind ocamlc -thread -package $(LINK_PKGS) $+ -o $@ -linkpkg

$(NAME).native: $(NAME).cmx
	ocamlfind ocamlopt -thread -package $(LINK_PKGS) $+ -o $@ -linkpkg

%.cmo: %.ml
	ocamlfind ocamlc -thread -package $(PKGS) -c $<

%.cmx: %.ml
	ocamlfind ocamlopt -thread -package $(PKGS) -c $<

clean:
	rm -f $(NAME).cm[io] $(NAME).cmx $(NAME).o $(NAME).byte $(NAME).native

