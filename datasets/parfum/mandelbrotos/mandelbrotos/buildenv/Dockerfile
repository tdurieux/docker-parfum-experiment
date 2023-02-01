# Ubuntu docker build 

FROM ubuntu:18.04
WORKDIR /devenv
RUN apt-get update
RUN apt-get install -y build-essential \
                       qemu \
                       nasm \ 
                       xorriso \
                       wget \
                       mtools \
                       uuid-dev \
                       parted \
                       udev \
                       vim
COPY ./ ./
RUN make toolchain