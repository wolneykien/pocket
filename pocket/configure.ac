#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([pocket], [0.2.12], [manowar@altlinux.org])

AC_CONFIG_SRCDIR([pocket-functions.sh])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE
AM_MAINTAINER_MODE([enable])

# Checks for programs.
AC_PROG_LN_S
AC_PROG_SED
AC_CHECK_PROG(ronn,ronn,ronn)
test -n "$ronn" || AC_MSG_ERROR([ronn program not found])
AC_CHECK_PROG(help2man,help2man,help2man)
test -n "$help2man" || AC_MSG_ERROR([help2man program not found])

# Thanks systemd!
AC_ARG_WITH([bashcompletiondir],
        AS_HELP_STRING([--with-bashcompletiondir=DIR], [Bash completions directory]),
        [],
        [AS_IF([$(pkg-config --exists bash-completion)], [
                with_bashcompletiondir=$(pkg-config --variable=completionsdir bash-completion)
        ] , [
                with_bashcompletiondir=${datadir}/bash-completion/completions
        ])])
AM_CONDITIONAL(ENABLE_BASH_COMPLETION, [test "$with_bashcompletiondir" != "no"])
#AX_NORMALIZE_PATH([with_bashcompletiondir])

AC_SUBST([bashcompletiondir], [$with_bashcompletiondir])

# Output
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
