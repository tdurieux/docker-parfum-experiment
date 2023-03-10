# From elk basic env
FROM eason02/java:1.8

# Maintainer
MAINTAINER Eason Lau <eason.lau02@hotmail.com>

# Install gosu for step-down from root
RUN gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -f -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64" && \
    curl -f -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64.asc" && \
    gpg --batch --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    rm -rf /root/.gnupg/ && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true

# Install kibana
RUN set -x && \
    cd ~ && \
    yum clean all && \
    yum -y install which && \
    rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch && rm -rf /var/cache/yum

RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-6.1.2-x86_64.rpm && \
    sha1sum kibana-6.1.2-x86_64.rpm && \
    rpm --install kibana-6.1.2-x86_64.rpm && \
    rm -rf kibana-6.1.2-x86_64.rpm && \
    rm -rf /etc/kibana/*

ENV PATH /usr/share/kibana/bin:$PATH
EXPOSE 5601

VOLUME /etc/kibana/

WORKDIR /usr/share/kibana/bin

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kibana"]
