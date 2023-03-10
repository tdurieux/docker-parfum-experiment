FROM alpine
MAINTAINER Tobias Blomberg <sm0svx@svxlink.org>

# Install required packages and set up the svxlink user
RUN apk update
RUN apk add --no-cache git cmake make g++ pkgconfig libsigc++-dev alsa-lib-dev opus-dev \
            speex-dev popt-dev libgcrypt-dev tcl-dev curl-dev gsm-dev \
            linux-headers groff curl openssh

# For building librtlsdr
RUN apk add --no-cache automake autoconf libtool libusb-dev

# For debugging and development
ADD svxlink-sounds-en_US-heather-16k-18.03.1.tar.bz2 /usr/share/svxlink/sounds/
RUN apk add --no-cache vim gdb valgrind
RUN ln -s en_US-heather-16k /usr/share/svxlink/sounds/en_US

# Add a svxlink user for running the build
ARG HOME=/home/svxlink
RUN adduser -u 10000 -h ${HOME} -D svxlink
USER svxlink

# Build librtlsdr
ARG RTLSDR_REPO=git://git.osmocom.org/rtl-sdr.git
ARG RTLSDR_WORKDIR=${HOME}/rtl-sdr
ARG NUM_CORES=1
WORKDIR ${HOME}
RUN git clone ${RTLSDR_REPO} ${RTLSDR_WORKDIR}
#WORKDIR ${RTLSDR_WORKDIR}
#RUN autoreconf --force --install
#RUN ./configure --disable-shared
RUN mkdir -p ${RTLSDR_WORKDIR}/build
WORKDIR ${RTLSDR_WORKDIR}/build
RUN cmake -DDETACH_KERNEL_DRIVER=ON -Wno-dev ..
RUN make -j${NUM_CORES}
RUN rm src/librtlsdr.so

# Build SvxLink
WORKDIR ${HOME}
ARG GIT_REPO=https://github.com/sm0svx/svxlink.git
ARG GIT_REF=master
ARG GIT_SSL_NO_VERIFY=true
RUN git clone --branch ${GIT_REF} ${GIT_REPO}
#ADD find_librtlsdr.patch ${HOME}/
#RUN cd svxlink && patch -p1 < ${HOME}/find_librtlsdr.patch
RUN mkdir build
WORKDIR ${HOME}/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_SYSCONFDIR=/etc \
          -DCMAKE_INSTALL_LOCALSTATEDIR=/var -DUSE_QT=OFF \
          -DLIB_INSTALL_DIR=/lib -DDO_INSTALL_CHOWN=YES \
          -DRTLSDR_DIR=${RTLSDR_WORKDIR} -DDO_INSTALL_CHOWN=YES \
          ../svxlink/src
RUN make -j${NUM_CORES} all doc

# Create an archive for the whole installation
USER root
RUN make install DESTDIR=/tmp/svxlink
RUN tar cvzf /tmp/svxlink.tar.gz . -C /tmp/svxlink

# Add an entrypoint to use for debugging and development
ADD entrypoint /
ENTRYPOINT ["/entrypoint"]

# vim: set filetype=dockerfile:
