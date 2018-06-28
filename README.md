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

Useful utilities
----------------

pocket-build
============

Powerful script that performs:
   * pocket preparing
   * optional pocket cleaning
   * a package build

It is the core of build process.

Options and arguments
---------------------

  $ pocket-build [options] <arch>

  Available options:

   * -h, --help                            Print help and exit
   * -v, --verbose                         Print more useful information during work
   * --dry-run                             Check input and print information about
   * -r, --repos <repolist>                Set comma separated repository names list to use during build
   * -m, --mount <mountlist>               Overwrite comma separated list of host system mountpoints 
                                           assigned in pocket configuration
   * -C, --clean                           Full clear of chroot before build (for clean build)
   * -c,                                   Clear only all previously installed build depends before build
   * --crepo,                              Additionaly clear internal repo before build
   * --upg,                                Upgrade packages before build
   * -d <distribution>                     Set debian distribution name to build for (default:debian:jessie)
   * -A, --all                             Build only arch independed  packages (arch==all)
   * -B, --any                             Build only arch depended packages (arch==any)
   * -b, --bin                             Build only binary packages (arch==any|all)
   * -S, --src                             Build only source packages 
   * -g, --allsrc                          Build only source & arch independed packages 
   * -G, --anysrc                          Build only source & arch depended packages 
   * -i, --indir <directory>               Use this directory as source/input directory (default:.)
   * -o, --outdir <directory>              Use this directory as packages/output directory
   * -P <directory>                        Overwrite pocket directory assigned in pocket configuration
   * -j <count>                            Limit number of CPU cores to use during build

Example of arches:        armhf, i386, amd64

Getting info
------------

* `pocket(1)` and `pocket-init(1)` manpages;
* `help` and `doc` `Pocketfile` actions.


See also
--------

* <http://en.altlinux.org/Hasher>
