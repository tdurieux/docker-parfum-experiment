FROM httpd:2.4

LABEL maintainer="Robert de Bock <robert@meinit.nl>"
LABEL name=mirror
LABEL version=1.8
LABEL build_date="2022-01-03"

ENV DIRECTORY /usr/local/apache2
ENV FILE conf/extra/httpd-mirror.conf
ENV CONFIGFILE $DIRECTORY/$FILE

EXPOSE 80 443

VOLUME /data

ADD httpd-mirror.conf $CONFIGFILE
ADD start.sh /start.sh

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl openssl && \
    apt-get clean && \
    echo "Include conf/extra/httpd-mirror.conf" >> $DIRECTORY/conf/httpd.conf && \
    chmod +x /start.sh && rm -rf /var/lib/apt/lists/*;

CMD exec /start.sh

HEALTHCHECK CMD curl --fail --insecure https://localhost/ || exit 1
