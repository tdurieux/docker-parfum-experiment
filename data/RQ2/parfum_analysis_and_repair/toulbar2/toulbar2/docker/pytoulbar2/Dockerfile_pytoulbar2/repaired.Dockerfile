###############################################################################
#
#                   Dockerfile_pytoulbar2 container
#
#           dedicated to pytoulbar2 Python API of toulbar2
#
# Desc ------------------------------------------------------------------------
#
# Installation with python3 -m pip install pytoulbar2
#
# Build -----------------------------------------------------------------------
#
# To build pytoulbar2-docker image :
#
#   docker build -f Dockerfile_pytoulbar2 -t pytoulbar2-docker:latest .
#
# Work inside -----------------------------------------------------------------
#
# Then to work inside pytoulbar2-docker image, under /WORK
# (as local folder to remaining results) :
#
#   docker run -v $PWD:/WORK -ti pytoulbar2-docker /bin/bash
#
###############################################################################

FROM debian:buster-slim

RUN apt-get update -yq \
&& apt-get install --no-install-recommends git-core -y \
&& apt-get install --no-install-recommends vim -y \
&& apt-get install --no-install-recommends python3 -y \
&& apt-get install --no-install-recommends python3-pip -y \
&& apt-get clean -y && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade pip \
&& python3 -m pip install pytoulbar2

RUN mkdir /WORK

###############################################################################

