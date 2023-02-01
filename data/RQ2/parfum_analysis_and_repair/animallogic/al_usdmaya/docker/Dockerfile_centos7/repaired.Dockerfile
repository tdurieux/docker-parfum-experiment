############################################################
# Dockerfile that builds and runs dependant docker files

FROM usd-docker/usd:centos7-usd-0.7.5

MAINTAINER Animal Logic
COPY ./ /tmp/usd-build/AL_USDMaya
COPY ./docker/build_alusdmaya.sh /tmp/
RUN /tmp/build_alusdmaya.sh

# Setup the environment using the location where AL_USDMaya is installed