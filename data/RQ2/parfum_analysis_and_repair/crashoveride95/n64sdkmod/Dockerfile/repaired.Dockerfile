FROM ubuntu:20.04

ENV PATH=/etc/n64/usr/sbin:${PATH}
ENV PATH=/opt/crashsdk/bin:${PATH}
ENV ROOT=/etc/n64
ENV N64_LIBGCCDIR=/opt/crashsdk/lib/gcc/mips64-elf/11.2.0

WORKDIR /opt/crashsdk

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y --no-install-recommends install build-essential git wget flex bison && \
    apt-get clean && \
    echo "deb [trusted=yes] https://crashoveride95.github.io/apt ./" > /etc/apt/sources.list.d/crashoveride95.list && \
    apt update && \
    apt-get -y --no-install-recommends install lib32z1 && \
    apt-get -y --no-install-recommends install libc6:i386 && \
    apt-get -y --no-install-recommends install binutils-mips-n64 gcc-mips-n64 newlib-mips-n64 && \
    apt-get -y --no-install-recommends install n64sdk && \
    apt-get -y --no-install-recommends install makemask && \
    apt-get -y --no-install-recommends install libnustd && \
    apt-get -y --no-install-recommends install libnusys && \
    apt-get -y --no-install-recommends install libnaudio && \
    apt-get -y --no-install-recommends install libmus && \
    apt-get -y --no-install-recommends install u64assets && \
    apt-get -y --no-install-recommends install n64graphics && \
    apt-get -y --no-install-recommends install vadpcm-tools && \
    apt-get -y --no-install-recommends install n64-conv-tools && \
    apt-get -y --no-install-recommends install rsp-tools && \
    apt-get -y --no-install-recommends install root-compatibility-environment && rm -rf /var/lib/apt/lists/*;
