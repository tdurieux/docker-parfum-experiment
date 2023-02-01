# trusty
FROM ubuntu:16.04 as package_elfutils_intermediate

# install dependencies
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y software-properties-common build-essential curl libcurl4-gnutls-dev \
        autotools-dev autoconf libtool liblzma-dev libz-dev gettext libdwarf-dev pkg-config && rm -rf /var/lib/apt/lists/*;

FROM package_elfutils_intermediate

WORKDIR /opt
ADD . /opt/

RUN curl -f -o /tmp/elfutils.tar.bz2 https://sourceware.org/elfutils/ftp/0.181/elfutils-0.181.tar.bz2 && tar -xvf /tmp/elfutils.tar.bz2 && rm /tmp/elfutils.tar.bz2
CMD ./build_elfutils.sh /opt /artifacts /opt/elfutils-0.181
