from espressopp/buildenv:ubuntu

ARG COVERAGE
ARG XTC
ARG CC
ARG CXX

COPY . /home/espressopp/espressopp/

WORKDIR /home/espressopp/espressopp
USER root

RUN mkdir build

WORKDIR build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr -DWITH_XTC=$XTC ..
RUN make -j4 all
RUN make install
WORKDIR ../examples