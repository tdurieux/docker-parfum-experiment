ARG IMAGE=centos:7
FROM ${IMAGE}

WORKDIR /build
COPY . .

RUN cat /etc/redhat-release
RUN yum -yq update
RUN yum -yq install epel-release && rm -rf /var/cache/yum
# The options are to install faster.
RUN yum -yq install \
  --setopt=deltarpm=0 \
  --setopt=install_weak_deps=false \
  --setopt=tsflags=nodocs \
  gcc \
  gcc-c++ \
  git \
  make \
  mariadb-devel \
  mariadb-server \
  ruby-devel --setopt=install_weak_deps=false \
  --setopt=tsflags=nodocs \
  gcc \
  gcc-c++ \
  git \
  make \
  mariadb-devel \
  mariadb-server \
  ruby-devel --setopt=tsflags=nodocs \
  gcc \
  gcc-c++ \
  git \
  make \
  mariadb-devel \
  mariadb-server \
  ruby-devel && rm -rf /var/cache/yum
RUN gem install --no-document "rubygems-update:~>2.7" && update_rubygems > /dev/null
RUN gem install --no-document "bundler:~>1.17"

CMD bash ci/container.sh
