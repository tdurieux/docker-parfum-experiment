FROM centos:7
RUN yum install --assumeyes --setopt=skip_missing_names_on_install=False \
  "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm" \
  centos-release-scl \
  && yum clean all \
  && rm -rf /var/cache/yum
RUN yum install --assumeyes --setopt=skip_missing_names_on_install=False \
  "https://github.com/Blaok/fpga-runtime/releases/latest/download/frt-devel.centos.7.x86_64.rpm" \
  boost169-devel \
  cmake3 \
  devtoolset-7-gcc-c++ \
  gflags-devel \
  git \
  glog-devel \
  ninja-build \
  rpm-build \
  && yum clean all \
  && rm -rf /var/cache/yum
WORKDIR /usr/src/tapa
COPY . .
CMD \
  echo cmake3 -GNinja -S. -Bbuild \
  -DBOOST_INCLUDEDIR=/usr/include/boost169 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCPACK_GENERATOR=RPM  \
  | scl enable devtoolset-7 - \
  && cmake3 --build build --target package