ARG REGISTRY
ARG CODE_VERSION
FROM ${REGISTRY}/dev:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN pip install --no-cache-dir -q awscli==1.14.*

COPY ./ /clipper

# Set version as git hash
RUN cd /clipper && echo ${CODE_VERSION} > VERSION

RUN pip install --no-cache-dir -q -e /clipper/clipper_admin

RUN cd /clipper/src/libs/spdlog \
    && git apply ../patches/make_spdlog_compile_linux.patch \
    && cd /clipper/src/libs/redox \
    && git apply ../patches/redis_keepalive.patch \
    && cd /clipper \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && cd debug \
    && make -j all unittests

ENTRYPOINT ["/bin/bash", "-c"]

# vim: set filetype=dockerfile:
