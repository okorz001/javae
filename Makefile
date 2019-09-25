.POSIX:
.SUFFIXES:

# where you are installing
PREFIX=/usr/local
# can be used to a stage an install for packaging
DESTDIR=

all: html
clean:
	rm -rf javae.html javae.tar.gz .dist

html: javae.html
# allow missing groff
%.html: %.1
	if which groff >/dev/null; then \
	  groff -Thtml -man $< >$@; \
	fi

check:
	bats javae.bats

# allow installing without html
install: all
	install -d $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 0755 javae $(DESTDIR)$(PREFIX)/bin
	install -m 0644 javae.1 $(DESTDIR)$(PREFIX)/share/man/man1
	if [ -e javae.html ]; then \
	  install -d $(DESTDIR)$(PREFIX)/share/doc/javae; \
	  install -m 0644 javae.html $(DESTDIR)$(PREFIX)/share/doc/javae; \
	fi

dist: javae.tar.gz
javae.tar.gz: javae javae.1 javae.html
	$(MAKE) PREFIX=.dist/javae install
	tar -czf $@ -C .dist javae
