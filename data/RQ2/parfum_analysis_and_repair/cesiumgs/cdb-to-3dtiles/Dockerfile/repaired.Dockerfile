FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install \
    build-essential \
    libgdal-dev \
    libpng-dev \
    libjpeg-dev \
    zlib1g-dev \
    cmake \
    make \
    libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/app

ENTRYPOINT ["/bin/bash", "-l", "-c"]