OPA = opa

MAIN = hands-on-opa
EXE = $(MAIN).exe
EXAMPLES = $(shell ls examples)
ZIPPED_EXAMPLES = $(foreach ex,$(EXAMPLES),examples/$(ex)/pack.zip)

all: clean pack $(EXE)

pack: full-clean $(ZIPPED_EXAMPLES)

$(MAIN).exe: $(MAIN).opa data.opa examples.opa bash.opp
	$(OPA) $^ -o $@

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
 -o -name '*~'`

.PHONY: full-clean
full-clean: clean
	rm -rf `find . -name '*.exe' \
 -o -name 'pack.zip'`

.PHONY: blog
blog:
	make -C blog blogspot

.PHONY: reduce-binaries
reduce-binaries: clean
	upx `find -name '*.exe'`

.PHONY: send-to-monster
send-to-monster:
	rsync -r --progress --bwlimit=256 . ns221022.ovh.net:~/hands-on-opa

.PHONY: deploy
deploy: pack stop compile reduce-binaries send-to-monster
