# A version of `Dockerfile.build.cachepot-dist` that skips the build stage and
# instead copies over the locally pre-built `cachepot-dist` binary.
# TODO: Switch to BuildKit with Docker/Compose support when available, which
# allows us to unify these into a single Dockerfile
FROM ubuntu:20.04 as bwrap-build
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget xz-utils gcc libcap-dev make && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O - https://github.com/projectatomic/bubblewrap/releases/download/v0.3.1/bubblewrap-0.3.1.tar.xz | \
    tar -xJ
RUN cd /bubblewrap-0.3.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-man && \
    make

FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends libcap2 libssl1.1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=bwrap-build /bubblewrap-0.3.1/bwrap /usr/bin/bwrap
ADD cachepot-dist /usr/bin/cachepot-dist
CMD [ "cachepot-dist" ]
