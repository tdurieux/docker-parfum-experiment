ARG CODE_VERSION
FROM clipper/dev:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN pip install --no-cache-dir awscli==1.14.*

COPY ./ /clipper

# Patch Clipper
RUN cd /clipper/src/libs/spdlog \
    && git apply ../patches/make_spdlog_compile_linux.patch

RUN pip install --no-cache-dir -e /clipper/clipper_admin

ENTRYPOINT ["/clipper/bin/ci_checks.sh", "true"]

# vim: set filetype=dockerfile:
