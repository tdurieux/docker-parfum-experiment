# Build container for Mirage 'static_website' example.

# Build distro must match that used to build 'mir-runner'.
FROM ocaml/opam:alpine-3.4_ocaml-4.03.0

RUN opam repo add mirage-dev git://github.com/mirage/mirage-dev
RUN opam depext -i mirage
RUN git clone -b mirage-dev http://github.com/mirage/mirage-skeleton
WORKDIR /home/opam/mirage-skeleton/static_website
RUN opam config exec -- mirage configure -t unix
RUN opam config exec make depend
RUN opam config exec make

# "Run" phase outputs built unikernel as a .tar.gz.
CMD tar -C /home/opam/mirage-skeleton/static_website -czh -f - www
