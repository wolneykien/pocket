Pocket --- a compact package build system
=========================================

Pocket provides a compact package building environment with
non-privileged user access. It uses `hasher-priv` for environment
isolation.


Architecture
------------

All mainline procedures are implemented in one `Pocketfile` written
in the GNU Make language. The `Pocketfile` is generated from a
template which is modified based on the user configuration and given
customization parameters. The resulting `Pocketfile` *encapsulates* the
code, a particular configuration and inline documentation and can be
used without `pocket`-special utils, requiring only `make`, UNIX core
utils and `hasher-priv` for environment isolation. The only exception
is the initial *network* bootstrap procedure which requires some
additional utils, such as `debootstrap` for Debian chroot.

`Pocketfile` templates are selected based on the environment "flavour".
Currently there is only one flavour --- "debian", --- providing a
minimal Debian system for building `.deb` packages.


Getting info
------------

* `pocket(1)` and `pocket-init(1)` manpages;
* `help` and `doc` `Pocketfile` actions.


See also
--------

* <http://en.altlinux.org/Hasher>
