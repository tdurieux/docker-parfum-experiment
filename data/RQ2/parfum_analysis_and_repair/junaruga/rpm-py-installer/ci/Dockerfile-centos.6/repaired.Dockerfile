FROM centos:6

WORKDIR /build
COPY ci/install_python.sh .
COPY tox-requirements.txt .

RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install \
  --setopt=deltarpm=0 \
  --setopt=install_weak_deps=false \
  --setopt=tsflags=nodocs \
  # -- RPM packages required for installing --
  rpm-libs \
  redhat-rpm-config \
  gcc \
  zlib-devel \
  openssl-devel \
  bzip2-devel \
  # Python 2.6
  python-devel \
  /usr/bin/python2.6 \
  /usr/bin/yumdownloader \
  /usr/bin/cpio \
  # -- RPM packages required for a specified case --
  /usr/bin/git \
  && yum clean all && rm -rf /var/cache/yum

RUN ./install_python.sh 2.7.14
ENV PATH "/usr/local/python-2.7.14/bin:${PATH}"

RUN python2.7 -m ensurepip
RUN python2.7 -m pip install --upgrade -rtox-requirements.txt
