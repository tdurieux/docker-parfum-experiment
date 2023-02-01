# Ubuntu docker build

FROM ubuntu:18.04
WORKDIR /devenv
RUN apt-get update && apt-get install --no-install-recommends -y build-essential \
                       qemu \
                       nasm \
                       xorriso \
                       wget \
                       mtools \
                       uuid-dev \
                       parted \
                       udev \
                       vim && rm -rf /var/lib/apt/lists/*;
COPY ./ ./
RUN make toolchain