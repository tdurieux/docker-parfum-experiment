FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -yq upgrade && apt-get install --no-install-recommends -yq libguestfs-tools syslinux linux-image-amd64 vim && rm -rf /var/lib/apt/lists/*;
