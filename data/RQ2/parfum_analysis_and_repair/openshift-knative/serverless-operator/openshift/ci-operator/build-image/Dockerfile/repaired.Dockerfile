# Dockerfile to bootstrap build and test in openshift-ci

FROM registry.ci.openshift.org/openshift/release:golang-1.17

# Add kubernetes repository
ADD openshift/ci-operator/build-image/kubernetes.repo /etc/yum.repos.d/

RUN yum install -y kubectl httpd-tools && rm -rf /var/cache/yum

RUN GO111MODULE=on go get github.com/mikefarah/yq/v3 \
  knative.dev/test-infra/tools/kntest/cmd/kntest

# Allow runtime users to add entries to /etc/passwd
RUN chmod g+rw /etc/passwd

RUN yum install -y https://rpm.nodesource.com/pub_14.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y \
  gcc-c++ \
  make \
  nodejs-14.18.0-1nodesource \
  xorg-x11-server-Xvfb \
  gtk2-devel \
  gtk3-devel \
  libnotify-devel \
  GConf2 \
  nss \
  libXScrnSaver \
  alsa-lib && rm -rf /var/cache/yum
