ARG REGISTRY
ARG CODE_VERSION
FROM ${REGISTRY}/lib_base:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

COPY ./ /clipper

RUN cd /clipper/src/libs/spdlog \
    && git apply ../patches/make_spdlog_compile_linux.patch \
    && cd /clipper/src/libs/redox \
    && git apply ../patches/redis_keepalive.patch \
    && cd /clipper \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --cleanup-quiet \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --release \
    && cd release \
    && make -j4 query_frontend

COPY containers/query_frontend/query_frontend_entry.sh /clipper/

WORKDIR /clipper/

ENTRYPOINT ["/clipper/query_frontend_entry.sh"]

# vim: set filetype=dockerfile:
