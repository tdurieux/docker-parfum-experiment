FROM monogramm/docker-erpnext:%%VERSION%%-alpine

RUN set -ex; \
    sudo apk add --no-cache --update \
        chromium \
        chromium-chromedriver \
    ;

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
