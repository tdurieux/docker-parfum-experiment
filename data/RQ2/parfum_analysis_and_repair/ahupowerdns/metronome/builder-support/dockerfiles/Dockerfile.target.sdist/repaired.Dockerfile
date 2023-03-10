FROM alpine:3.10 as metronome

ARG BUILDER_CACHE_BUSTER=
RUN apk add --no-cache gcc g++ make tar autoconf automake eigen-dev file bash libtool pkgconfig boost-dev

ADD README.md LICENSE metronome.service.in metronome-upstart.conf configure.ac Makefile.am interpolate.cc iputils.cc mdump.cc metronome.cc mmanage.cc msubmit.cc statstorage.cc testrunner.cc test-statstorage.cc dolog.hh interpolate.hh iputils.hh metromisc.hh statstorage.hh /metronome/
@EXEC sdist_dirs=(m4 ahutils examples html yahttp)
@EXEC for d in ${sdist_dirs[@]} ; do echo "COPY $d/ /metronome/$d/" ; done
ADD builder/helpers/set-configure-ac-version.sh /metronome/builder/helpers/

WORKDIR /metronome
RUN mkdir /sdist

ARG BUILDER_VERSION
RUN /metronome/builder/helpers/set-configure-ac-version.sh && \
     autoreconf -v -i --force && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-eigen=/usr/include/eigen3 --disable-dependency-tracking && \
    make dist
RUN cp metronome-${BUILDER_VERSION}.tar.bz2 /sdist/

FROM alpine:3.10 as sdist
ARG BUILDER_CACHE_BUSTER=
COPY --from=metronome /sdist/ /sdist/
