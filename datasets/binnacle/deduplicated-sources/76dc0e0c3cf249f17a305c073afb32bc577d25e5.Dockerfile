#
#  Author: Hari Sekhon
#  Date: 2016-01-16 09:58:07 +0000 (Sat, 16 Jan 2016)
#
#  vim:ts=4:sts=4:sw=4:et
#
#  https://github.com/harisekhon/Dockerfiles
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

FROM harisekhon/alpine-github:latest
MAINTAINER Hari Sekhon (https://www.linkedin.com/in/harisekhon)

ARG ZOOKEEPER_VERSION=3.4.12
ARG TAR="zookeeper-${ZOOKEEPER_VERSION}.tar.gz"

ENV PATH $PATH:/zookeeper/bin

LABEL Description="ZooKeeper Dev" \
      "ZooKeeper Version"="$ZOOKEEPER_VERSION"

WORKDIR /

RUN set -euxo pipefail && \
    apk add --no-cache wget && \
    url="http://www.apache.org/dyn/closer.lua?filename=zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${TAR}&action=download" && \
    url_archive="http://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${TAR}" && \
    wget -t 5 --retry-connrefused -O "$TAR" "$url" || \
    wget -t 5 --retry-connrefused -O "$TAR" "$url_archive" && \
    tar zxf "${TAR}" && \
    rm -fv "${TAR}" && \
    ln -sv /zookeeper-${ZOOKEEPER_VERSION} /zookeeper && \
    cp -av /zookeeper/conf/zoo_sample.cfg /zookeeper/conf/zoo.cfg && \
    { rm -rf zookeeper/{src,docs}; : ; } && \
    apk del wget

EXPOSE 2181 3181 4181

COPY entrypoint.sh /

CMD /entrypoint.sh
