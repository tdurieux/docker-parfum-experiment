# Build the final KLEE layer
ARG REPOSITORY
ARG LLVM_VERSION_SHORT
ARG LLVM_SUFFIX
ARG SOLVER_SUFFIX
ARG DEPS_SUFFIX
FROM ${REPOSITORY}/klee_deps:${LLVM_VERSION_SHORT}${LLVM_SUFFIX}${SOLVER_SUFFIX}${DEPS_SUFFIX}
LABEL maintainer="Martin Nowack <m.nowack@imperial.ac.uk>"

# Define all variables that can be changed as argument to the docker build
ARG BASE=/tmp
ARG COVERAGE=0
ARG DEPS_SUFFIX
ARG DISABLE_ASSERTIONS
ARG ENABLE_OPTIMIZED
ARG ENABLE_DEBUG
ARG KLEE_TRAVIS_BUILD
ARG KLEE_UCLIBC
ARG LLVM_VERSION
ARG LLVM_SUFFIX
ARG METASMT_BOOST_VERSION
ARG METASMT_DEFAULT
ARG METASMT_VERSION
ARG REQUIRES_RTTI
ARG SANITIZER_BUILD
ARG SANITIZER_SUFFIX
ARG SOLVER_SUFFIX
ARG SOLVERS
ARG STP_VERSION
ARG TRAVIS_OS_NAME
ARG USE_TCMALLOC
ARG Z3_VERSION

ENV DOCKER_BUILD=1

# Copy across source files needed for build
ADD / ${BASE}/klee_src

# TODO Remove when STP is fixed
RUN export LD_LIBRARY_PATH=${BASE}/metaSMT/deps/stp-git-basic/lib/ && export KLEE_SRC=${BASE}/klee_src && ${BASE}/klee_src/scripts/build/klee.sh && rm -rf ${BASE}/klee_src/.git && ln -s ${BASE}/klee_build* ${BASE}/klee_build

# Create ``klee`` user for container with password ``klee``.
# and give it password-less sudo access (temporarily so we can use the TravisCI scripts)
RUN useradd -m klee && \
    echo klee:klee | chpasswd && \
    cp /etc/sudoers /etc/sudoers.bak && \
    echo 'klee  ALL=(root) NOPASSWD: ALL' >> /etc/sudoers

# Set klee user to be owner
RUN chown --recursive klee: ${BASE}/klee_src

USER klee
WORKDIR /home/klee

# Add KLEE binary directory to PATH
RUN /bin/bash -c 'DIR="${BASE}/klee_src/scripts/build" source ${BASE}/klee_src/scripts/build/common-defaults.sh && ln -s ${BASE}/klee_src /home/klee/ && ln -s ${BASE}/klee_build /home/klee/ && echo "export PATH=\"$PATH:${LLVM_BIN}:/home/klee/klee_build/bin\"" >> /home/klee/.bashrc'
# TODO Remove when STP is fixed