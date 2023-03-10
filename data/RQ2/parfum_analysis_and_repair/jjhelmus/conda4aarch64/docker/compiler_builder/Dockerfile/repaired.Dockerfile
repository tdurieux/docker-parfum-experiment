FROM arm64v8/centos:7

# Set the locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# base packages
RUN yum install -y \
  file \
  libX11 \
  libXau \
  libxcb \
  libXdmcp \
  libXext \
  libXrender \
  libXt \
  mesa-libGL \
  mesa-libGLU \
  openssh-clients \
  patch \
  rsync \
  util-linux \
  wget \
  which \
  bzip2 \
  xorg-x11-server-Xvfb \
  && yum clean all && rm -rf /var/cache/yum

# ctng packages
RUN yum install -y \
    autoconf \
    gperf  \
    bison  \
    flex  \
    texinfo  \
    help2man  \
    gcc-c++  \
    patch \
	ncurses-devel  \
    python-devel  \
    perl-Thread-Queue  \
    bzip2  \
    git \
  && yum clean all && rm -rf /var/cache/yum

#crosstool-ng packages
RUN yum install -y \
    automake \
    libtool \
    make \
    unzip \
  && yum clean all && rm -rf /var/cache/yum

WORKDIR /build_scripts
COPY install_conda.sh /build_scripts
RUN ./install_conda.sh

ENV PATH="/opt/conda/bin:${PATH}"

CMD [ "/bin/bash" ]
