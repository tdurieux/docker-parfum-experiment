# Build container for Mirage 'stackv4' example.

# Build distro must match that used to build 'mir-runner'.
FROM ocaml/opam:alpine-3.4_ocaml-4.03.0

RUN opam repo add mirage-dev git://github.com/mirage/mirage-dev
RUN opam depext -i mirage
RUN git clone -b mirage-dev http://github.com/mirage/mirage-skeleton
WORKDIR /home/opam/mirage-skeleton/stackv4
RUN opam config exec -- mirage configure -t unix
RUN opam config exec make depend
RUN opam config exec make

# "Run" phase outputs built unikernel as a .tar.gz.