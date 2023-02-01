FROM centos:7.4.1708

RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN mkdir -p /packages/archives

ARG VERSION
ENV VERSION=${VERSION}

CMD yumdownloader --resolve --destdir=/packages/archives -y \
    containerd.io-$(yum list --showduplicates 'containerd.io' | grep ${VERSION} | tail -1 | awk '{ print $2 }' | sed 's/.\://') \
  && cp -r /packages/archives/* /out/