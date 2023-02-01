# For a docker image that can be used interactively for build and test
#
# e.g. Assuming that you have cloned the project to $HOME/workspace/authservice, you can:
# docker run -it -v $HOME/workspace/authservice:/code authservice-build-env:$USER bash
# cd /code
# make
#
FROM ubuntu:xenial
RUN apt-get update && apt-get install --no-install-recommends git build-essential wget -y && rm -rf /var/lib/apt/lists/*;
COPY ./build/install-bazel.sh /tmp/install-bazel.sh
RUN /tmp/install-bazel.sh
