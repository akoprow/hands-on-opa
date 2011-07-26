OPA = opa

MAIN = tutorials
EXE = $(MAIN).exe

all: $(EXE)

$(MAIN).exe: $(MAIN).opa
	$(OPA) $< -o $@

run: $(EXE)
	./$(EXE)

clean:
	rm -rf $(EXE) _build _tracks
