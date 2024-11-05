#!/bin/sh
FROM docker.io/library/debian:bookworm-slim as debootstrap-jr
RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
      binutils \
      ca-certificates \
      dirmngr \
      gpg \
      gpg-agent \
      wget \
      xz-utils \
 && rm -rf /var/lib/apt/lists/*
COPY debootstrap-jr /usr/local/bin
ENTRYPOINT ["debootstrap-jr"]

FROM docker.io/library/debian:bookworm-slim as debootstrap
RUN apt-get update \
 && apt-get install --yes \
      arch-test \
      ca-certificates \
      debian-archive-keyring \
      git \
      gnupg \
      wget \
      xz-utils \
 && rm --recursive --force /var/lib/apt/lists/*
RUN git clone https://salsa.debian.org/installer-team/debootstrap.git \
 && cd debootstrap \
 && git checkout cef6d5d69a4ceac80db6fe3bbefc96ebc362087f
ENTRYPOINT ["/debootstrap/debootstrap"]

FROM docker.io/library/debian:bookworm-slim as lint
RUN apt-get update \
 && apt-get install --yes \
      cloc \
      make \
      shellcheck \
      wget \
 && rm --recursive --force /var/lib/apt/lists/* \
 && wget https://go.dev/dl/go1.23.2.linux-amd64.tar.gz \
 && tar --extract --file go*.tar.gz --directory /usr/local \
 && rm go*.tar.gz \
 && apt-get remove --purge --yes wget
RUN useradd lint --create-home
USER lint
ENV PATH="$PATH:/usr/local/go/bin:/home/lint/go/bin"
RUN go install mvdan.cc/sh/v3/cmd/shfmt@v3.10.0
