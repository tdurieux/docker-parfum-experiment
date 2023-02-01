FROM ubuntu

MAINTAINER John Vivian, jtvivian@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /home

RUN git clone https://github.com/lh3/bwa.git

WORKDIR /home/bwa

RUN wget https://zlib.net/zlib-1.2.11.tar.gz
RUN tar xvzf zlib-1.2.11.tar.gz && rm zlib-1.2.11.tar.gz

WORKDIR /home/bwa/zlib-1.2.11
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make

WORKDIR /home/bwa

RUN git checkout Apache2
RUN sed -e's#INCLUDES=#INCLUDES=-Izlib-1.2.11/ #' -e's#-lz#zlib-1.2.11/libz.a#' Makefile > Makefile.zlib
RUN make -f Makefile.zlib
