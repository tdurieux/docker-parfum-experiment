# Dockerfile specifically for build testing from Jenkins
FROM ubuntu:xenial

ADD . /peloton
RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install python-dev lsb-release sudo && rm -rf /var/lib/apt/lists/*;

RUN /bin/bash -c "source ./peloton/script/installation/packages.sh"

RUN echo -n "Peloton Debug build with "; g++ --version | head -1
RUN mkdir /peloton/build && cd /peloton/build && cmake -DCMAKE_BUILD_TYPE=Debug -DCOVERALLS=False .. && make -j4 && make install

RUN echo -n "Peloton Release build with "; g++ --version | head -1
RUN rm -rf /peloton/build && mkdir /peloton/build && cd /peloton/build && cmake -DCMAKE_BUILD_TYPE=Release -DCOVERALLS=False .. && make -j4 && make install

RUN echo -n "Peloton Debug build with "; clang++-3.7 --version | head -1
RUN rm -rf /peloton/build && mkdir /peloton/build && cd /peloton/build && CC=clang-3.7 CXX=clang++-3.7 cmake -DCMAKE_BUILD_TYPE=Debug -DCOVERALLS=False .. && make -j4 && make install

RUN echo -n "Peloton Release build with "; clang++-3.7 --version | head -1
RUN rm -rf /peloton/build && mkdir /peloton/build && cd /peloton/build && CC=clang-3.7 CXX=clang++-3.7 cmake -DCMAKE_BUILD_TYPE=Release -DCOVERALLS=False .. && make -j4 && make install
