### scheme files ###
pkgguilesitedir = $(guilesitedir)/ice-9
dist_pkgguilesite_DATA = readline-extras.scm

### compiled scheme files ###

pkgguileobjectdir = $(guileobjectdir)/ice-9
pkgguileobject_DATA = $(dist_pkgguilesite_DATA:%.scm=%.go)

GUILEC_FLAGS = -Warity-mismatch -Wformat -Wunused-variable
guilec_opts = --load-path=$(abs_top_srcdir)/src

.scm.go:
	GUILE_AUTO_COMPILE=0 \
	LTDL_LIBRARY_PATH=$(abs_builddir)/.libs \
	$(GUILD) compile --target="$(host)" $(GUILEC_FLAGS) $(guilec_opts)\
	 -L "$(abs_builddir)/.." -L "$(abs_srcdir)/.." -o "$@" "$<"

ETAGS_ARGS = readline-extras.scm

CLEANFILES = $(pkgguileobject_DATA)
