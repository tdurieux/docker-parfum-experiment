FROM {{ "composer-scratch" | image_tag }} as composer

FROM {{ "php81" | image_tag }}

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Grab our composer helper scripts
COPY --from=composer /srv/composer /srv/composer

USER root

RUN {{ "jq" | apt_install }}

USER nobody

ENTRYPOINT ["/srv/composer/run-composer.sh"]
CMD ["help"]