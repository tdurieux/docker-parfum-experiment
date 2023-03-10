# This Dockerfile packages the resistance-core build environment, allowing for easy generation of binaries
# on the local host and avoids all of the dependency issues between Ubuntu 16.04 and 18.04.
# NOTE: change the FROM line below to 16.04 if Xenial is your target Ubuntu distro
# Example:
# Run the following commands to build the image locally
# from a containerized build environment
#
# Build the image:
# docker build . -f ./Dockerfile.build --tag resistance-core-builder:latest --tag resistance-core-builder:$(git rev-parse --short HEAD)
#
# exec into an interactive container:
# WORKING_DIR=`basename $PWD` && docker run -ti --rm -v "$HOME":"$HOME" -v "$PWD":"/$WORKING_DIR" -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -w "/$WORKING_DIR" -u $( id -u $USER ):$( id -g $USER ) resistance-core-builder:latest /bin/bash
#
# then, from the root of the repo:
# ./resutil/build.sh --disable-tests
FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends build-essential automake libtool pkg-config libcurl4-openssl-dev curl bsdmainutils apt-utils -y && rm -rf /var/lib/apt/lists/*;
