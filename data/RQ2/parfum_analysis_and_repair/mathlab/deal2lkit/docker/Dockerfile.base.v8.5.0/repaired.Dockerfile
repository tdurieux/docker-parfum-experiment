FROM dealii/dealii:v8.5.0-gcc-mpi-fulldepscandi-debugrelease

MAINTAINER luca.heltai@gmail.com

USER root

RUN apt-get update && apt-get -yq --no-install-recommends install \
    assimp-utils \
    libassimp-dev && rm -rf /var/lib/apt/lists/*;

USER $USER

#sundials
ENV SUNDIALS_VERSION 2.6.2
RUN wget https://github.com/luca-heltai/sundials/archive/v$SUNDIALS_VERSION.tar.gz &&\
    tar xf v$SUNDIALS_VERSION.tar.gz && rm -f v$SUNDIALS_VERSION.tar.gz && \
    cd sundials-$SUNDIALS_VERSION && \
    mkdir build && cd build && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=$HOME/libs/sundials-$SUNDIALS_VERSION \
        -DLAPACK_ENABLE=ON \
        -DMPI_ENABLE=ON .. && \
    make -j4 && make install && \
    cd $HOME && \
    rm -rf sundials-$SUNDIALS_VERSION
ENV SUNDIALS_DIR $HOME/libs/sundials-$SUNDIALS_VERSION
