
NAME
----

`pocket-init` --- pocket chroot initialization and configuration tool


CONFIGURATION
-------------

The configuration files are looked up at `~/.pocket`, then at
`/etc/pocket`. The very last resort is the directory of `pocket-init`
script. The name of the main configuration file is `pocket.conf` (can
be overriden on the command line). It defines:

  * `POCKETDIR`:
    the default pocket directory (`~/pocket`);
  * `HSHPRIVDIR`:
    the path to the `hasher-priv` program;
  * `RESOLVCONF`:
    the path to the system `resolv.conf` file (`/etc/resolv.conf`).
    
There also are per-repository configuration files which are described
in the examples section below.


EXAMPLES
--------

*Note, the examples below show the `pocket-init` command but can
be run as `pocket init` too. See `pocket(1)` for more information.*

### Pocket initialization

First, if the pocket isn't initialized yet, i.e. `~/pocket/Pocketfile`
doesn't exist, initialize it. The only necessary parameter is the
*system repository* and *distribution* names. For example:

    pocket-init debian:jessie

However, it is wise to explicitly specify the system architecture
too:

    pocket-init -a i386 debian:jessie

Moreover, if you plan to use your new pocket for building packages,
then it is also the time to name the resulting distribution:

    pocket-init -a i386 -r "dragonflame" debian:jessie

The system repository name is used to select the corresponding
repository configuration file where the mirror URL and other
parametes such as pckage lists are specified. The configuration
file `<repo>.repo` is looked up at `~/.pocket`, then at
`/etc/pocket` (the very last resort is the directory of
`pocket-init` script).


### Pocket update

The initialization procedure creates the `Pocketfile` in the directory
specified via the configuration file or on the command line (defaults
to `~/pocket`). During the procedure, the contents of the repository
configuration file (i.e. `debian.repo`) *are copied* into the
`Pocketfile` by reasons of encapsulation. In order synchronize it
with new repository configuration use `pocket-init -u`. For example:

    pocket-init -u debian:jessie


SEE ALSO
--------

pocket(1), hasher-priv(8)
