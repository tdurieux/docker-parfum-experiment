FROM debian:stable
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install curl make libtool bzip2 nasm && rm -rf /var/lib/apt/lists/*;

# Fetch and extract the toolchain from Aboriginal Linux. This can build static binaries.
WORKDIR /tmp
RUN curl -f -O http://landley.net/aboriginal/downloads/old/binaries/1.3.0/cross-compiler-x86_64.tar.bz2
RUN echo '1587ea6d018e419b7fd31b738fa7c1db1af97ff7  cross-compiler-x86_64.tar.bz2' | sha1sum -c
RUN tar xf cross-compiler-x86_64.tar.bz2 -C /usr/local/ && rm cross-compiler-x86_64.tar.bz2
ENV PATH /usr/local/cross-compiler-x86_64/bin:$PATH

# Fetch and build djpeg.
RUN curl -f -O -L https://storage.googleapis.com/camlistore-release/djpeg/libjpeg-turbo-1.4.1.tar.gz
RUN echo '363a149f644211462c45138a19674f38100036d3  libjpeg-turbo-1.4.1.tar.gz' | sha1sum -c
RUN mkdir /src
RUN tar xf libjpeg-turbo-1.4.1.tar.gz -C /src && rm libjpeg-turbo-1.4.1.tar.gz
WORKDIR /src/libjpeg-turbo-1.4.1
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CXX=x86_64-c++ CC=x86_64-gcc LDFLAGS="-static"
RUN make LDFLAGS="-all-static"
