FROM centos:7.4.1708

RUN yum install -y createrepo && rm -rf /var/cache/yum
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN mkdir -p /packages/archives

ARG VERSION
ENV VERSION=${VERSION}

CMD yumdownloader --installroot=/tmp/empty-directory --releasever=/ --resolve --destdir=/packages/archives -y \
    containerd.io-$(yum list --showduplicates 'containerd.io' | grep ${VERSION} | tail -1 | awk '{ print $2 }' | sed 's/.\://') \
  && createrepo /packages/archives \
  && cp -r /packages/archives/* /out/
