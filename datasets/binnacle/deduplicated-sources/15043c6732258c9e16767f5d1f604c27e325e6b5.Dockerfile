FROM peridigm/trilinos 
MAINTAINER John Foster <johntfosterjr@gmail.com>

ENV HOME /root

WORKDIR /

RUN apt-get -yq update
RUN apt-get -yq install openmpi-bin
RUN apt-get -yq install openssh-server

#Build Peridigm
RUN mkdir peridigm
WORKDIR /peridigm
ADD src src
ADD test test
ADD scripts scripts
ADD examples examples 
ADD CMakeLists.txt .
RUN mkdir /peridigm/build

WORKDIR /peridigm/build/
RUN cmake \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:PATH=/usr/local/peridigm \
    -D CMAKE_CXX_FLAGS:STRING="-std=c++11 -O2" \
    -D TRILINOS_DIR:PATH=/usr/local/trilinos \
    -D CMAKE_CXX_COMPILER:STRING="mpicxx" \
    -D USE_DAKOTA:BOOL=OFF \
    ..; \
    make && make install; \
    cd ..; \
    rm -rf peridigm

VOLUME /output
WORKDIR /output
ENV LD_LIBRARY_PATH /usr/local/netcdf/lib
ENV PATH /usr/local/peridigm/bin:$PATH
ENV PATH /usr/local/trilinos/bin:$PATH

RUN mkdir /var/run/sshd
EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
