FROM ornladios/adios2:ci-spack-el8-intel-base

# Install the compilers from an external repo
RUN dnf install -y \
        intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic && \
    dnf clean all

# Enable the classic intel compiler
RUN . /opt/spack/share/spack/setup-env.sh && \
    spack compiler add --scope system \
      /opt/intel/oneapi/compiler/latest/linux/bin/intel64 && \
    sed '15,100 s|modules: \[\]|modules: \[icc\]|' \
      -i /etc/spack/compilers.yaml && \
    spack config --scope=system add 'packages:all:compiler: [intel, gcc]'