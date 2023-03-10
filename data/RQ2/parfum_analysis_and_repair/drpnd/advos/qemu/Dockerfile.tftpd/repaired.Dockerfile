FROM ubuntu:18.04

MAINTAINER Hirochika Asai <panda@jar.jp>

## Install build-essentials and qemu
RUN apt-get update && apt-get install -y --no-install-recommends build-essential tftpd-hpa && rm -rf /var/lib/apt/lists/*;

## Copy source to the workdir
COPY src /usr/src
WORKDIR /usr/src
RUN make
RUN mkdir -p /tftpboot
RUN chmod 0777 /tftpboot
RUN cp advos.img /tftpboot

#EXPOSE 69

## Run the OS with qemu
CMD ["in.tftpd", "--foreground", "--secure", "/tftpboot"]
