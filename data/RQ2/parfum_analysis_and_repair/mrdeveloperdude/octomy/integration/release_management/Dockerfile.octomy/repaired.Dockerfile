ARG oc_base
FROM "$oc_base"
ENV OC_DIR /root/octomy
WORKDIR $OC_DIR/src
RUN git clone https://github.com/mrdeveloperdude/OctoMY.git .
RUN cp pri/overrides/release.pri pri/local_overrides.pri
WORKDIR ../build
RUN env
RUN echo "PATH IS: $PATH"
RUN echo "QT_DIST IS: $QT_DIST"
RUN bash -c 'which qmake'
RUN bash -c 'qmake ../src/OctoMY.pro'
RUN bash -c 'make -j $(nproc)'
RUN find