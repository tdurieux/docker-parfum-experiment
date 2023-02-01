ARG PREFIX=kernelci/
FROM ${PREFIX}clang-base

RUN apt-get update && apt-get install --no-install-recommends -y \
    clang-11 lld-11 llvm-11 && rm -rf /var/lib/apt/lists/*;

ENV PATH=/usr/lib/llvm-11/bin:${PATH}
