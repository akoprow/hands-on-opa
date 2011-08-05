OPA = opa

MAIN = hands-on-opa
EXE = $(MAIN).exe
EXAMPLES = $(shell ls examples)
ZIPPED_EXAMPLES = $(foreach ex,$(EXAMPLES),examples/$(ex)/pack.zip)

pack: $(ZIPPED_EXAMPLES)

$(MAIN).exe: $(MAIN).opa data.opa examples.opa bash.opp
	$(OPA) $^ -o $@

stop:
	pgrep -fx "./$(EXE) --port 5099" | xargs -r kill

bash.opp: bash.ml
	opa-plugin-builder $^ -o $@

examples/%/pack.zip: examples/%
	cd examples && zip -r ../$@ $*

run: $(EXE)
	./$(EXE) --port 5099

clean:
	rm -rf nohup.out `find . -name '_tracks' \
 -o -name access.log \
 -o -name error.log \
 -o -name '*.opp' \
 -o -name '*.opx' \
 -o -name '_build'\
 -o -name '*.exe' \
 -o -name '*~' \
 -o -name 'pack.zip'`

deploy: clean pack stop run
