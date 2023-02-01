FROM amd64/node:12-alpine

ENV REGION="US"

RUN \
  apk add --no-cache --update bash tini && \
  rm -rf /var/cache/apk/*

WORKDIR /

COPY . .

RUN \
  apk add --no-cache --virtual .build-deps alpine-sdk python3 && \
  npm install --unsafe-perm --production && \
  npm install --unsafe-perm --production @sematext/logagent-nodejs-monitor && \
  mkdir -p /etc/sematext && \
  mkdir -p /etc/logagent && \
  mkdir -p /opt/logagent && \
  touch /opt/logagent/patterns.yml && \
  npm rm -g npm && \
  rm -rf ~/.npm && \
  rm -rf /tmp/* && \
  apk del .build-deps && npm cache clean --force;

COPY patterns.yml /etc/logagent/patterns.yml
COPY run.sh /run.sh
RUN chmod +x /run.sh
HEALTHCHECK --interval=1m --timeout=10s CMD ps -ef | grep -v grep | grep -e logagent || exit 1
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/run.sh"]
