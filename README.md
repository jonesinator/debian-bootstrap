# debian-bootstrap

This repository contains a script which performs the same actions and ends up
with the same results as [debootstrap](https://wiki.debian.org/Debootstrap), but
uses substantially less code, so is more readable and easier to understand.

The `bootstrap` script is a standalone script that can be can be run without any
arguments, and is equivalent to the `debootstrap` invocation:

```sh
debootstrap bookworm debian https://deb.debian.org/debian
```

The `double-bootstrap` script is a helper/demonstration script that runs both
the `bootstrap` script and `debootstrap`, runs a small cleaning script to remove
a few non-reproducible unnecessary files, and compares the results using
diffoscope.

A `Containerfile` exists that creates a minimal Debian container image with
enough packages to run both `debootstrap` and the `double-bootstrap` script
from this repository. When the image is run, the `double-bootstrap` script
starts, and should return `0` if successful, or something else otherwise.

The `.github/workflows/main.yml` file contains a GitHub Actions script that
builds and runs the container image, verifying that `bootstrap` and
`debootstrap` indeed produce the same results.

All scripts pass [shellcheck](https://www.shellcheck.net/).

Documentation is a bit barebones since development is ongoing.

## Plans

It would be good to ensure the result of
[debuerreotype](https://github.com/debuerreotype/debuerreotype) can also be
replicated.

Integrating the results of
[rpi-imager](https://github.com/raspberrypi/rpi-imager) is another goal, as is
replicating the "standard" bootable ISO image for x86\_64 debian.

Replicate the results using more container bases: fedora, suse, arch, alpine,
gentoo, etc.

Eventually a Debian ouroboros could be created, where we also grab all of the
build dependencies and sources for all of these packages and ensure that they
can all be rebuilt from source and are reproducible. What you end up with is a
"self-consistent" set of packages that can build themselves, including a
bootable asset which can run it all. This doesn't really solve any bootstrapping
problems, but it does make the software bill-of-materials very concrete.

So, you start with access to the internet, some key fingerprints, and a few
rules, and you can end up with a self sustaining system that can be airgapped.
