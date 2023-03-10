FROM peridigm/trilinos
LABEL maintainer="John Foster <johntfosterjr@gmail.com>"

ENV HOME /root

WORKDIR /

#Build Peridigm
RUN mkdir peridigm
WORKDIR /peridigm
ADD src src
ADD test test
ADD scripts scripts
ADD examples examples
ADD CMakeLists.txt .
RUN mkdir /peridigm/build

ENV OMPI_ALLOW_RUN_AS_ROOT 1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1
WORKDIR /peridigm/build/
RUN apt-get install -y --no-install-recommends python-is-python3 && rm -rf /var/lib/apt/lists/*;
RUN cmake \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:PATH=/usr/local/peridigm \
    -D TRILINOS_DIR:PATH=/usr/local/trilinos \
    -D CMAKE_CXX_COMPILER:STRING="mpicxx" \
    ..; \
    make && make test
