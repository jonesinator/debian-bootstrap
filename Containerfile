FROM docker.io/library/debian:bookworm-slim
RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
      arch-test \
      bc \
      binutils \
      ca-certificates \
      cpio \
      curl \
      debootstrap \
      diffoscope \
      dirmngr \
      dosfstools \
      file \
      git \
      gpg \
      gpg-agent \
      kmod \
      libarchive-tools \
      libcap2-bin \
      parted \
      pigz \
      qemu-user-static \
      quilt \
      rsync \
      wget \
      xxd \
      xz-utils \
      zerofree \
      zip \
      zstd \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN wget https://github.com/RPi-Distro/pi-gen/archive/refs/tags/2024-10-22-raspios-bookworm-arm64.tar.gz \
 && mkdir pi-gen \
 && tar xf *raspios*.tar.gz --strip-components 1 -C pi-gen \
 && rm *raspios*.tar.gz \
 && sed -i 's/${binfmt_misc_required}/0/' pi-gen/scripts/dependencies_check \
 && touch pi-gen/stage3/SKIP pi-gen/stage4/SKIP pi-gen/stage5/SKIP \
 && touch pi-gen/stage4/SKIP_IMAGES pi-gen/stage5/SKIP_IMAGES
COPY bootstrap bootstrap-rpi double-bootstrap /src
ENTRYPOINT ["./double-bootstrap"]
