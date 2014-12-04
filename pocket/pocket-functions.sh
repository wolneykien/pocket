#!/bin/sh -efu
#
# Copyright (C) 2014  Paul Wolneykien <manowar@altlinux.org>
# Copyright (C) 2014  STC Metrotek [http://metrotek.spb.ru/]
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

POCKET_VERSION="0.1.0"
PROG_VERSION="$POCKET_VERSION"

CONFDIR="/etc/pocket"
DEFCONFNAME="pocket.conf"

print_common_opts()
{
    cat <<EOF
Options:

  -q, --quiet          be quiet;
  -v, --verbose        be verbose;
  -V, --version        print program version and exit;
  -h, --help           show this text and exit;
EOF
}

show_usage() {
    echo
    show_help | head -1
    echo "Use \`$PROG --help\` for more information."
}

print_version()
{
    cat <<EOF
$PROG version $PROG_VERSION
EOF
    exit 0
}

write_error() {
    printf "$@" >&2
}

info() {
    [ -z "$verbose" ] || write_error "$@"
}

fatal() {
    write_error "$@"
    exit 1
}


load_config()
{
    local config="${1:-}"

    if [ -z "$config" ]; then
        config="${CONFDIR%/}/$DEFCONFNAME"
        [ -f "$config" ] || config="${0%/*}/$DEFCONFNAME"
    fi

    [ -f "$config" ] || fatal 'Configuration file not found: %s\n' \
                              "$config"

    . "$config"
}
