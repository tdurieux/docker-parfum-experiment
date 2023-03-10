FROM almalinux/almalinux:8

RUN dnf upgrade -y && \
    dnf install -y glibc-langpack-en
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y epel-release
RUN dnf install -y \
        bzip2 curl file gcc-c++ gcc git gnupg2 gzip \
        make patch tcl unzip which xz patchelf diffutils tar Lmod \
        python3 python3-pip
RUN dnf clean all

RUN git clone https://github.com/spack/spack.git /opt/spack
COPY packages.yaml.base /etc/spack/packages.yaml
COPY modules.yaml /etc/spack/modules.yaml

RUN . /opt/spack/share/spack/setup-env.sh && \
    spack compiler find --scope system && \
    spack spec zlib && \
    spack clean -a && \
    spack spec zlib