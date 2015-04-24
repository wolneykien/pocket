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

POCKET_VERSION="0.2.0"
PROG_VERSION="$POCKET_VERSION"

CONFDIR="/etc/pocket"
USERCONFDIR="$HOME/.pocket"
DEFCONFNAME="pocket.conf"
DEFPOCKETDIR="$HOME/pocket"

POCKETFILE='Pocketfile'
POCKETSUF='.pocket'

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


find_config()
{
    local name="${1:-$DEFCONFNAME}"
    local config=

    #if [ -f "./$name" ]; then
    #    echo "./$name"
    #    return 0
    #fi

    config="${USERCONFDIR%/}/$name"
    if [ -f "$config" ]; then
        echo "$config"
        return 0
    fi

    config="${CONFDIR%/}/$name"
    if [ -f "$config" ]; then
        echo "$config"
        return 0
    fi

    config="${0%/*}/$name"
    if [ -f "$config" ]; then
        echo "$config"
        return 0
    fi

    return 1
}

assert_config()
{
    local config="$1"

    [ -n "$config" ] || fatal 'Configuration file is not specified\n'
    [ -f "$config" ] || fatal 'Configuration file not found: %s\n' \
                              "$config"
}

load_config()
{
    local config="$(find_config "${1:-}")"

    assert_config "$config"

    . "$config"
    CONFIG="$config"
}

quote_sed()
{
    sed -e 's/\\/\\\\/g' \
        -e 's,/,\\/,g' \
        -e 's/"/\\"/g'
}

is_pocketfile()
{
    local config="$1"

    [ "${config##*/}" = "$POCKETFILE" -o \
        "${config##*.}" = "$POCKETSUF" ]
}

set_config_val()
{
    local config="$1"
    local name="$2"
    local val="$3"

    assert_config "$config"

    [ -n "$name" ] || fatal 'Variable name is empty\n'

    [ -z "$val" ] || val="$( echo "$val" | quote_sed )"

    if is_pocketfile "$config"; then
        sed -i \
            -e "s/^$name[[:space:]]*=.*\$/$name = $val/" \
            -e 't out' \
            -e 'p' \
            -e "\$ s/^.*\$/$name = $val/p" \
            -e 'd' \
            -e ': out' \
            -e '    n; b out' \
          "$config"
    else
        sed -i \
            -e "s/^$name[[:space:]]*=.*\$/$name=\"$val\"/" \
            -e 't out' \
            -e 'p' \
            -e "\$ s/^.*\$/$name=\"$val\"/p" \
            -e 'd' \
            -e ': out' \
            -e '    n; b out' \
          "$config"
    fi
}

del_config_val()
{
    local config="$1"
    local name="$2"

    assert_config "$config"

    [ -n "$name" ] || fatal 'Variable name is empty\n'

    sed -i -e "/^$name[[:space:]]*=/ d" "$config"
}

del_config_section()
{
    local config="$1"
    local section="$2"

    assert_config "$config"

    [ -n "$section" ] || fatal 'Section name is empty\n'

    sed -i -n \
        -e '/^[[:space:]]*$/ { H; d }' \
        -e "/^#[[:space:]]*$section[[:space:]]*\$/ { H; n; b chkdash }" \
        -e 'H; g; s/^\n//; p; s/^.*$//; h; d' \
        -e ': chkdash' \
        -e '/^#[[:space:]]*---\+/ { s/^.*$//; h; n; b found }' \
        -e 'H; g; s/^\n//; p; s/^.*$//; h; d' \
        -e ': found' \
        -e '/^[[:space:]]*$/ { H; n; b found }' \
        -e '/^#[[:space:]]*---\+/ {
                H; g; s/^\n//;
                s/\n#[\t ]*[^\t ]\+\n#[\t ]*---\+[[:space:]]*$/&/p;
                t new;
                s/^.*$//; h;
                n; b found
            }' \
        -e '/#[[:space:]]*[^[:space:]]\+/ { H; n; b found }' \
        -e 's/^.*$//; h; n; b found' \
        -e ': new' \
        -e 's/^.*$//; h; d' \
      "$config"
}


avail_flavours()
{
    printf '\t%s\t%s/%s\n' 'debian' 'apt' 'deb'
# TODO: altlinux apt rpm
}

# Outputs the report on available flavours
print_flavours()
{
    printf 'Available pocket flavours:\n\n'
    avail_flavours
}

guess_flavour()
{
    echo 'debian'
# TODO: make a real guess :-)
}

getarch() {
    local dpkg="$(which dpkg ||:)"
    local arch=
    if [ -n "$dpkg" ]; then
        arch="$("$dpkg" --print-architecture)"
    fi
    if [ -z "$arch" ]; then
        arch="$(uname -m)"
    fi

    echo "$arch"
}

make_workdir()
{
    mktemp -d "pocket.XXXXXXXXXX"
}

cleanup_workdir()
{
    local workdir="${1:-$workdir}"

    rm -rf "${workdir%/}"
}
