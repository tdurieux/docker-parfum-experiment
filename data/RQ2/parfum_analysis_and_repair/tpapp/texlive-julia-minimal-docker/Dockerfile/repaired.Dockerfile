FROM ubuntu:20.04
MAINTAINER Tamas K. Papp <tkpapp@gmail.com>

WORKDIR /test

ADD files/install-julia.sh /test/install-julia.sh
ADD files/.ssh/ /root/.ssh/
ADD files/latex-tests/ /test/latex-tests/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
        && apt-get install -y --no-install-recommends -qq texlive-latex-base git \
        texlive-luatex texlive-pictures texlive-latex-extra pdf2svg \
        poppler-utils gnuplot-nox wget ca-certificates openssh-client rsync file \
        && /test/install-julia.sh 1 \
        && chmod 700 /root/.ssh && chmod 600 /root/.ssh/* && rm -rf /var/lib/apt/lists/*;

ENV NAME texlive-julia-docker
