FROM ornladios/adios2:ci-spack-el8-intel-base

# Enable the classic intel compiler
RUN . /opt/spack/share/spack/setup-env.sh && \
    spack compiler add --scope system \
      /opt/intel/oneapi/compiler/latest/linux/bin && \
    sed '15,100 s|modules: \[\]|modules: \[compiler\]|' \
      -i /etc/spack/compilers.yaml && \
    spack config --scope=system add 'packages:all:compiler: [oneapi, gcc]'