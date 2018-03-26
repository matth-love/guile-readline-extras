## Process this file with automake to produce Makefile.in

SUBDIRS=ice-9

snarfcppopts = $(DEFS) $(INCLUDES) $(CPPFLAGS) $(CFLAGS) $(GUILE_CFLAGS)
SUFFIXES: .x
.c.x:
	guile-snarf -o $@ $< $(snarfcppopts)

guileextension_LTLIBRARIES= libguile-readline-extras.la

libguile_readline_extras_la_SOURCES = readline_extras.c

libguile_readline_extras_la_CPPFLAGS = $(GUILE_CFLAGS)

if WARN
libguile_readline_extras_la_CPPFLAGS += -Wall -Wextra -Wstrict-prototypes	\
-Wmissing-prototypes -Wpointer-arith -Wreturn-type -Wcast-qual		\
-Wswitch -Wshadow -Wcast-align -Wwrite-strings -Wchar-subscripts	\
-Winline -Wnested-externs -Wredundant-decls -Wunused -Wformat=2
endif

libguile_readline_extras_la_LDFLAGS = -no-undefined $(GUILE_LDFLAGS)
