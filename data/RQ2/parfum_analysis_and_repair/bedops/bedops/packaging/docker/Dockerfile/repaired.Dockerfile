# standalone docker image
FROM debian:jessie

RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y libc6-dev build-essential tcsh devscripts debhelper && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

# copy the source context into the local image
#  note: make sure .dockerignore is up to date
COPY . /bedops

# build and install bedops into system path
WORKDIR /bedops
RUN make -j `nproc` && make install BINDIR=/usr/bin
WORKDIR /
RUN rm -rf /bedops
