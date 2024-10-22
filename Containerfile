FROM docker.io/library/debian:bookworm-slim
RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
      binutils \
      ca-certificates \
      debootstrap \
      diffoscope \
      dirmngr \
      gpg \
      gpg-agent \
      xz-utils \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY bootstrap double-bootstrap /src
ENTRYPOINT ["./double-bootstrap"]
