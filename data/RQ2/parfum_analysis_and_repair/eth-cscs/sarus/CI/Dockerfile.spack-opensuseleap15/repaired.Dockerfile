FROM spack/leap15:latest

# Install packages required by Spack
# glibc-devel-static is required for building the SSH hook's custom OpenSSH software
RUN zypper install -y glibc-devel-static \
    && zypper clean --all

# Install builtin dependencies for Sarus
#ENV FORCE_UNSAFE_CONFIGURE=1
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