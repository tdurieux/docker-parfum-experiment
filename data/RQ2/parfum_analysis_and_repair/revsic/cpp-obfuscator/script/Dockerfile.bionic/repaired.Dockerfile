FROM ubuntu:18.04

RUN apt-get update -yq && apt-get install --no-install-recommends -yq build-essential cmake python3.6 python3.6-dev python3-pip python3-setuptools python3-wheel && rm -rf /var/lib/apt/lists/*;
RUN echo `g++ --version`

ADD . /app

# Run UnitTest
WORKDIR /app/test/build
RUN cmake .. && \
    make -j `nproc` && \
    ./unittest

# Run Additional Test
WORKDIR /app/sample/build
RUN cmake .. && \
    make -j `nproc`

WORKDIR /app
RUN python3 -m script.merge && \
    python3 -m script.string_obfs_tester ./sample/build/string_obfs "Hello World !"
