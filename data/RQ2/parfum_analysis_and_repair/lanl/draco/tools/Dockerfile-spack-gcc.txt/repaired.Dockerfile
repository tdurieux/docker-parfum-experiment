# -*- Dockerfile -*-
FROM kinetictheory/draco-ci-2020nov:spack-common-tools

# Use ubuntu if building from scratch
# FROM ubuntu:20.04

# This image:
# 1. cd /D c:\work\docker (copy Dockerfile and packages.yaml to this location).
# 2. docker login -u kinetictheory (and password) # ref https://docs.docker.com/get-started/part2/
# 3. docker build -f Dockerfile-spack-gcc.txt --rm --pull --tag draco-ci-2020nov:spack-gcc .
# 4. docker image ls -a ==> find container name (or docker ps)
# 5. docker run -it -v /c/work:/work <image hash> /bin/bash -l
# 6. docker commit -m "added gcc TPLs" interesting_chaplygin kinetictheory/draco-ci-2020nov:spack-gcc # queues for upload
# 7. docker push kinetictheory/draco-ci-2020nov:spack-gcc
# 8. docker system prune -a (remove old dangling data)

# See draco/.travis-run-tests.sh for some instructions.

## Environment needed by 'docker build' ----------------------------------------

## for apt to be noninteractive
## https://stackoverflow.com/questions/8671308/non-interactive-method-for-dpkg-reconfigure-tzdata
## https://spack.readthedocs.io/en/latest/workflows.html?highlight=docker
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV SPACK_ROOT=/vendors/spack
ENV DRACO_TPL="cmake numdiff random123 eospac@6.4.0"
ENV DRACO_DOC_TPL="mscgen doxygen"
ENV DRACO_GCC_TPL="gsl openmpi openblas metis parmetis libquo caliper lcov"
ENV DRACO_LLVM_TPL="gsl openmpi openblas metis parmetis libquo caliper"
ENV FORCE_UNSAFE_CONFIGURE=1
ENV DISTRO=focal
ENV CLANG_FORMAT_VER=10.0
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

## SPACK -----------------------------------------------------------------------------

RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && \
    if test $(spack find lcov | grep -c lcov) -lt 2 ; then \
      for p in ${DRACO_GCC_TPL}; do \
        spack install -n ${p} %gcc; \
      done; \
      spack clean -a; \
    fi

# image run hook: the -l will make sure /etc/profile.d/*.sh environments are loaded