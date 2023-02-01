FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y \
 build-essential \
 cmake \
 git \
 nano \
 nodejs \
 npm \
 vim && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN mkdir /tutorial

WORKDIR /tutorial
RUN git clone --branch next --recursive https://github.com/youngar/Base9.git

WORKDIR /tutorial/Base9
RUN npm install && npm cache clean --force;
RUN mkdir build

WORKDIR /tutorial/Base9/build
RUN cmake -DCMAKE_BUILD_TYPE=Debug ..
RUN make -j8

ADD go /go
CMD  /bin/bash /go

