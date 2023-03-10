# -*- Dockerfile -*-
FROM kinetictheory/draco-ci-2020nov:spack-common-tools

# Use ubuntu if building from scratch
# FROM ubuntu:20.04

# This image:
# 1. cd /D c:\work\docker (copy Dockerfile and packages.yaml to this location).
# 2. docker login -u kinetictheory (and password) # ref https://docs.docker.com/get-started/part2/
# 3. docker build -f Dockerfile-spack-llvm.txt --rm --pull --tag draco-ci-2020nov:spack-llvm .
# 4. docker image ls -a ==> find container name (or docker ps)
# 5. docker run -it -v /c/work:/work <image hash> /bin/bash -l
# 6. docker commit -m "added llvm TPLs" competent_curie kinetictheory/draco-ci-2020nov:spack-llvm # queues for upload
# 7. docker push kinetictheory/draco-ci-2020nov:spack-llvm
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
ENV DRACO_LLVM_TPL="gsl openmpi openblas metis parmetis libquo"
# caliper - trouble building caliper with llvm@11.0.0
ENV FORCE_UNSAFE_CONFIGURE=1
ENV DISTRO=focal
ENV CLANG_FORMAT_VER=10.0
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

## SPACK -----------------------------------------------------------------------------

## Provide LLVM compiler and associated tools
RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && \
    spack compiler list && \
    if test $(spack compiler list | grep -c clang) -lt 2 ; then \
      spack install -j 4 llvm; \
      spack clean -a; \
      llvm_loc=$(spack location -i llvm); \
      llvm_tag=$(spack find --no-groups llvm | sed -e 's/llvm/clang/');\
      echo "- compiler:" >> $HOME/.spack/linux/compilers.yaml; \
      echo "    spec: ${llvm_tag}" >> $HOME/.spack/linux/compilers.yaml; \
      echo "    paths:" >> $HOME/.spack/linux/compilers.yaml; \
      echo "      cc: ${llvm_loc}/bin/clang" >> $HOME/.spack/linux/compilers.yaml; \
      echo "      cxx: ${llvm_loc}/bin/clang++" >> $HOME/.spack/linux/compilers.yaml; \
      echo "      f77: /usr/bin/gfortran" >> $HOME/.spack/linux/compilers.yaml; \
      echo "      fc: /usr/bin/gfortran" >> $HOME/.spack/linux/compilers.yaml; \
      echo "    flags:" >> $HOME/.spack/linux/compilers.yaml; \
      echo "      cflags: -fPIC"  >> $HOME/.spack/linux/compilers.yaml; \
      echo "      cxxflags: -fPIC"  >> $HOME/.spack/linux/compilers.yaml; \
      echo "      fflags: -fPIC"  >> $HOME/.spack/linux/compilers.yaml; \
      echo "    operating_system: ubuntu20.04"  >> $HOME/.spack/linux/compilers.yaml; \
      echo "    target: x86_64"  >> $HOME/.spack/linux/compilers.yaml; \
      echo "    modules: []"  >> $HOME/.spack/linux/compilers.yaml; \
      echo "    environment: {}"  >> $HOME/.spack/linux/compilers.yaml; \
      echo "    extra_rpaths: []"  >> $HOME/.spack/linux/compilers.yaml; \
      spack config get compilers; \
    fi

RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && \
    if test $(spack find caliper | grep -c caliper) -lt 2 ; then \
      for p in ${DRACO_LLVM_TPL}; do \
        spack install -n ${p} %clang; \
      done; \
      spack clean -a; \
    fi

# image run hook: the -l will make sure /etc/profile.d/*.sh environments are loaded