FROM ubuntu:18.04

RUN apt-get update -yq && apt-get install --no-install-recommends -yq build-essential cmake && rm -rf /var/lib/apt/lists/*;
RUN echo `g++ --version`

ADD . /app
WORKDIR /app/test/build

RUN cmake .. && \
    make -j `nproc` && \
    ./catch_test
