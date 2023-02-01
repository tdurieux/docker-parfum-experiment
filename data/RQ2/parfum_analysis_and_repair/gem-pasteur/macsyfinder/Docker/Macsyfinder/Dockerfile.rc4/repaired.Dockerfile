FROM ubuntu:focal

MAINTAINER Bertrand Neron <bneron@pasteur.fr>

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y --no-install-recommends hmmer python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt clean -y

RUN pip3 install --no-cache-dir macsyfinder==2.0rc2

ENV DEBIAN_FRONTEND teletype
ENV PYTHONIOENCODING UTF-8

RUN useradd -m msf
USER msf
WORKDIR /home/msf

ENTRYPOINT ["/bin/sh", "-c", "macsyfinder $0 $@"]