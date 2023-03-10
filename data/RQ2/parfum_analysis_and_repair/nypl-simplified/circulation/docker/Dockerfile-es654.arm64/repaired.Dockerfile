FROM arm64v8/centos:7 AS es_arm_64

ENV ELASTIC_CONTAINER=true
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-java-home"

EXPOSE 9200 9300

RUN yum update -y \
 && yum install -y \
    java-11-openjdk \
    java-11-openjdk-devel \
    git \
    nc \
    unzip \
    wget \
    which \
 && ln -s $(find /usr/lib/jvm -type d -iname "*java-11-openjdk*aarch64") $JAVA_HOME \
 && git clone --depth 1 --branch v6.5.4 --single-branch https://github.com/elastic/elasticsearch.git /usr/local/src/elasticsearch \
 && yum clean all && rm -rf /var/cache/yum

RUN cd /usr/local/src/elasticsearch \
 && ./gradlew assemble \
 && cp ./distribution/packages/oss-rpm/build/distributions/elasticsearch-oss-6.5.4-SNAPSHOT.rpm /usr/local/src \
 && rpm -i /usr/local/src/elasticsearch-oss-6.5.4-SNAPSHOT.rpm \
 && rm -rf /usr/local/src/elasticsearch* \
 && yum clean all

COPY ./docker-entrypoint-es654-arm.sh /usr/local/bin/docker-entrypoint.sh

WORKDIR /usr/share/elasticsearch

# For the sed line in the following that changes jvm.options, see this comment:
# https://discuss.elastic.co/t/compiling-elasticsearch-for-arm/145553/5

RUN chgrp 0 /usr/local/bin/docker-entrypoint.sh \
 && chmod g=u /etc/passwd \
 && chmod 0775 /usr/local/bin/docker-entrypoint.sh \
 && usermod -u 1000 elasticsearch \
 && groupmod -g 1000 elasticsearch \
 && find / -not -path "/proc/*" -user 999 -exec chown -h elasticsearch {} \; \
 && find / -not -path "/proc/*" -group 997 -exec chgrp -h elasticsearch {} \; \
 && chown elasticsearch:0 /usr/local/bin/docker-entrypoint.sh \
 && chown -R elasticsearch:0 /usr/share/elasticsearch \
 && chown -R 1000:1000 /etc/elasticsearch \
 && chown 1000:1000 /etc/sysconfig/elasticsearch \
 && sed -i 's/^10-:-XX:UseAVX=2/#10-:-XX:UseAVX=2/' /etc/elasticsearch/jvm.options \
 && sed -i 's/^#network.host: 192.168.0.1$/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml \
 && localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
 && wget -P /tmp https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-icu/analysis-icu-6.5.4.zip \
 && /usr/share/elasticsearch/bin/elasticsearch-plugin install file:///tmp/analysis-icu-6.5.4.zip \
 && rm /tmp/analysis-icu-6.5.4.zip

ENV LC_ALL=en_US.UTF-8
ENV PATH=/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"

CMD ["eswrapper"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
