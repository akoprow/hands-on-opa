all: index.html

blogspot: index.html
	./subst

index.html: *.adoc
	asciidoc --conf asciidoc.conf -a theme=slidy -a stylesheet=$(CURDIR)/opalang.css -b xhtml11 -v main.adoc;
	mv main.html index.html

clean:
	rm -f index*.html *.log
