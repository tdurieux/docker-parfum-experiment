FROM ghcr.io/moja-global/flint.base:master

WORKDIR $ROOTDIR/src

# hardcoded to develop
RUN git clone -b update-poco https://github.com/moja-global/FLINT.git flint \
    && mkdir -p flint/Source/build \
    && cd flint/Source/build \
    && cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE  \
            -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
            -DENABLE_TESTS:BOOL=OFF \
            -DENABLE_MOJA.MODULES.GDAL=ON \
            -DENABLE_MOJA.MODULES.ZIPPER=ON \
            -DENABLE_MOJA.MODULES.LIBPQ=ON \
            -DBoost_USE_STATIC_LIBS=OFF \
            -DBUILD_SHARED_LIBS=ON .. \
  	&& make --quiet -j $NUM_CPU \
  	&& make --quiet install \
    && cd $ROOTDIR/src

RUN ln -s $ROOTDIR/lib/libmoja.modules.* $ROOTDIR/bin
RUN rm -Rf $ROOTDIR/src/* \
    && ldconfig