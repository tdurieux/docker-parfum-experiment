FROM ubuntu:18.04
MAINTAINER Chris Ohk <utilforever@gmail.com>

RUN apt-get update -yq && \
    apt-get install --no-install-recommends -yq build-essential cmake && rm -rf /var/lib/apt/lists/*;

ADD . /app

WORKDIR /app/build
RUN cmake .. && \
    make -j`nproc` && \
    make install
