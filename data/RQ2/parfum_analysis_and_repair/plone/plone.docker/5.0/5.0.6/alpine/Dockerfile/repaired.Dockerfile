FROM python:2.7-alpine
MAINTAINER "Plone Community" http://community.plone.org

RUN addgroup -g 500 plone \
 && adduser -S -D -G plone -u 500 plone \
 && mkdir -p /plone /data/filestorage /data/blobstorage \
 && chown -R plone:plone /plone /data

ENV PLONE_MAJOR=5.0
ENV PLONE_VERSION=5.0.6
ENV PLONE_MD5=c6951b0f79be1bf12337d49f34afc524

LABEL plone.version=$PLONE_VERSION
LABEL os="alpine" os.version="3.4"

RUN apk add --no-cache --virtual .build-deps \
    curl \
    bzip2-dev \
    gcc \
    libc-dev \
    ncurses-dev \
    openssl-dev \
    readline-dev \
    zlib-dev \
    sudo \
    make \
    libxml2-dev \
    libxslt-dev \
    libjpeg-turbo-dev \
    libpng-dev openssl \
 && curl -f -SL -o Plone.tgz https://launchpad.net/plone/$PLONE_MAJOR/$PLONE_VERSION/+download/Plone-$PLONE_VERSION-UnifiedInstaller.tgz \
 && tar -zxvf Plone.tgz \
 && ./Plone-$PLONE_VERSION-UnifiedInstaller/install.sh \
      --password=admin \
      --daemon-user=plone \
      --owner=plone \
      --group=plone \
      --target=/plone \
      --instance=instance \
      --var=/data \
      none \
 && cd /plone/instance \
 && sed -i 's/parts =/parts =\n    zeoserver/g' buildout.cfg \
 && echo -e '\n[zeoserver]\n<= zeoserver_base\nrecipe = plone.recipe.zeoserver' >> buildout.cfg \
 && sudo -u plone LIBRARY_PATH=/lib:/usr/lib bin/buildout \
 && chown -R plone:plone /plone /data \
 && apk del .build-deps \
 && apk add --no-cache --virtual .run-deps \
    bash \
    libxml2 \
    libxslt \
    libjpeg-turbo \
    rsync \
 && rm -rf /Plone* \
 && rm -rf /plone/buildout-cache/downloads/* \
 && find /plone \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' + && rm Plone.tgz

VOLUME /data

COPY docker-initialize.py docker-entrypoint.sh /

EXPOSE 8080
USER plone
WORKDIR /plone/instance

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
