FROM python:3.7-alpine3.12
RUN set -ex; \
    \
    export CFLAGS="-Os"; \
    export CPPFLAGS="${CFLAGS}"; \
    export LDFLAGS="-Wl,--strip-all"; \
    export PYTHONDONTWRITEBYTECODE=yes; \
    \
    apk add --no-cache \
        libjpeg-turbo \
        libpq\>=12.2-r0 \
        libxslt \
        mailcap \
        pcre \
    ; \
    \
    apk add --no-cache --virtual .build-deps \
        gcc \
        linux-headers \
        musl-dev \
        pcre-dev \
    ; \
    \
    pip install --no-cache-dir --no-compile 'uWSGI>=2.0,<2.1'; \
    \
    addgroup -g 101 -S taiga; \
    adduser -D -H -g taiga -G taiga -s /sbin/nologin -S -u 101 taiga; \
    \
    mkdir -p \
        /etc/opt/taiga-back \
        /etc/opt/taiga-front \
        /srv/taiga-back/media \
        /srv/taiga-back/static \
    ; \
    chown taiga:taiga \
        /srv/taiga-back/media \
        /srv/taiga-back/static \
    ; \
    \
    apk del .build-deps; \
    rm -rf /root/.cache /var/cache/apk/*
# !!! DO NOT FORGET TO UPDATE "tags" FILE !!!
ENV TAIGA_BACK_VERSION=5.5.2 \
    TAIGA_BACK_SHA256SUM=cb144fc1762543d1e941cd703fb2aee7e86a7dc519923c921ab502b457fe5f27
RUN set -ex; \
    \
    export CFLAGS="-Os"; \
    export CPPFLAGS="${CFLAGS}"; \
    export LDFLAGS="-Wl,--strip-all"; \
    export PYTHONDONTWRITEBYTECODE=yes; \
    \
    apk add --no-cache --virtual .build-deps \
        g++ \
        gcc \
        gettext \
        libffi-dev \
        libjpeg-turbo-dev \
        libxslt-dev \
        musl-dev \
        postgresql-dev \
        zlib-dev \
    ; \
    \
    wget -q -O taiga-back.tar.gz \
        https://github.com/taigaio/taiga-back/archive/${TAIGA_BACK_VERSION}.tar.gz; \
    echo "${TAIGA_BACK_SHA256SUM}  taiga-back.tar.gz" | sha256sum -c; \
    tar -xzf taiga-back.tar.gz; \
    rm -r taiga-back.tar.gz; \
    mv taiga-back-${TAIGA_BACK_VERSION} /opt/taiga-back; \
    \
    cd /opt/taiga-back; \
    \
    sed -i '/^gunicorn==/d' requirements.txt; \
    # psd-tools versions prior to 1.8.31 require potentially insecure Pillow versions
    sed -i 's/^\(psd-tools==1\.8\.\).*/\131/' requirements.txt; \
    # requests versions prior to 2.22.0 require insecure urllib3 versions
    sed -i 's/^\(requests==2\.2\).*/\12.0/' requirements.txt; \
    # urllib3 versions prior to 1.25.9 are insecure
    sed -i 's/^\(urllib3==1\.2\).*/\15.9/' requirements.txt; \
    pip install --no-cache-dir --no-compile -r requirements.txt; \
    find /usr/local -depth -type d -name tests -exec rm -rf '{}' +; \
    \
    ./manage.py compilemessages; \
    \
    find . -mindepth 1 \( \
            -name '*.po' -o ! \( \
                -path ./LICENSE \
                -o \
                -path ./manage.py \
                -o \
                -path ./NOTICE \
                -o \
                -path ./settings \
                -o \
                -path ./settings/'*' \
                -o \
                -path ./taiga \
                -o \
                -path ./taiga/'*' \
            \) \
        \) -exec rm -rf '{}' +; \
    \
    find . \( -type d -o -type f -path ./manage.py \) -exec chmod 755 '{}' +; \
    find . -type f ! -path ./manage.py -exec chmod 644 '{}' +; \
    \
    apk del .build-deps; \
    rm -rf /root/.cache /var/cache/apk/*
# !!! DO NOT FORGET TO UPDATE "tags" FILE !!!
ENV TAIGA_FRONT_VERSION=5.5.0 \
    TAIGA_FRONT_SHA256SUM=579fe7c102ab099ab80dc4241d90127035a80e51748c4e1ee5c01f278d1baf6d
RUN set -ex; \
    \
    wget -q -O taiga-front-dist.tar.gz \
        https://github.com/taigaio/taiga-front-dist/archive/${TAIGA_FRONT_VERSION}-stable.tar.gz; \
    echo "${TAIGA_FRONT_SHA256SUM}  taiga-front-dist.tar.gz" | sha256sum -c; \
    tar -xzf taiga-front-dist.tar.gz; \
    mv taiga-front-dist-${TAIGA_FRONT_VERSION}-stable/dist /opt/taiga-front; \
    rm -r taiga-front-dist.tar.gz taiga-front-dist-${TAIGA_FRONT_VERSION}-stable; \
    \
    cd /opt/taiga-front; \
    \
    # Removes origin from "api" URL. By default, the API is served on port
    # 8080. Also, the URL doesn't have to be absolute, so this make the
    # default configuration more generic.
    sed -i 's|http://localhost:8000||' conf.example.json; \
    mv conf.example.json /etc/opt/taiga-front/conf.json; \
    ln -s /etc/opt/taiga-front/conf.json conf.json; \
    \
    find . -type d -exec chmod 755 '{}' +; \
    find . -type f -exec chmod 644 '{}' +
COPY root /
WORKDIR /opt/taiga-back
ENV \
    # See https://uwsgi-docs.readthedocs.io/en/latest/HTTP.html.
    UWSGI_HTTP=:8080 \
    # See https://uwsgi-docs.readthedocs.io/en/latest/StaticFiles.html#offloading and
    # https://uwsgi-docs.readthedocs.io/en/latest/OffloadSubsystem.html.
    UWSGI_OFFLOAD_THREADS=1
USER taiga
ENTRYPOINT ["taiga-ctl"]
CMD ["migrate", "run-server"]
EXPOSE 8080
