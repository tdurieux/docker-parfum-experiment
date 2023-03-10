FROM ghcr.io/moja-global/flint.core:master

WORKDIR $ROOTDIR/src

# moja.canada requires libpqxx.
RUN git clone --recursive https://github.com/jtv/libpqxx.git \
    && mkdir libpqxx/build \
    && cd libpqxx/build \
    && cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
            -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DSKIP_BUILD_TEST=ON \
            -FSKIP_PQXX_STATIC=ON .. \
            -DCMAKE_CXX_FLAGS=-fPIC \
            -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql \
    && make --quiet -j $NUM_CPU install/strip \
    && make clean \
    && cd $ROOTDIR/src

# moja.canada
RUN git clone -b develop https://github.com/moja-global/moja.canada \
    && mkdir -p moja.canada/Source/build \
    && cd moja.canada/Source/build \
    && cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
            -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
            -DENABLE_TESTS:BOOL=OFF \
            -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql .. \
    && make --quiet -s -j $NUM_CPU \
    && make --quiet install \
    && make clean \
    && cd $ROOTDIR/src

RUN mkdir -p /opt/gcbm
RUN ln -t /opt/gcbm /usr/local/lib/lib*
RUN ln -t /opt/gcbm /usr/local/bin/moja.cli