FROM ubuntu:20.04

ARG UID=1000
ARG GID=1000

ENV LANG C.UTF-8

# fix tzdata promt issue
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
                        build-essential ccache cmake g++ gcc g++-multilib gcc-multilib \
                        libsdl2-dev:i386 libopenal-dev:i386 libsdl2-2.0-0:i386 libopenal1:i386 libgl1:i386 && \
    /usr/sbin/update-ccache-symlinks && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --gid $GID runner
RUN useradd --home-dir /home/runner --no-create-home --gid runner --uid $UID --shell /bin/sh runner

RUN mkdir -p /home/runner/src && \
    mkdir -p /home/runner/bin && \
    mkdir -p /home/runner/build && \
    mkdir -p /home/runner/.ccache && \
    chown runner:runner -R /home/runner

ENV PATH="/usr/lib/ccache:${PATH}"

WORKDIR /home/runner/build
