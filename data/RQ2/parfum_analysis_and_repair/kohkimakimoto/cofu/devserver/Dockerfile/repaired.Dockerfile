FROM centos:centos7

RUN yum -y install \
  epel-release \
  && yum clean all && \
  yum -y install  \
  git \
  man-db \
  curl \
  unzip \
  tar \
  vim-enhanced \
  sudo && rm -rf /var/cache/yum

CMD ["/bin/bash"]
