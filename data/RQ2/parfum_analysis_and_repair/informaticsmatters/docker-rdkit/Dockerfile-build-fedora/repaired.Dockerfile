# Dockerfile for building RDKit artifacts.
# This is a heavyweight image containing all aspects of RDKit plus the build system.
# It's purpose is to create the RDKit artifacts that will be deployed to lighter weigth images.


FROM fedora:30
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"


RUN dnf update -y &&\
  dnf groupinstall -y "Development Tools" &&\
  dnf install -y --setopt=override_install_langs=en_US.utf8 --setopt=tsflags=nodocs\
  cmake\
  tk-devel\
  readline-devel\
  zlib-devel\
  bzip2-devel\
  sqlite-devel\
  python3-devel\
  numpy\
  boost\
  boost-devel\
  boost-python3-devel\
  g++\
  eigen3\
  eigen3-devel\
  swig\
  git\
  java-1.8.0-openjdk-devel &&\
#  java-11-openjdk-devel &&\