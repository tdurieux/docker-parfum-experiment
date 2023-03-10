FROM debian

ENV VERSION=0.6.2

RUN echo "installing dependencies" && apt-get update \
        && apt-get install --no-install-recommends -y build-essential libcurl4-openssl-dev cmake pkg-config libasound2-dev \
        && apt-get -y --no-install-recommends install libssl-dev git libjansson-dev \
        && ldconfig && rm -rf /var/lib/apt/lists/*;

RUN echo "cloning VoIP Perf" \
        && git clone https://github.com/jchavanton/voip_perf.git \
        && cd voip_perf \
        && git checkout ${VERSION} \
        && git submodule update --init

RUN echo "building (configure) PJLIB" && cd voip_perf \
        && cp include/config_site.h pjproject/pjlib/include/pj/config_site.h \
        && cd pjproject && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-libwebrtc

RUN echo "building (make) PJLIB .." && cd voip_perf \
        && cd pjproject && make dep && make && make install

RUN echo "building VoIP Perf" && cd voip_perf \
        && cmake CMakeLists.txt \
        && make

COPY entry.sh /
ENTRYPOINT ["/entry.sh"]
