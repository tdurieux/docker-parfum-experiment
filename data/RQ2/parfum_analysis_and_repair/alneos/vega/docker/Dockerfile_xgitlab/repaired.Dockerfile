FROM ldallolio/xvegaci

MAINTAINER Alter Ego Engineering <contact@aego.ai>

ENV VEGA_SOURCE=/opt/vega
ENV VEGA_BUILD=$VEGA_SOURCE/build
COPY .. $VEGA_SOURCE
WORKDIR $VEGA_BUILD
RUN $TARGET-cmake -DRUN_ASTER=OFF -DRUN_SYSTUS=OFF -DRUN_NASTRAN=OFF -DCMAKE_BUILD_TYPE=SDebug .. && make -j && ctest -VV .