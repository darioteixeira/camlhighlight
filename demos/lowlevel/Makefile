NAME=test
PKGS=extlib,camlhighlight

all: $(NAME).byte $(NAME).native

$(NAME).byte: $(NAME).cmo
	ocamlfind ocamlc -package $(PKGS) -linkpkg -o $@ $<

$(NAME).native: $(NAME).cmx
	ocamlfind ocamlopt -package $(PKGS) -linkpkg -o $@ $<

$(NAME).cmo: $(NAME).ml
	ocamlfind ocamlc -package $(PKGS) -c $<

$(NAME).cmx: $(NAME).ml
	ocamlfind ocamlopt -package $(PKGS) -c $<

clean:
	rm -f $(NAME).cm[iox] $(NAME).o $(NAME).byte $(NAME).native

