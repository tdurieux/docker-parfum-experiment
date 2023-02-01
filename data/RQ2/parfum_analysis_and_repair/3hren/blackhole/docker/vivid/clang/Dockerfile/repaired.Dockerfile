FROM ubuntu:vivid

RUN apt-get update

RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libboost-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libboost-system-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libboost-thread-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install valgrind && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install clang++-3.6 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-3.6 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-3.6 100

COPY . /code/blackhole/

RUN dpkg -l | grep clang
RUN dpkg -l | grep boost

RUN mkdir -p /code/blackhole/build
WORKDIR /code/blackhole/build

RUN rm -rf *
RUN cmake -DENABLE_TESTING=ON ..
RUN make -j1
RUN valgrind ./blackhole-tests
