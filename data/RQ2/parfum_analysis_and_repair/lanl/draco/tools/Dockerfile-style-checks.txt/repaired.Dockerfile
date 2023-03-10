# -*-Dockerfile-*-
FROM kinetictheory/draco-ci-2020nov:spack-common-tools

# Use ubuntu if building from scratch
# FROM ubuntu:20.04

# This image:
# 1. cd /D c:\work\docker (copy Dockerfile and packages.yaml to this location).
# 2. docker login -u kinetictheory (and password) # ref https://docs.docker.com/get-started/part2/
# 3. docker build -f Dockerfile-style-checks.txt --rm --pull --tag draco-ci-2020nov:style-checks .
#    OR: docker run -it -v /c/work:/work kinetictheory/draco-ci-2020nov /bin/bash -l
#        apt-get install -y --no-install-recommends [ghostview]
#        rm -rf /vendors/spack/var/spack/repos/builtin/cmake
#        cp -r /work/kinetictheory/spack/var/spack/repos/builtin/cmake /vendors/spack/var/spack/repos/builtin/.
#        spack install cmake@3.17.0
#        exit
#        docker ps -a
#        docker commit -m "added cmake-3.17.0." kind_grothen kinetictheory/draco-ci-2020nov:style-checks
#        docker push kinetictheory/draco-ci-2020nov:style-checks
# 4. docker image ls -a ==> find container name (or docker ps)
# 5. docker run -it -v /c/work:/work <image hash> /bin/bash -l
# 6. docker commit -m "added clang-format-10 and emacs" blissful_lumiere kinetictheory/draco-ci-2020nov:style-checks # queues for upload
# 7. docker push kinetictheory/draco-ci-2020nov:style-checks
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
ENV CLANG_FORMAT_VER=10
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

## APT-GET -----------------------------------------------------------------------------

# 1. Install gpg-agent
# 2. LLVM tools like clang, clang-tidy, and clang-format, https://apt.llvm.org/
# 3. Install emacs
# 4. Autoremove apt-get cache
RUN apt-get update && apt-get install -y --no-install-recommends gpg-agent; \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - ; \
    apt-get install -y --no-install-recommends clang-format-${CLANG_FORMAT_VER}; \
    ln -s /usr/bin/clang-format-${CLANG_FORMAT_VER} /usr/bin/clang-format; \
    apt-get install -y --no-install-recommends emacs; \
    apt-get autoremove && rm -rf /var/lib/apt/lists/*

# image run hook: the -l will make sure /etc/profile.d/*.sh environments are loaded