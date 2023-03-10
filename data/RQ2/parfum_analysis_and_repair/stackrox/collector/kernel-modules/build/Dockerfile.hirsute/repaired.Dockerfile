FROM ubuntu:hirsute

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends -y \
      binutils \
      cmake \
      make \
      curl \
      flex \
      bison \
      gcc \
      gcc-8 \
      gcc-9 \
      gcc-10 \
      gcc-11 \
      clang \
      llvm \
      g++ \
      libelf-dev \
      kmod \
      wget \
      golang-go \
      pkg-config \
 ; rm -rf /var/lib/apt/lists/*;

RUN apt-get autoremove -y

RUN mkdir -p /output
COPY build-kos /scripts/
COPY build-wrapper.sh /usr/bin/
COPY prepare-src /usr/bin

WORKDIR /scratch
ENTRYPOINT [ "/bin/bash", "-c" ]
