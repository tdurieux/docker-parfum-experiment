FROM spack/ubuntu-bionic:latest

RUN apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --no-install-recommends pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install builtin dependencies for Sarus
RUN spack install wget
RUN spack install cmake
RUN spack install boost@1.65.0: cxxstd=11 +program_options +regex +filesystem
RUN spack install skopeo
RUN spack install umoci
RUN spack install runc@:1.0.3
RUN spack install tini
RUN spack install squashfs
RUN spack install python@3:

ENTRYPOINT []
CMD []