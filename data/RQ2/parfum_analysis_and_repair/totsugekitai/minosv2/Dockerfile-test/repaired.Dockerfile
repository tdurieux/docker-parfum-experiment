FROM ubuntu:18.04

WORKDIR /minOSv2

RUN apt-get update && apt-get install --no-install-recommends -y \
    make \
    gcc-multilib \
    clang \
    lld \
    git && rm -rf /var/lib/apt/lists/*;

RUN mkdir common kernel tests && \
    git clone https://github.com/google/googletest.git tests/googletest && \
    cd tests/googletest && git checkout release-1.10.0

COPY common/ ./common/
COPY kernel/ ./kernel/
COPY tests/ ./tests/
COPY Makefile ./

RUN rm -rf tests/gtest/ && \
    python tests/googletest/googletest/scripts/fuse_gtest_files.py tests/ && \
    make -B test