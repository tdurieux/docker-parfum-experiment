FROM ornladios/adios2:ci-spack-el8-base

# Install gcc from the dev-toolset packages
RUN dnf install -y gcc-toolset-9 && \
    dnf clean all

# Add the compilers to spack
COPY gcc-toolset-module.tcl /tmp/
RUN . /opt/spack/share/spack/setup-env.sh && \
    sed 's|TOOLSET|9|' /tmp/gcc-toolset-module.tcl > /usr/share/Modules/modulefiles/gcc-9 && \
    rm -f /tmp/gcc-toolset-module.tcl && \
    . /etc/profile.d/modules.sh && \
    module load gcc-9 && \
    spack compiler add --scope=system && \
    MODLINE=$(grep -n modules /etc/spack/compilers.yaml | cut -d : -f 1 | tail -1) && \
    sed "${MODLINE} s|modules:.*|modules: [gcc-9]|" -i \
      /etc/spack/compilers.yaml