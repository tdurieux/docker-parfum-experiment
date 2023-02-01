ARG BASE=debian:bullseye
FROM ${BASE}

# install debian packages:
ENV DEBIAN_FRONTEND=noninteractive
RUN set -e -x; \
    echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries; \
    apt-get update; \
    apt-get install -y --no-install-recommends \

        ca-certificates python3-yaml \

        cmake pkg-config make gcc g++ \

        curl lcov \

        clang clang-tidy clang-format \

        cppcheck iwyu \

        git \

        file dpkg-dev \

        util-linux && rm -rf /var/lib/apt/lists/*;

# ctest -D ExperimentalMemCheck; may not work in all architectures
RUN apt-get install -y --no-install-recommends valgrind || true && rm -rf /var/lib/apt/lists/*;

# setup su for dep installation
RUN sed -i '/pam_rootok.so$/aauth sufficient pam_permit.so' /etc/pam.d/su

ADD entrypoint /usr/local/bin/entrypoint
CMD ["/usr/local/bin/entrypoint"]
