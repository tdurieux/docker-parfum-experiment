# AriaCoda Test Build Container:
# A container that builds AriaCoda in an Debian Buster environment.
# libAria is built but no other builds or tests are done (yet).

# TODO I think we could build multiple test build containers by specifying multiple FROM commands? (In which case we would need to test for Xenial when setting EXTRA_CXXFLAGS in the build)

ARG IMAGE=debian:buster
FROM ${IMAGE}

# Not needed, if these are already in the image:
RUN apt-get update && apt-get --yes --no-install-recommends install g++ make && rm -rf /var/lib/apt/lists/*;

ADD include /tmp/AriaCoda/include
ADD src  /tmp/AriaCoda/src
ADD examples  /tmp/AriaCoda/examples
ADD tests  /tmp/AriaCoda/tests
ADD Makefile Makefile.inc /tmp/AriaCoda/

WORKDIR /tmp/AriaCoda
CMD make -j4
#EXTRA_CXXFLAGS=-DARIA_OMIT_DEPRECATED_MATH_FUNCS
# TODO install? run tests?

