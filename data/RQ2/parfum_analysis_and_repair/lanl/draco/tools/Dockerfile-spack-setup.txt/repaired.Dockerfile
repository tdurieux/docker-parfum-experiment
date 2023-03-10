# -*-Dockerfile-*-
FROM kinetictheory/draco-ci-2020nov:codecov

# Use ubuntu if building from scratch
# FROM ubuntu:20.04

# This image:
# 1. cd /D c:\work\docker (copy Dockerfile and packages.yaml to this location).
# 2. docker login -u kinetictheory (and password) # ref https://docs.docker.com/get-started/part2/
# 3. docker build -f Dockerfile-spack-setup.txt --rm --pull --tag draco-ci-2020nov:spack-setup .
# 4. docker image ls -a ==> find container name (or docker ps)
# 5. docker run -it -v /c/work:/work <image hash> /bin/bash -l
# 6. docker commit -m "added sphinx and mscgen"  nice_chatterjee kinetictheory/draco-ci-2020nov:spack-setup # queues for upload
# 7. docker push kinetictheory/draco-ci-2020nov:spack-setup
# 8. docker system prune -a (remove old dangling data)

# See draco/.travis-run-tests.sh for some instructions.

## Environment needed by 'docker build' ----------------------------------------

## for apt to be noninteractive
## https://stackoverflow.com/questions/8671308/non-interactive-method-for-dpkg-reconfigure-tzdata
## https://spack.readthedocs.io/en/latest/workflows.html?highlight=docker
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV SPACK_ROOT=/vendors/spack
ENV DRACO_TPL="cmake numdiff random123 mscgen lcov doxygen eospac@6.4.0"
ENV DRACO_GCC_TPL="gsl openmpi openblas metis parmetis libquo caliper"
ENV DRACO_LLVM_TPL="gsl openmpi openblas metis parmetis libquo caliper"
ENV FORCE_UNSAFE_CONFIGURE=1
ENV DISTRO=focal
ENV CLANG_FORMAT_VER=10.0
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

## SPACK -----------------------------------------------------------------------------

# install/setup spack. Only download spack if it doesn't already exist.
RUN mkdir -p $SPACK_ROOT/etc/spack/linux
RUN if ! test -d $SPACK_ROOT/opt/spack ; then \
      curl -f -s -L https://api.github.com/repos/spack/spack/tarball | tar xzC $SPACK_ROOT --strip 1; \
    fi

# metis/parmetis downloads are broken right now, use a mirror.
#COPY mirrors.yaml $SPACK_ROOT/etc/spack
COPY modules.yaml $SPACK_ROOT/etc/spack
#RUN mkdir -p $SPACK_ROOT/spack.mirror/metis
#RUN mkdir -p $SPACK_ROOT/spack.mirror/parmetis
#COPY metis-5.1.0.tar.gz $SPACK_ROOT/spack.mirror/metis
#COPY parmetis-4.0.3.tar.gz $SPACK_ROOT/spack.mirror/parmetis

RUN if ! test -f /etc/profile.d/spack.sh; then \
      echo "source $SPACK_ROOT/share/spack/setup-env.sh" > /etc/profile.d/spack.sh; \
    fi
RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && spack compiler add
RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && spack external find

RUN . "$SPACK_ROOT/share/spack/setup-env.sh" && \
    if test $(spack find lmod | grep -c lmod) -lt 2 ; then \
      spack install lmod; \
      echo "source `spack location -i lmod`/lmod/lmod/init/bash" >> /etc/profile.d/spack.sh; \
      core_loc=$(/usr/bin/ls -d $SPACK_ROOT/share/spack/lmod/*/Core); \
      echo "module use ${core_loc}" >> /etc/profile.d/spack.sh; \
      spack clean -a; \
    fi

# image run hook: the -l will make sure /etc/profile.d/*.sh environments are loaded
CMD /bin/bash -l
