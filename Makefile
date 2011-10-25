OPA = opa

MAIN = hands-on-opa
EXE = $(MAIN).exe
EXAMPLES = $(shell ls examples)
ZIPPED_EXAMPLES = $(foreach ex,$(EXAMPLES),examples/$(ex)/pack.zip)

all: clean pack $(EXE)

pack: $(ZIPPED_EXAMPLES)

$(MAIN).exe: $(MAIN).opack $(shell cat $(MAIN).opack)
	$(OPA) $< -o $@

.PHONY: stop
stop:
	pgrep -fx "./$(EXE) --port 5099" | xargs -r kill

bash.opp: bash.ml
	opa-plugin-builder $^ -o $@

examples/%/pack.zip: examples/%
	cd examples && zip -r ../$@ $*

.PHONY: compile
compile: $(EXE)
	./$(EXE) --recompile

.PHONY: run
run: $(EXE)
	./$(EXE) --port 5099

.PHONY: clean
clean:
	make -C blog clean
	rm -rf nohup.out `find . -name '_tracks' \
 -o -name access.log \
 -o -name error.log \
 -o -name '*.opp' \
 -o -name '*.opx*' \
 -o -name '_build'\
 -o -name '*~' \
 -o -name 'pack.zip'`

.PHONY: full-clean
full-clean: clean
	rm -rf `find . -name '*.exe'`

.PHONY: blog
blog:
	make -C blog blogspot

.PHONY: reduce-binaries
reduce-binaries:
	./reduce-binaries.sh

.PHONY: deploy
deploy: full-clean pack stop compile reduce-binaries clean
