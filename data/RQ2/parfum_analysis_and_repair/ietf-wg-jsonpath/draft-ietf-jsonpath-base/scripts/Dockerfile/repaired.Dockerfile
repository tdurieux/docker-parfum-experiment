FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    ruby \
    python3-pip \
    bison \
    flex \
    xmlstarlet && rm -rf /var/lib/apt/lists/*;

RUN gem install kramdown-rfc2629 -v 1.3.17

RUN pip3 install --no-cache-dir xml2rfc==3.3.0

RUN git clone https://github.com/fenner/bap.git && \
    cd /bap && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make

ENV PATH="/bap:${PATH}"

RUN echo $PATH

RUN ls ./bap && pwd
