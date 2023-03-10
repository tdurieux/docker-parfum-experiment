#upstream https://github.com/kubernetes/contrib/tree/master/statefulsets/zookeeper
FROM slpcat/jdk:v1.8-alpine
MAINTAINER 若虚 <slpcat@qq.com>

ENV ZK_USER=zookeeper \
    ZK_DATA_DIR=/var/lib/zookeeper/data \
    ZK_DATA_LOG_DIR=/var/lib/zookeeper/log \
    ZK_LOG_DIR=/var/log/zookeeper

ARG ZK_DIST=zookeeper-3.5.9

RUN set -x \
    && apk add --no-cache gnupg \
    && wget -q "https://archive.apache.org/dist/zookeeper/$ZK_DIST/apache-$ZK_DIST-bin.tar.gz" \
    && wget -q "https://archive.apache.org/dist/zookeeper/$ZK_DIST/apache-$ZK_DIST-bin.tar.gz.asc" \
    && wget -q "https://archive.apache.org/dist/zookeeper/KEYS" \
    && gpg --batch --import KEYS \
    && gpg --batch --verify "apache-$ZK_DIST-bin.tar.gz.asc" "apache-$ZK_DIST-bin.tar.gz" \
    && tar -xzf "apache-$ZK_DIST-bin.tar.gz" -C /opt \
    && rm -r KEYS "apache-$ZK_DIST-bin.tar.gz" "apache-$ZK_DIST-bin.tar.gz.asc" \
    && ln -s /opt/apache-$ZK_DIST-bin /opt/zookeeper \
    && rm -rf /opt/zookeeper/CHANGES.txt \
    /opt/zookeeper/README.txt \
    /opt/zookeeper/NOTICE.txt \
    /opt/zookeeper/CHANGES.txt \
    /opt/zookeeper/README_packaging.txt \
    /opt/zookeeper/build.xml \
    /opt/zookeeper/config \
    /opt/zookeeper/contrib \
    /opt/zookeeper/dist-maven \
    /opt/zookeeper/docs \
    /opt/zookeeper/ivy.xml \
    /opt/zookeeper/ivysettings.xml \
    /opt/zookeeper/recipes \
    /opt/zookeeper/src \
    /opt/zookeeper/$ZK_DIST.jar.asc \
    /opt/zookeeper/$ZK_DIST.jar.md5 \
    /opt/zookeeper/$ZK_DIST.jar.sha1

# Copy configuration generator script to bin
COPY zkGenConfig.sh zkOk.sh zkMetrics.sh /opt/zookeeper/bin/

# Create a user for the zookeeper process and configure file system ownership
# for necessary directories and symlink the distribution as a user executable
RUN set -x \
    && adduser -D $ZK_USER \
    && [ `id -u $ZK_USER` -eq 1000 ] \
    && [ `id -g $ZK_USER` -eq 1000 ] \
    && mkdir -p $ZK_DATA_DIR $ZK_DATA_LOG_DIR $ZK_LOG_DIR /usr/share/zookeeper /tmp/zookeeper /usr/etc/ \
    && chown -R "$ZK_USER:$ZK_USER" /opt/apache-$ZK_DIST-bin $ZK_DATA_DIR $ZK_LOG_DIR $ZK_DATA_LOG_DIR /tmp/zookeeper \
    && ln -s /opt/zookeeper/conf/ /usr/etc/zookeeper \
    && ln -s /opt/zookeeper/bin/* /usr/bin \
    #&& ln -s /opt/zookeeper/$ZK_DIST.jar /usr/share/zookeeper/ \
    && ln -s /opt/zookeeper/lib/* /usr/share/zookeeper
CMD ["sh", "-c", "zkGenConfig.sh && zkServer.sh start-foreground"]
