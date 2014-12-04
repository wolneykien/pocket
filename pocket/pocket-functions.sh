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
USERCONFDIR="$HOME/.pocket"
DEFCONFNAME="pocket.conf"

POCKETFILE=Pocketfile

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

    if [ -f "$name" ]; then
        echo "$name"
        return 0
    fi

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

quote_config()
{
    sed -n \
        -e '/^[[:space:]]*#/ { s/^[[:space:]]\+//; s/^.*$/&\\n/; p; d }' \
        -e '/^[^=]\+[[:space:]]*=.*/ s/^\([^=]\+\)[[:space:]]*=[[:space:]]*\(.*\)[[:space:]]*$/\1 = \2/' \
        -e '/\\[[:space:]]*\(#.*\)\?$/ { s/\\/\\\\/g; s/^.*$/&\\n/ }' \
        -e '/^[^=]\+[[:space:]]*=.*\\n$/ { h; d }' \
        -e '/^[^=]\+[[:space:]]*=.*/ { s/^.*$/&\\n/; p; d }' \
        -e '/\\n$/ { H; d }' \
        -e '{ H; x; s/\n//g; s/^[^=]\+[[:space:]]*=.*$/&\\n/p; s/^.*$//; x }' \
        -e '/^[[:space:]]*$/ { s/^.*$/\\n/; p; d }'
}

read_config()
{
    sed -n \
        -e '/^[[:space:]]*#/ d' \
        -e '/^[[:space:]]*$/ d' \
        -e 's/[[:space:]]*#[^\]*\\n/\\n/g' \
        -e 's/\\\\[[:space:]]*\\n/\\n/g' \
        -e 's/[[:space:]]*\\n[[:space:]]*/ /g' \
        -e 's/\\\\/\\/g' \
        -e 's/"/\\"/g' \
        -e 's/[[:space:]]\+$//' \
        -e 's/^\([^=[:space:]]\+\)[[:space:]]*=[[:space:]]*\(.*\)[[:space:]]*$/\1="\2";/p'
}

expand_config() {
    
}

load_config()
{
    local config="$(find_config "${1:-}")"

    assert_config "$config"

    eval "$(read_config <"$config")"
    echo "$config"
}

quote_sed()
{
    sed -e 's/\\/\\\\/g' \
        -e 's,/,\\/,g' \
        -e 's/"/\\"/g'
}

set_config_val()
{
    local config="$1"
    local name="$2"
    local val="$3"

    assert_config "$config"

    [ -n "$name" ] || fatal 'Variable name is empty\n'

    [ -z "$val" ] || val="$( echo "$val" | quote_sed )"

    sed -i \
        -e "s/^$name[[:space:]]*=.*\$/$name = $val/" \
        -e 't out' \
        -e 'p' \
        -e "\$ s/^.*\$/$name = $val/p" \
        -e 'd' \
        -e ': out' \
        -e '    n; b out' \
      "$config"
}

del_config_val()
{
    local config="$1"
    local name="$2"

    assert_config "$config"

    [ -n "$name" ] || fatal 'Variable name is empty\n'

    sed -i -e "/^$name[[:space:]]*=/ d" "$config"
}

# Updates the given config file with values from the reference one
# args: config-file-dest config-file-ref
update_config()
{
    local dest="$1"
    local ref="$2"

    if [ ! -f "$dest" ]; then
        cat "$ref" >"$dest"
        return 0
    fi

    local name=
    local val=
    while read ln; do
        name="$(echo "$ln" | sed -e '/^[^=]\+=/ { s/^\([^=]\+\)=.*$/\1/; p; q }')"
        set_config_val "$dest" "$name"
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


make_workdir()
{
    mktemp -d "pocket.XXXXXXXXXX"
}

cleanup_workdir()
{
    local workdir="${1:-$workdir}"

    rm -rf "${workdir%/}"
}
