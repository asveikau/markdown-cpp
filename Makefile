
# Your output filenames go here.
# We'll generate .html from .md-cpp.
FILES= \
 index.html \

TOOLS= \
 Makefile \
 README.md \
 include \
 markdown.pl \
 markdown-filter.pl \

all: $(FILES)
	chmod -R go-rwx $(TOOLS)

tar: src.tar.gz site.tar.gz

src.tar.gz:
	tar zcvf $@ `find . -name '*.md-cpp'` $(TOOLS)
	chmod go-rwx $@

site.tar.gz: $(FILES)
	tar zcvf $@ $(FILES)
	chmod go-rwx $@

clean:
	rm -f $(FILES) src.tar.gz site.tar.gz

.SUFFIXES: .html .md-cpp
.md-cpp.html:
	cat $< |                          \
	sed 's/^ *#  */MARKDOWN_POUND/' | \
        (include=`pwd`/include &&         \
	 cd `dirname $<` &&               \
	 cpp -C -undef -I$$include) |     \
	grep -v '^# *[0-9]* \"' |         \
	sed 's/^MARKDOWN_POUND/# /' |     \
	perl markdown-filter.pl           \
	> "$@"
	chmod go-rwx "$<"

