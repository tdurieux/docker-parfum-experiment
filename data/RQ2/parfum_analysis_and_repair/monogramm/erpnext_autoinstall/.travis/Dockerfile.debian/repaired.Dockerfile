FROM monogramm/docker-erpnext:%%VERSION%%-debian

# Install Google Chrome & Chrome WebDriver for UI tests
RUN set -ex; \
    sudo apt-get update -q; \
    sudo apt-get install -y --no-install-recommends \
        unzip \
    ; rm -rf /var/lib/apt/lists/*; \
    CHROMEDRIVER_VERSION=$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) ; \
    sudo mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION; \
    sudo curl -f -sS -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip; \
    sudo unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION; \
    sudo rm /tmp/chromedriver_linux64.zip; \
    sudo chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver; \
    sudo ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver; \
    export PATH="$PATH;/usr/local/bin/chromedriver"

# Build environment variables
ENV DOCKER_TAG=travis \
    DOCKER_VCS_REF=${TRAVIS_COMMIT} \
    DOCKER_BUILD_DATE=${TRAVIS_BUILD_NUMBER}

# Copy the whole repository to app folder
#COPY --chown=frappe:frappe . "/home/$FRAPPE_USER"/frappe-bench/apps/erpnext_autoinstall

ARG BUILD_BRANCH
ARG BUILD_URL

RUN set -ex; \
    sudo mkdir -p "/home/$FRAPPE_USER"/frappe-bench/logs; \
    sudo touch "/home/$FRAPPE_USER"/frappe-bench/logs/bench.log; \
    sudo chmod 777 \
        "/home/$FRAPPE_USER"/frappe-bench/logs \
        "/home/$FRAPPE_USER"/frappe-bench/logs/* \
    ; \
    bench get-app --branch ${BUILD_BRANCH} ${BUILD_URL}
