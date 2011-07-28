OPA = opa

MAIN = tutorials
EXE = $(MAIN).exe

all: $(EXE)

$(MAIN).exe: $(MAIN).opa data.opa examples.opa bash.opp
	$(OPA) $^ -o $@

bash.opp: bash.ml
	opa-plugin-builder $^ -o $@

run: $(EXE)
	./$(EXE)

clean:
	rm -rf *.exe _build `find . -name '_tracks' -o -name '*.opp' -o -name '*.opx' -o -name '_build' -o -name '*.exe'`

deploy: clean run
