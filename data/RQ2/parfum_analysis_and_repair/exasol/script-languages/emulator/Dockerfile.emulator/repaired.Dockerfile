FROM exaudf/release_mini
#FROM ubuntu:16.04

RUN mkdir /exasol_emulator

COPY emulator/ /exasol_emulator
COPY src/zmqcontainer.proto /exasol_emulator

RUN apt-get -y --no-install-recommends install python-protobuf && rm -rf /var/lib/apt/lists/*;

#        software-properties-common \
#        coreutils \
#        locales \
#        python-dev  \
#        libzmq-dev \
#        python-zmq \
#        protobuf-compiler \
#	python-pip \
#	python-protobuf && \
#    locale-gen en_US.UTF-8 && \
#    update-locale LC_ALL=en_US.UTF-8 && \
#    apt-get -y clean && \
#    apt-get -y autoremove && \
#    ldconfig

RUN cd /exasol_emulator && protoc zmqcontainer.proto --python_out=.
RUN ls /exasol_emulator
