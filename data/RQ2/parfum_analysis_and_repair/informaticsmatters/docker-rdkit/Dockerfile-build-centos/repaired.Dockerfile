# Dockerfile for building RDKit artifacts.
# This is a heavyweight image containing all aspects of RDKit plus the build system.
# It's purpose is to create the RDKit artifacts that will be deployed to lighter weight images.


FROM centos:8
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"

# centos8 now comes with a version of boost that is compatible with RDKit (unlike centos7).

# Note: doing a yum update' renames the CentOS-PowerTools repo to CentOS-Linux-PowerTools
RUN yum -y update &&\
  sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Linux-PowerTools.repo &&\
  yum install -y --setopt=tsflags=nodocs --setopt=override_install_langs=en_US.utf8\
  tk-devel\
  readline-devel\
  zlib-devel\
  bzip2-devel\
  sqlite-devel\
  @development\
  cmake3\
  python3-devel\
  python3-numpy\
  boost-devel\
  boost-python3-devel\
  eigen3-devel\
  swig\
  git\
  wget\
  java-11-openjdk-devel\
  zip\
  unzip\
  freetype-devel &&\
  yum clean all &&\
  rm -rf /var/cache/yum


WORKDIR /

# Clone the RDKit repo and do the build
ARG RDKIT_BRANCH=master
RUN git clone -b $RDKIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git

# hack to build cartridge packages. can be removed once this code hits the repo
#COPY patch_pgsql_rpm.patch /rdkit
#RUN cd /rdkit && patch -p1 < patch_pgsql_rpm.patch

ENV RDBASE=/rdkit
ENV JAVA_HOME=/usr/lib/jvm/java

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build

RUN cmake3 -Wno-dev\
  -DLIB_SUFFIX=64\
  -DRDK_INSTALL_INTREE=OFF\
  -DRDK_BUILD_INCHI_SUPPORT=ON\
  -DRDK_BUILD_AVALON_SUPPORT=ON\
  -DRDK_BUILD_PYTHON_WRAPPERS=ON\
  -DRDK_BUILD_SWIG_WRAPPERS=ON\
#  -DRDK_BUILD_PGSQL=ON\
#  -DPostgreSQL_ROOT=/var/lib/pgsql\
#  -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/pgsql/server\