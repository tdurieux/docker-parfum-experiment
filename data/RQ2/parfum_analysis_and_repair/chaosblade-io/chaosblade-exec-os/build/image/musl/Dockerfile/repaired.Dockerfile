FROM golang:1.13.1
LABEL maintainer="Changjun Xiao"

# # The image is used to build chaosblade for musl
RUN wget https://www.musl-libc.org/releases/musl-1.1.21.tar.gz \
    && tar -zxvf musl-1.1.21.tar.gz \
    && rm musl-1.1.21.tar.gz \
    && cd musl* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && rm -rf musl*

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;

ENV CC /usr/local/musl/bin/musl-gcc
ENV GOOS linux

ENTRYPOINT [ "make" ]
