FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
        automake \
        bison \
        build-essential \
        cmake \
        curl \
        doxygen \
        flex \
        git \
        less \
        libtool \
        python \
        vim \
        zip \
 && true && rm -rf /var/lib/apt/lists/*;

# http://www.doxygen.nl/manual/install.html

RUN curl -f https://sourceforge.net/projects/doxygen/files/rel-1.8.14/doxygen-1.8.14.src.tar.gz/download \
        -L -o /doxygen-1.8.14.src.tar.gz \
 && cd / \
 && tar -xvf doxygen-1.8.14.src.tar.gz \
 && cd doxygen-1.8.14 \
 && mkdir build \
 && cd build \
 && cmake -G "Unix Makefiles" .. \
 && make \
 && make install \
 && true && rm doxygen-1.8.14.src.tar.gz
