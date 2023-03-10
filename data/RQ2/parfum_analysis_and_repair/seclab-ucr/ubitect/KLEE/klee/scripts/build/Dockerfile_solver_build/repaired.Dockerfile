ARG REPOSITORY
ARG LLVM_SUFFIX
ARG LLVM_VERSION_SHORT
FROM ${REPOSITORY}/llvm_built:${LLVM_VERSION_SHORT}${LLVM_SUFFIX}
LABEL maintainer="Martin Nowack <m.nowack@imperial.ac.uk>"

ENV DOCKER_BUILD=1

# Define all variables that can be changed as argument to docker build
ARG BASE=/tmp
ARG DISABLE_ASSERTIONS
ARG ENABLE_OPTIMIZED
ARG ENABLE_DEBUG
ARG KEEP_BUILD
ARG KEEP_SRC
ARG KLEE_TRAVIS_BUILD
ARG LLVM_VERSION
ARG METASMT_BOOST_VERSION
ARG METASMT_DEFAULT
ARG METASMT_VERSION
ARG REQUIRES_RTTI
ARG SOLVERS
ARG SANITIZER_BUILD
ARG STP_VERSION
ARG STORAGE_SPACE_OPTIMIZED=1
ARG TRAVIS_OS_NAME
ARG Z3_VERSION

WORKDIR $BASE

# Copy across source files needed for build
ADD /scripts/build/* scripts/build/
RUN scripts/build/solvers.sh