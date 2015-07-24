#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([pocket], [0.2.9], [manowar@altlinux.org])

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

# Output
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
