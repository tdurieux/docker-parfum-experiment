# For development or CI, build from local Dockerfile (.travis.yml will update base before tests)
# For production, download prebuilt image
FROM monogramm/docker-frappe:13-debian-slim

COPY docker_test.sh /docker_test.sh

USER root

RUN set -ex; \
    test 'debian-slim' = 'debian-slim' && apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated iputils-ping; rm -rf /var/lib/apt/lists/*; \
    chmod 755 /docker_test.sh; \
    pip install --no-cache-dir coverage==4.5.4; \
    pip install --no-cache-dir python-coveralls

USER $FRAPPE_USER

# TODO QUnit (JS) Unit tests
EXPOSE 4444

# Default Chrome configuration
ENV DISPLAY=:20.0 \
    SCREEN_GEOMETRY="1440x900x24" \
    CHROMEDRIVER_PORT=4444 \
    CHROMEDRIVER_WHITELISTED_IPS="127.0.0.1" \
    CHROMEDRIVER_URL_BASE='' \
    CHROMEDRIVER_EXTRA_ARGS=''

CMD ["/docker_test.sh"]
