FROM debian:jessie
RUN apt-get update && \
    apt-get install --no-install-recommends -y python2.7 \
                       make \
                       qemu-kvm \
                       gcc=4:4.9* \
                       lib32gcc-4.9-dev \
                       mtools && rm -rf /var/lib/apt/lists/*;
