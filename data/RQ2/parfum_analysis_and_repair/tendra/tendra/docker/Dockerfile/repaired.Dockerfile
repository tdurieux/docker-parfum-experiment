FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386
RUN apt update -y -q && apt upgrade -y -q && apt update -y -q
RUN apt install --no-install-recommends -y -q \
    pmake \
    g++ \
    gcc \
    gcc-multilib \
    libc6-dev-i386 \
    linux-libc-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /tendra

WORKDIR /tendra
VOLUME ["/tendra"]
CMD ["bash"]
