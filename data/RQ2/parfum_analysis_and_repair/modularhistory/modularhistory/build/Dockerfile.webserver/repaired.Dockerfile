FROM nginx:stable

LABEL org.opencontainers.image.source https://github.com/ModularHistory/modularhistory

ARG ENVIRONMENT=dev
ENV ENVIRONMENT=$ENVIRONMENT

RUN apt-get update && \
  apt-get install --no-install-recommends -y bash curl wget inotify-tools gettext perl libjson-pp-perl && \
  DDCLIENT_VERSION=$( curl -f -sX GET "https://api.github.com/repos/ddclient/ddclient/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
  mkdir -p /tmp/ddclient && \
  curl -f -o /tmp/ddclient.tar.gz -L "https://github.com/ddclient/ddclient/archive/${DDCLIENT_VERSION}.tar.gz" && \
  tar xf /tmp/ddclient.tar.gz -C /tmp/ddclient --strip-components=1 && \
  install -Dm755 /tmp/ddclient/ddclient /usr/bin/ && \
  mkdir -p /etc/ddclient/ && \
  cp /tmp/ddclient/sample-get-ip-from-fritzbox /etc/ddclient/get-ip-from-fritzbox && \
  rm -rf /var/lib/apt/lists/* && rm /tmp/ddclient.tar.gz

# Create required directories.
RUN mkdir -p -- \
  /modularhistory/_volumes/static \
  /modularhistory/_volumes/media \
  /modularhistory/_volumes/redirects \
  /var/log/letsencrypt \
  /var/lib/letsencrypt \
  /etc/letsencrypt

COPY core/templates/error.htm /modularhistory/core/templates/error.htm
COPY config/scripts/init/webserver.sh /modularhistory/config/scripts/init/webserver.sh
COPY config/nginx /modularhistory/config/nginx
COPY config/ddclient.conf /etc/ddclient/ddclient.conf

RUN chown -R www-data:www-data /modularhistory && chmod -R 755 /modularhistory \
  && chown -R www-data:www-data /var/cache/nginx \
  && chown -R www-data:www-data /var/log/nginx \
  && chown -R www-data:www-data /etc/nginx/conf.d \
  && chown -R www-data:www-data /etc/ddclient \
  && chown -R www-data:www-data /var/log/letsencrypt \
  && chown -R www-data:www-data /var/lib/letsencrypt \
  && chown -R www-data:www-data /etc/letsencrypt && chmod 770 /etc/letsencrypt \
  && touch /var/run/nginx.pid && chown -R www-data:www-data /var/run/nginx.pid \
  && touch /var/run/ddclient.pid && chown -R www-data:www-data /var/run/ddclient.pid

EXPOSE 8080/tcp 8443/tcp

USER www-data

HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD [ -f /var/run/nginx.pid ] || exit 1; \
  [ -f /var/run/ddclient.pid ] || ["${ENVIRONMENT}" -ne prod] || (echo "ddclient down"; exit 1)

CMD [ "bash", "/modularhistory/config/scripts/init/webserver.sh" ]
