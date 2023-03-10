# See packaging for various base options
FROM flatironinstitute/triqs:base
ARG APPNAME=triqs

COPY requirements.txt /src/$APPNAME/requirements.txt
RUN pip3 install --no-cache-dir -r /src/$APPNAME/requirements.txt

RUN useradd -u 990 -m build

ENV SRC=/src \
    BUILD=/home/build \
    INSTALL=/usr/local \
    PYTHONPATH=/usr/local/lib/python$PYTHON_VERSION/site-packages \
    CMAKE_PREFIX_PATH=/usr/lib/cmake/$APPNAME \
    OMP_NUM_THREADS=4

# Hacky patch for matplotlib sphinx bug (https://github.com/matplotlib/matplotlib/pull/12456?)
RUN ln -s /src /home/src

COPY --chown=build . $SRC/$APPNAME
WORKDIR $BUILD/$APPNAME
RUN chown build .
USER build
ARG BUILD_ID
ARG CMAKE_ARGS
RUN cmake $SRC/$APPNAME -DCMAKE_INSTALL_PREFIX=$INSTALL -DBuild_Deps=Always -DCLANG_OPT="$CXXFLAGS" $CMAKE_ARGS && make -j4 || make -j1 VERBOSE=1
USER root
RUN make install
