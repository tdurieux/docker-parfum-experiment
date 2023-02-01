FROM ubuntu:18.04 as magicfromsourcepackages

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -yq g++ build-essential m4 csh libx11-dev libncurses-dev tcl-dev tk-dev blt-dev && rm -rf /var/lib/apt/lists/*;


FROM magicfromsourcepackages as magicfromsouce

RUN \
    apt-get install --no-install-recommends -yq git && \
    git clone git://opencircuitdesign.com/magic-8.2 && \
    cd magic-8.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm -rf /var/lib/apt/lists/*;
