
bin_SCRIPTS = pocket pocket-init
man1_MANS = pocket.1 pocket-init.1

mylibexecdir = $(patsubst %/$(PACKAGE),%,$(libexecdir))
mypkglibexecdir = $(mylibexecdir)/$(PACKAGE)
mypkglibexec_SCRIPTS = pocket-functions.sh

confdir = $(sysconfdir)/pocket
conf_DATA = pocket.conf debian.repo debian.pocket

pocket_DESC = pocket main util
pocket_init_DESC = pocket chroot initialization and configuration util

html_DATA = debian.html

%.inc: %.md
	ronn --roff $< --pipe >$@
	sed -i -e '/^\.TH/ d' \
	       -e 's/^\.SH "\([^"]*\)"/[\1]/' \
	  $@

%.1: %.1.inc
	help2man -N -s 1 -m $* -n "$($(subst -,_,$*)_DESC)" \
	         -i $< -o $@ ./$*

%.pocket.md: %.pocket
	$(MAKE) -s --no-print-directory -f $< doc >$@

%.html: %.pocket.md
	ronn --pipe --html $< >$@

install-exec-hook:
	chmod 0644 $(DESTDIR)$(mypkglibexecdir)/pocket-functions.sh
	$(LN_S) -f $(mypkglibexecdir)/pocket-functions.sh \
	           $(DESTDIR)$(bindir)/pocket-functions.sh

install-data-hook:
	sed -i -e 's,/usr/libexec,$(mylibexecdir),g' $(DESTDIR)$(confdir)/pocket.conf
