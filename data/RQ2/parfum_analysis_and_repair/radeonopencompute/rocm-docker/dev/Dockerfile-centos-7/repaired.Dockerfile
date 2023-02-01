FROM centos:7
LABEL maintainer=peng.sun@amd.com

ARG ROCM_VERSION=4.5.2
ARG AMDGPU_VERSION=21.40.2
# Base
RUN yum -y install git java-1.8.0-openjdk python; rm -rf /var/cache/yum yum clean all

# Enable epel-release repositories
RUN yum --enablerepo=extras install -y epel-release && rm -rf /var/cache/yum

# Install required base build and packaging commands for ROCm
RUN yum -y install \
    ca-certificates \
    bc \
    bridge-utils \
    cmake \
    cmake3 \
    devscripts \
    dkms \
    doxygen \
    dpkg \
    dpkg-dev \
    dpkg-perl \
    elfutils-libelf-devel \
    expect \
    file \
    python3 \
    python3-pip \
    gettext \
    gcc-c++ \
    libgcc \
    glibc.i686 \
    libcxx-devel \
    ncurses \
    ncurses-base \
    ncurses-libs \
    numactl-devel \
    numactl-libs \
    libssh \
    libunwind-devel \
    libunwind \
    llvm \
    llvm-libs \
    make \
    openssl \
    openssl-libs \
    openssh \
    openssh-clients \
    pciutils \
    pciutils-devel \
    pciutils-libs \
    python \
    python-pip \
    python-devel \
    pkgconfig \
    pth \
    qemu-kvm \
    re2c \
    kmod \
    file \
    rpm \
    rpm-build \
    subversion \
    wget && rm -rf /var/cache/yum

# Enable the epel repository for fakeroot
RUN yum --enablerepo=extras install -y fakeroot && rm -rf /var/cache/yum
RUN yum clean all

# On CentOS, install package centos-release-scl available in CentOS repository:
RUN yum install -y centos-release-scl && rm -rf /var/cache/yum

# Install the devtoolset-7 collection:
RUN yum install -y devtoolset-7 && rm -rf /var/cache/yum
RUN yum install -y devtoolset-7-libatomic-devel devtoolset-7-elfutils-libelf-devel && rm -rf /var/cache/yum

# Install the ROCm rpms
RUN yum clean all
RUN echo -e "[ROCm]\nname=ROCm\nbaseurl=https://repo.radeon.com/rocm/yum/$ROCM_VERSION/main\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/rocm.repo
RUN echo -e "[amdgpu]\nname=amdgpu\nbaseurl=https://repo.radeon.com/amdgpu/$AMDGPU_VERSION/rhel/7.9/main/x86_64\nenabled=1\ngpgcheck=0" >> /etc/yum.repos.d/amdgpu.repo

RUN yum install -y rocm-dev && rm -rf /var/cache/yum

# Set ENV to enable devtoolset7 by default
ENV PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin:/opt/rocm/bin:/opt/rocm/hcc/bin:${PATH:+:${PATH}}
ENV MANPATH=/opt/rh/devtoolset-7/root/usr/share/man:${MANPATH}
ENV INFOPATH=/opt/rh/devtoolset-7/root/usr/share/info${INFOPATH:+:${INFOPATH}}
ENV PCP_DIR=/opt/rh/devtoolset-7/root
ENV PERL5LIB=/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/
ENV LD_LIBRARY_PATH=/opt/rocm/lib:/usr/local/lib:/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV PYTHONPATH=/opt/rh/devtoolset-7/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-7/root/usr/lib/python$pythonvers/
ENV LDFLAGS="-Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib"
