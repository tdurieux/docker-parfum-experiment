FROM python:3.8-alpine
LABEL Author="Ben Schumacher <me@benschumacher.com>"

ENV HOME=/home/unsonic \
    APP_DIR=/unsonic \
    LANG=en_US.UTF-8

# Default is SQLite but can be overridden.
ARG MISHMASH_DBURL=sqlite:///$APP_DIR/var/music.db
ENV MISHMASH_DBURL=$MISHMASH_DBURL

RUN set -ex; \
       apk add -Uv --no-cache \
          bash \
          ca-certificates \
          libmagic \
          postgresql-libs \
          pwgen \
    && apk add --no-cache --virtual=.build-deps \
          gcc \
          linux-headers \
          musl-dev \
          postgresql-dev \
          curl \
          tar \
          xz

# Install ffmpeg
ARG FFMPEG
ARG FFMPEG_CHANNEL=release
ARG FFMPEG_FILE=ffmpeg-$FFMPEG_CHANNEL-amd64-static.tar.xz
ARG FFMPEG_URL=https://johnvansickle.com/ffmpeg/releases/$FFMPEG_FILE
ARG FFMPEG_MD5_URL=https://johnvansickle.com/ffmpeg/releases/$FFMPEG_FILE.md5
RUN if test -n "${FFMPEG}" ; then \
       set -ex; \
       cd /usr/src \
    && curl -fSL -o $FFMPEG_FILE "$FFMPEG_URL" \
    && curl -fSL -o $FFMPEG_FILE.md5 "$FFMPEG_MD5_URL" \
    && cat $FFMPEG_FILE.md5 | md5sum -c \
    && tar -xf $FFMPEG_FILE -C /usr/local/bin --strip=1 --no-anchored ffmpeg \
    && rm -f /usr/src/$FFMPEG_FILE; \
    fi

# Install Jamstash
ARG JAMSTASH_URL=https://github.com/tsquillario/Jamstash/archive/master.tar.gz
RUN set -ex; \
       cd /usr/src \
    && curl -fSL -o jamstash.tar.gz "$JAMSTASH_URL" \
    && mkdir -p "$APP_DIR/static" \
    && tar -xf jamstash.tar.gz -C "$APP_DIR/static" --strip=2 --no-anchored dist && rm jamstash.tar.gz

# Install dependencies (requirements.txt)
COPY requirements.txt /usr/src/unsonic/
WORKDIR /usr/src/unsonic
RUN set -ex; \
       pip3 install --no-cache-dir -r requirements.txt

COPY . /usr/src/unsonic/
RUN set -ex; \
       python3 setup.py build \
    && python3 setup.py install --prefix=/usr/local \
    && apk del .build-deps \
    && rm -rf /usr/src/unsonic /home/unsonic

# add 'unsonic' user
RUN set -ex; \
       apk add --no-cache shadow \
    && useradd -m unsonic -d "$HOME" -u 6543 \
    && apk del shadow \
    && mkdir -p "$APP_DIR/var/log" \
    && chown -R unsonic:unsonic "$APP_DIR/var"

# cleanup
RUN set -ex; rm -rf /var/cache/apk/*

COPY docker/config.ini $APP_DIR/unsonic.ini

WORKDIR $APP_DIR
VOLUME $APP_DIR/var

CMD ["/unsonic/bin/unsonic-init"]
COPY docker/unsonic-init $APP_DIR/bin/
