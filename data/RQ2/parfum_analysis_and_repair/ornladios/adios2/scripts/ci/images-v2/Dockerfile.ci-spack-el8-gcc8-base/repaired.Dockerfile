FROM ornladios/adios2:ci-spack-el8-base

# Install the gcc fortran compiler missing from the base image
RUN dnf install -y gcc-gfortran && \
    dnf clean all

# Add the compilers to spack
RUN . /opt/spack/share/spack/setup-env.sh && \
    spack compiler rm --scope system gcc && \
    spack compiler add --scope system && \
    spack config --scope system add "packages:all:compiler:[gcc]"