FROM ubuntu:18.04 as build

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        binutils-mips-linux-gnu \
        bsdmainutils \
        build-essential \
        libcapstone-dev \
        pkgconf \
        python3 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /sm64
WORKDIR /sm64
ENV PATH="/sm64/tools:${PATH}"

CMD echo 'usage: docker run --rm --mount type=bind,source="$(pwd)",destination=/sm64 sm64 make VERSION=us -j4\n' \
         'see https://github.com/n64decomp/sm64/blob/master/README.md for advanced usage'
