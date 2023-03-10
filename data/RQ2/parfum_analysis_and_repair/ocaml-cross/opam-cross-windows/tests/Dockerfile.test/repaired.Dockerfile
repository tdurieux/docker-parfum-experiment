ARG IMAGE
FROM $IMAGE
MAINTAINER Romain Beauxis <toots@rastageeks.org>

ARG OPAM_PKG

ARG PKG_CONFIG_PATH

USER root

USER opam

RUN opam list --short --recursive --external --vars os-distribution=mxe,os-family=mingw --required-by=$OPAM_PKG > /home/opam/mxe-deps

USER root

RUN cd /usr/src/mxe/ && cat /home/opam/mxe-deps | xargs make

USER opam

RUN eval $(opam env) && opam reinstall --verbose -y $OPAM_PKG