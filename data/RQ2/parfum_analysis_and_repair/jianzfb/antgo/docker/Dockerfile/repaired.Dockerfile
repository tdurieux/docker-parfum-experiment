# Build as antgo/server

FROM jupyter/scipy-notebook:8f56e3c47fec
MAINTAINER Project Antgo <jian@mltalker.com>

# install antgo and its dependence
USER root
ADD install.sh install.sh
RUN bash install.sh

# set enviroment variable