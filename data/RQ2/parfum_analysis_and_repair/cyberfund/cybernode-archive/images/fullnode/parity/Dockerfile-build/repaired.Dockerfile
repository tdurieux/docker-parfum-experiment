FROM rust:1.21

# install Parity build dependencies
# https://github.com/paritytech/parity#build-dependencies
RUN apt-get -y update && apt-get -y --no-install-recommends install libudev-dev && rm -rf /var/lib/apt/lists/*;

# build Parity from source
#--- commented block builds by fetching sources from container
#COPY 01build.sh .
#RUN bash 01build.sh
#
#VOLUME /build
#
## run time copy built binaries to provided /build volume
#CMD cp --verbose ./target/release/* /build
#---
#
