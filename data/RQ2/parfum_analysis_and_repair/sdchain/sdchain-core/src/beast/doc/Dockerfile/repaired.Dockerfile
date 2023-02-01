FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential g++ git libbz2-dev wget python-dev && rm -rf /var/lib/apt/lists/*;

# Install Boost
ENV BOOST_SHA 440a59f8bc4023dbe6285c9998b0f7fa288468b889746b1ef00e8b36c559dce1
RUN wget https://sourceforge.net/projects/boost/files/boost/1.62.0/boost_1_62_0.tar.gz
RUN echo "$BOOST_SHA  boost_1_62_0.tar.gz" | sha256sum -c
RUN tar xzf boost_1_62_0.tar.gz && rm boost_1_62_0.tar.gz
RUN cd boost_1_62_0 && ./bootstrap.sh --prefix=/usr/local
RUN cd boost_1_62_0 && ./b2 install
ENV BOOST_ROOT=/boost_1_62_0

# Install dependencies
RUN apt-get -y --no-install-recommends install doxygen && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install xsltproc && rm -rf /var/lib/apt/lists/*;

CMD cd /opt/beast/doc && \
    chmod +x makeqbk.sh && \
    ./makeqbk.sh && \
    $BOOST_ROOT/b2
