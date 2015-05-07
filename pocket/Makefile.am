
bin_SCRIPTS = pocket pocket-init
bin_DATA = pocket-functions.sh
man1_MANS = pocket.1 pocket-init.1

confdir = $(sysconfdir)/pocket
conf_DATA = pocket.conf debian.repo debian.pocket

pocket_init_DESC = pocket chroot initialization and configuration tool

%.inc: %.md
	ronn --roff $< --pipe >$@
	sed -i -e '/^\.TH/ d' \
	       -e 's/^\.SH "\([^"]*\)"/[\1]/' \
	  $@

%.1: %.1.inc
	help2man -N -s 1 -m $* -n "$($(subst -,_,$*)_DESC)" \
	         -i $< -o $@ ./$*
