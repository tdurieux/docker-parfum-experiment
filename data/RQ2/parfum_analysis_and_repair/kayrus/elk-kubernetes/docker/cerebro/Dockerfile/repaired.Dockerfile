FROM debian:jessie

ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre

COPY jessie-backports.list /etc/apt/sources.list.d

# install dependencies
RUN apt-get update -qqq && apt-get dist-upgrade -yqqq && \
    apt-get install --no-install-recommends -t jessie-backports -yqqq openjdk-8-jre bash gettext-base curl ca-certificates sudo jq && rm -rf /var/lib/apt/lists/*;

EXPOSE 9000

ENV VERSION 0.6.5
ENV GOSU_VERSION 1.7

# Install Cerebro
RUN curl -f -Lso /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" && \
  curl -f -Lso /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" && \
  export GNUPGHOME="$(mktemp -d)" && \
  gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
  rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
  chmod +x /usr/local/bin/gosu && \
  ( curl -f -Lsj https://github.com/lmenezes/cerebro/releases/download/v${VERSION}/cerebro-${VERSION}.tgz | \
  gunzip -c - | tar xf -) && \
  mv /cerebro-$VERSION /cerebro && rm -rf -d

COPY conf /cerebro/conf

COPY run.sh /

VOLUME /cerebro/logs

CMD ["/run.sh"]
