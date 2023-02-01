ARG CODE_VERSION
FROM clipper/lib_base:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

COPY ./ /clipper

RUN cd /clipper/src/libs/spdlog \
    && git apply ../patches/make_spdlog_compile_linux.patch \
    && cd /clipper \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --cleanup-quiet \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --release \
    && cd release \
    && make -j4 query_frontend

ENTRYPOINT ["/clipper/release/src/frontends/query_frontend"]

# vim: set filetype=dockerfile:
