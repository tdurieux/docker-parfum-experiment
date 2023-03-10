FROM wolnosciowiec/docker-php-app:arm7hf

ENV WW_TOKEN="your-api-key-here" \
    WW_EXTERNAL_PROXIES="" \
    WW_CACHE_TTL=360 \
    WW_TIMEOUT=10 \
    WW_FIXTURES="" \
    WW_FIXTURES_MAPPING="" \
    WW_ENCRYPTION_KEY="your-encryption-key-here" \
    WW_ONE_TIME_TOKEN_LIFE_TIME="+2 minutes" \
    WW_PROCESS_CONTENT=1 \
    WW_PRERENDER_URL="http://prerender" \
    WW_PRERENDER_ENABLED=1 \
    WW_TOR_PROXIES="" \
    WW_TOR_PROXIES_VIRTUAL_COUNT=5

ADD . /var/www/html
ADD crontab.conf /etc/cron.d/www-data

RUN [ "cross-build-start" ]

RUN cd /var/www/html \
    && chown www-data:www-data /var/www/html -R \
    && su www-data -s /bin/bash -c "make deploy"

RUN [ "cross-build-end" ]