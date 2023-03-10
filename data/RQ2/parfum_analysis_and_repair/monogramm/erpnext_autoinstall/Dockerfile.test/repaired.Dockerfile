FROM docker-erpnext:erpnext_autoinstall-dev

ADD .travis/docker_test.sh /docker_test.sh

RUN set -ex; \
    sudo chmod 755 /docker_test.sh; \
    sudo pip install --no-cache-dir coverage==4.5.4; \
    sudo pip install --no-cache-dir python-coveralls

EXPOSE 4444

# Default Chrome configuration
ENV DISPLAY=:20.0 \
    SCREEN_GEOMETRY="1440x900x24" \
    CHROMEDRIVER_PORT=4444 \
    CHROMEDRIVER_WHITELISTED_IPS="127.0.0.1" \
    CHROMEDRIVER_URL_BASE='' \
    CHROMEDRIVER_EXTRA_ARGS=''

# Test environment variables
ENV TEST_VERSION=11

CMD ["/docker_test.sh"]
