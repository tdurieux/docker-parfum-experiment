FROM ornladios/adios2:ci-spack-el8-base

# Install the compilers from an external repo
COPY oneAPI.repo /etc/yum.repos.d/
RUN dnf install -y \
        intel-oneapi-compiler-dpcpp-cpp \
        intel-oneapi-compiler-fortran && \
    dnf clean all

# Setup module files for the compilers
RUN /opt/intel/oneapi/modulefiles-setup.sh \
      --force \
      --output-dir=/usr/share/modulefiles