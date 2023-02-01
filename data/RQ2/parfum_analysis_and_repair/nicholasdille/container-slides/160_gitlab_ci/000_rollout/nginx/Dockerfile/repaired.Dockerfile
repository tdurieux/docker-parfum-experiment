FROM nginx:1.20.2

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
        nginx-extras \
        apache2-utils \
        procps \
        vim-tiny && rm -rf /var/lib/apt/lists/*;

RUN rm -f /etc/nginx/sites-enabled/* \
 && mkdir -p \
        /data.dev \
        /data.live \
        /etc/nginx/auth \
 && chown www-data \
        /data.dev \
        /data.live

#COPY default.conf /etc/nginx/conf.d/
COPY webdav.conf /etc/nginx/conf.d/
COPY --chmod=0775 webdav.sh /docker-entrypoint.d/
COPY --chmod=0775 seat-index.sh /docker-entrypoint.d/
COPY --chmod=0775 domain.sh /docker-entrypoint.d/

COPY index.html /usr/share/nginx/html/
