ARG IMAGE
FROM $IMAGE
MAINTAINER Romain Beauxis <toots@rastageeks.org>

ARG COMPILER
ARG SYSTEM

RUN sed -i /etc/apt/sources.list -e 's#jessie#testing#g' && (apt-get update || true) && \
      apt-get install -y --force-yes gawk aspcud binutils automake lzip && \
      apt-get -y --force-yes autoremove && apt-get -y --force-yes clean

WORKDIR /usr/src/mxe
RUN git pull origin master && make cc cmake

RUN wget https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh -O /tmp/install.sh && echo /usr/local/bin | sh /tmp/install.sh

RUN useradd -g staff --create-home opam

ADD packages/ /home/opam/opam-cross-windows/packages

ADD repo /home/opam/opam-cross-windows/repo

RUN chown -R opam /home/opam/opam-cross-windows

USER opam

WORKDIR /home/opam/opam-cross-windows

RUN opam init --auto --compiler=$COMPILER --disable-sandboxing

RUN opam repository add windows /home/opam/opam-cross-windows

RUN if [ "$SYSTEM" = "x64" ]; then \
      export TOOLPREF64=/usr/src/mxe/usr/bin/x86_64-w64-mingw32.static- && \
      eval $(opam env) && opam update && \
      opam install -y ocaml-windows; \
    fi

RUN if [ "$SYSTEM" = "x86" ]; then \
      export TOOLPREF32=/usr/src/mxe/usr/bin/i686-w64-mingw32.static- && \
      eval $(opam env) && opam update && \
      opam install -y ocaml-windows; \
    fi
