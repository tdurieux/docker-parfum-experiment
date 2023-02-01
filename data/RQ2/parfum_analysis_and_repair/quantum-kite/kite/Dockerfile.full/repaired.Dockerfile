FROM ubuntu:18.10

ARG UNAME=user
ARG UID=1000
ARG GID=1000

RUN apt-get update
RUN apt-get -y --no-install-recommends install cmake g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install valgrind gdb strace && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libhdf5-dev libeigen3-dev && rm -rf /var/lib/apt/lists/*;

RUN groupadd -g $GID -o $UNAME && useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

COPY . /root/kite/

WORKDIR /root
RUN cd kite && cmake . && make install && cd tools && cmake . && make install && cd && rm -rf kite

USER $UNAME
WORKDIR /home/${UNAME}
RUN mkdir /home/${UNAME}/kite
WORKDIR /home/${UNAME}/kite
