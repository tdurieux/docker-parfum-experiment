FROM ubuntu:jammy

RUN apt update && \
    apt install --no-install-recommends -y build-essential \
    git gcc wget curl musl-dev file \
    perl python3 rsync bc patch unzip cpio && rm -rf /var/lib/apt/lists/*;

RUN adduser \
    --gecos "Buildroot" \
    --disabled-login \
    --uid 1000 buildroot && \
    mkdir -p /home/buildroot && \
    chown buildroot:buildroot /home/buildroot && \
    echo "buildroot    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV LANG C.UTF-8

USER buildroot
WORKDIR /home/buildroot
