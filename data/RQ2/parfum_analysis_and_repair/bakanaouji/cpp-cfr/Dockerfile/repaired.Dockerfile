FROM ubuntu:20.04

ENV HOME /root

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y valgrind cmake wget && rm -rf /var/lib/apt/lists/*;

# Install Boost
RUN cd /home \
    && wget https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz \
    && tar xfz boost_1_76_0.tar.gz \
    && rm boost_1_76_0.tar.gz \
    && cd boost_1_76_0 \
    && ./bootstrap.sh --with-libraries=serialization,filesystem \
    && ./b2 install

RUN mkdir $HOME/cpp-cfr
COPY ./ $HOME/cpp-cfr
WORKDIR $HOME/cpp-cfr
