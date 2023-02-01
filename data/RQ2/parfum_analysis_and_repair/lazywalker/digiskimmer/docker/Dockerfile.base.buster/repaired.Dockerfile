FROM debian:buster-slim as builder

LABEL maintainer="Michael BD7MQB <bd7mqb@qq.com>"

ARG APT=
RUN if [ "${APT}" != "" ] ; then \
    sed -i "s/deb.debian.org/${APT}/g" /etc/apt/sources.list && \
    sed -i "s/security.debian.org/${APT}/g" /etc/apt/sources.list \
    ; fi

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
    git cmake make gcc g++ patch patchelf \
    gfortran asciidoc asciidoctor texinfo qtmultimedia5-dev qttools5-dev qttools5-dev-tools \
    libusb-1.0.0-dev libfftw3-dev libhamlib-dev libqt5serialport5-dev && rm -rf /var/lib/apt/lists/*;

ARG WSJT_DIR=wsjtx-2.2.2
ADD "http://physics.princeton.edu/pulsar/k1jt/${WSJT_DIR}.tgz" /tmp/
COPY docker/patch/*.patch /tmp/
RUN cd /tmp && \
    tar xfz ${WSJT_DIR}.tgz && \
    patch -Np0 -d ${WSJT_DIR} < /tmp/wsjtx-hamlib.patch && \
    mv /tmp/wsjtx.patch ${WSJT_DIR} && \
    cd ${WSJT_DIR} && \
    export MAKEFLAGS="-j4" && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && rm ${WSJT_DIR}.tgz

RUN patchelf \
    --remove-needed libQt5Sql.so.5 \
    --remove-needed libQt5Gui.so.5 \
    --remove-needed libQt5Widgets.so.5 \
    --remove-needed libQt5PrintSupport.so.5 \
    --remove-needed libQt5Network.so.5 \
    /usr/local/bin/jt9

FROM debian:buster-slim

ARG APT=
RUN if [ "${APT}" != "" ] ; then \
    sed -i "s/deb.debian.org/${APT}/g" /etc/apt/sources.list && \
    sed -i "s/security.debian.org/${APT}/g" /etc/apt/sources.list \
    ; fi

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libfftw3-bin libqt5core5a \
    python3 python3-numpy python3-requests && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /usr/local/bin/jt9 /usr/local/bin/
COPY --from=builder /usr/local/bin/wsprd /usr/local/bin/
