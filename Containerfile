#FROM docker.io/library/debian:bookworm-slim as bootstrap
#RUN apt-get update && apt-get install --yes --no-install-recommends debootstrap
#ENTRYPOINT ["debootstrap", "bookworm", "/mnt/]
#
#FROM docker.io/library/debian:bookworm-slim as bootstrap-rpi
#RUN apt-get update && apt-get install --yes --no-install-recommends debootstrap
#ENTRYPOINT ["debootstrap", "bookworm", "/mnt/]

FROM docker.io/library/debian:bookworm-slim as debootstrap
RUN apt-get update && apt-get install --yes debootstrap
ENTRYPOINT ["debootstrap", "bookworm", "/out/rootfs", "https://deb.debian.org/debian"]

FROM docker.io/library/debian:bookworm-slim as pi-gen
ADD https://github.com/RPi-Distro/pi-gen/archive/refs/tags/2024-10-22-raspios-bookworm-arm64.tar.gz .
RUN mkdir pi-gen \
 && tar xf *raspios*.tar.gz --strip-components 1 -C pi-gen \
 && rm *raspios*.tar.gz \
 && cd pi-gen \
 && sed -i 's/${binfmt_misc_required}/0/' scripts/dependencies_check \
 && touch stage3/SKIP stage4/SKIP stage4/SKIP_IMAGES stage5/SKIP stage5/SKIP_IMAGES
WORKDIR /pi-gen
RUN apt-get update \
 && apt-get install --yes --no-install-recommends $(cat depends | sed 's/.*://') \
 && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["./build.sh"]
