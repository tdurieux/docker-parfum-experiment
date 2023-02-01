FROM ocaml/opam:debian-9_ocaml-4.05.0

LABEL maintainer "Reto Buerki <reet@codelabs.ch>"
LABEL description "Build environment for Muen-enabled MirageOS/Solo5 static website unikernel"

RUN opam repository set-url default https://opam.ocaml.org
RUN opam update && opam upgrade
RUN opam install -y mirage

RUN git clone https://github.com/mirage/mirage-skeleton
WORKDIR mirage-skeleton/applications/static_website_tls

CMD [ "bash" ]
