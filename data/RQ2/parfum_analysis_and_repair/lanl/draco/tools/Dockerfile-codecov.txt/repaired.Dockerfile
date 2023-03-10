# -*-Dockerfile-*-
FROM kinetictheory/draco-ci-2020nov:basic

# This image:
# 1. cd /D c:\work\docker (copy Dockerfile and packages.yaml to this location).
# 2. docker login -u kinetictheory (and password) # ref https://docs.docker.com/get-started/part2/
# 3. docker build -f Dockerfile-codecov.txt --rm --pull --tag draco-ci-2020nov:codecov .
# 4. docker image ls -a ==> find container name (or docker ps)
# 5. docker run -it -v /c/work:/work <image hash> /bin/bash -l
# 6. docker commit -m "Adding python codecov" loving_agnesi kinetictheory/draco-ci-2020nov:codecov # queues for upload
# 7. docker push kinetictheory/draco-ci-2020nov:codecov
# 8. docker system prune -a (remove old dangling data)

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

## Add codecov python capability -------------------------------------------

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install codecov

# image run hook: the -l will make sure /etc/profile.d/*.sh environments are loaded