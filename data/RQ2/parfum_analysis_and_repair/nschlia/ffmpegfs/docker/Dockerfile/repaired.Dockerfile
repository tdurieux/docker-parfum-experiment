FROM debian as common

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -yq apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq fuse libfuse2 libsqlite3-0 libavcodec58 libavformat58 libswresample3 libavutil56 libswscale5 libavfilter7 libcue2 libchardet1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq libdvdread[48] libdvdnav4 libbluray2 && rm -rf /var/lib/apt/lists/*;

FROM common as builder

RUN apt-get install --no-install-recommends -yq gcc g++ make pkg-config autoconf asciidoc-base w3m libchromaprint-dev bc doxygen graphviz curl git xxd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq libcue-dev libfuse-dev libsqlite3-dev libavcodec-dev libavformat-dev libswresample-dev libavutil-dev libswscale-dev libavfilter-dev libchardet-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq libdvdread-dev libdvdnav-dev libbluray-dev && rm -rf /var/lib/apt/lists/*;

ARG BRANCH=master
# Ensure that we get a docker image cache invalidation when there's new content available
ADD https://api.github.com/repos/nschlia/ffmpegfs/compare/${BRANCH}...HEAD /dev/null

RUN git clone https://github.com/nschlia/ffmpegfs.git -b ${BRANCH}
WORKDIR ffmpegfs

RUN chmod +x autogen.sh src/makehelp.sh
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make -s
RUN make -s install

FROM common

COPY --from=builder /usr/local/bin/ffmpegfs /usr/local/bin/ffmpegfs
COPY --from=builder /usr/local/share/man/man1/ffmpegfs.1 /usr/local/share/man/man1/ffmpegfs.1

ENTRYPOINT ["/usr/local/bin/ffmpegfs", "/src", "/dst"]
CMD = --help
