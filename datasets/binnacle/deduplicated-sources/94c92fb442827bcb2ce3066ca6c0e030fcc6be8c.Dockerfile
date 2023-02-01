#
# Docker image for srclib-python

#
# Dependencies
#
FROM python:3.5.1-slim
RUN apt-get update
RUN apt-get install -qq make git tar
RUN pip3.5 install virtualenv

#
# Install srclib-python executable
#
ENV SRCLIBPATH /srclib/toolchains
ARG TOOLCHAIN_URL
ADD $TOOLCHAIN_URL /toolchain/t
RUN (cd /toolchain && tar xfz t && rm t && mv * /toolchain/t) || true
RUN mkdir -p $SRCLIBPATH/sourcegraph.com/sourcegraph && mv /toolchain/t $SRCLIBPATH/sourcegraph.com/sourcegraph/srclib-python
WORKDIR $SRCLIBPATH/sourcegraph.com/sourcegraph/srclib-python
RUN make install

#
# Install srclib binary (assumes this has been built on the Docker host)
#
ADD ./srclib /bin/srclib

# Run environment
ENTRYPOINT srclib config && srclib make
