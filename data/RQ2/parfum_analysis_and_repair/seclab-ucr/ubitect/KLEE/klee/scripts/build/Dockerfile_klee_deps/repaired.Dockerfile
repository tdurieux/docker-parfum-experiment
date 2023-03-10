# Build KLEE dependencies except LLVM and solvers
ARG REPOSITORY
ARG LLVM_VERSION_SHORT
ARG LLVM_SUFFIX
ARG SOLVER_SUFFIX
FROM ${REPOSITORY}/solver:${LLVM_VERSION_SHORT}${LLVM_SUFFIX}${SOLVER_SUFFIX}
LABEL maintainer="Martin Nowack <m.nowack@imperial.ac.uk>"

# Define all variables that can be changed as argument to the docker build
ARG BASE=/tmp
ARG DISABLE_ASSERTIONS
ARG ENABLE_OPTIMIZED
ARG ENABLE_DEBUG
ARG KEEP_BUILD
ARG KEEP_SRC
ARG KLEE_TRAVIS_BUILD
ARG KLEE_UCLIBC
ARG LLVM_VERSION
ARG LLVM_SUFFIX
ARG REQUIRES_RTTI
ARG SANITIZER_BUILD
ARG TRAVIS_OS_NAME
ARG USE_TCMALLOC

ENV DOCKER_BUILD=1

# Copy across source files needed for build
ADD /scripts/build/* scripts/build/

# Build KLEE (use TravisCI script)