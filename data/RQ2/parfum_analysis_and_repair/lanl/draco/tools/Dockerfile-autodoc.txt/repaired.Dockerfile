# -*- Dockerfile -*-
FROM kinetictheory/draco-ci-2020nov:spack-spack-gcc

# Use ubuntu if building from scratch
# FROM ubuntu:20.04

# This image:
# 1. cd /D c:\work\docker (copy Dockerfile and packages.yaml to this location).
# 2. docker login -u kinetictheory (and password) # ref https://docs.docker.com/get-started/part2/
# 3. docker build -f Dockerfile-autodoc.txt --rm --pull --tag draco-ci-2020nov:autodoc .
# 4. docker image ls -a ==> find container name (or docker ps)
# 5. docker run -it -v /c/work:/work <image hash> /bin/bash -l
# 6. docerk ps -a ==> find NAME (eg. brave_shamir)
# 7. docker commit -m "added doxygen and TPLs" brave_shamir kinetictheory/draco-ci-2020nov:autodoc # queues for upload
# 8. docker push kinetictheory/draco-ci-2020nov:autodoc
# 9. docker system prune -a (remove old dangling data)

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

## APT-GET ---------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y --no-install-recommends ghostscript graphviz python3-sphinx python3-sphinx-rtd-theme texlive && \
    apt-get autoremove && rm -rf /var/lib/apt/lists/*

## SPACK -----------------------------------------------------------------------------

RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && spack external find
RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && \
    if test $(spack find mscgen | grep -c mscgen) -lt 2 ; then \
      for p in ${DRACO_DOC_TPL}; do \
        spack install -n ${p} %gcc; \
      done; \
      spack clean -a; \
    fi

# image run hook: the -l will make sure /etc/profile.d/*.sh environments are loaded