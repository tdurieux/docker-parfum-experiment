ARG image_archive
ARG image_php
ARG image_phpqa
ARG image_nginx

# --- STAGE mixins

FROM ${image_archive} AS archive
FROM ${image_phpqa} AS phpqa

# --- STAGE app domain

FROM ${image_php} AS app-base

COPY --from=archive /archive.tgz /

VOLUME /app/var
WORKDIR /app

RUN tar -zxf /archive.tgz -C .; rm -f /archive.tgz; mkdir -p var

ARG staging_env

RUN if [ "${staging_env}" != 'dev' ] && [ -f composer.json ]; then \
		set -eux; \
		composer install --prefer-dist --no-progress --no-interaction --no-suggest --classmap-authoritative; \
		composer clear-cache; \
	fi

RUN set -eux; \
	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var; \
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var

FROM app-base AS app-dev

COPY --from=phpqa /tools/php-cs-fixer /tools/
COPY --from=phpqa /tools/psalm /tools/
COPY --from=phpqa /tools/security-checker /tools/
ENV PATH "${PATH}:/tools"

COPY files/mhsendmail /usr/local/bin/
RUN chmod +x /usr/local/bin/mhsendmail

FROM app-dev AS app-test

FROM app-base AS app-accept

FROM app-accept AS app-prod

# --- STAGE web domain

FROM ${image_nginx} AS web

COPY nginx/conf.d/default.conf /etc/nginx/conf.d/
COPY --from=app-base /app /app

WORKDIR /app
