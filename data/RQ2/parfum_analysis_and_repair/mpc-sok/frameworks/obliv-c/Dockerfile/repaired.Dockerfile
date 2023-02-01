FROM ubuntu:16.04
WORKDIR /root

RUN apt-get update && apt-get install --no-install-recommends -y \
  ocaml \
  libgcrypt20-dev \
  ocaml-findlib \
  opam \
  m4 \
  git \
  vim \
  gcc \
  make && rm -rf /var/lib/apt/lists/*;

ADD install.sh .
RUN ["bash", "install.sh"]

ADD source/ /root/
ADD ./README.md .
