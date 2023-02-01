# ---
# Cribl AppScope - Build under Docker
#
# by Paul Dugas <paul@dugas.cc>
#

# ---
# Use the Ubuntu 18.04 image by default. Override this like below.
#
#     docker build --build-arg IMAGE=ubuntu:latest ...
#
ARG IMAGE=alpine:latest
FROM $IMAGE

# ---
# Install packages.
#
RUN apk add --no-cache \
    bash \
    emacs \
    gdb \
    git \
    go  \
    linux-headers \
    make \
    musl-dev \
    strace \
    sudo \
    tcpdump \
    vim

# ---
# Add the "builder" user
#
RUN adduser -h /home/builder -D builder && \
    \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/builder && \
    \
    echo "alias ll='ls -alF'" >> /home/builder/.profile && \
    echo "alias la='ls -A'" >> /home/builder/.profile && \
    echo "alias l='ls -CF'" >> /home/builder/.profile && \
    echo "alias h='history'" >> /home/builder/.profile && \
    \
    echo "#set environment LD_PRELOAD=/home/builder/appscope/lib/linux/libscope.so" >> /home/builder/.gdbinit && \
    echo "set follow-fork-mode child" >> /home/builder/.gdbinit && \
    echo "set breakpoint pending on" >> /home/builder/.gdbinit && \
    echo "set directories /home/builder/appscope" >> /home/builder/.gdbinit && \
    \
    mkdir /home/builder/appscope

# ---
# The local git clone of the project is mounted as /home/builder/appscope. See Makefile.
#
#     docker run -v $(pwd):/home/builder/appscope ...
#
WORKDIR /home/builder/appscope

# fini