FROM ubuntu:20.04

WORKDIR /mount

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
          libguestfs-tools \
          qemu-utils \
          linux-image-generic && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["guestfish"]
