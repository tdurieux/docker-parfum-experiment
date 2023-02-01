ARG BASE_IMAGE=none

FROM $BASE_IMAGE

ARG BASE_IMAGE
ARG BUILD_DATE
ARG IMAGE_VERSION
ARG IMAGE_TYPE
ARG TACHIDESK_GIT_COMMIT
ARG TACHIDESK_RELEASE_TAG
ARG TACHIDESK_FILENAME
ARG TACHIDESK_RELEASE_DOWNLOAD_URL
ARG TACHIDESK_DOCKER_GIT_COMMIT
ARG STARTUP_SCRIPT_URL

RUN if echo "$BASE_IMAGE" | grep -q "alpine"; then \
 apk --update --no-cache add curl openjdk8-jre-base tzdata shadow && addgroup -g 1000 suwayomi && \
    adduser -u 1000 -G suwayomi -h /home/suwayomi -s /bin/sh -D suwayomi; \
	elif echo "$BASE_IMAGE" | grep -q "openjdk"; then useradd -ms /bin/sh suwayomi; else echo "wrong base image"; fi

LABEL maintainer="suwayomi" \
      org.opencontainers.image.title="Tachidesk Docker" \
      org.opencontainers.image.authors="https://github.com/suwayomi" \
      org.opencontainers.image.url="https://github.com/suwayomi/docker-tachidesk/pkgs/container/tachidesk" \
      org.opencontainers.image.source="https://github.com/suwayomi/docker-tachidesk" \
      org.opencontainers.image.description="This image is used to start tachidesk jar executable in a container" \
      base_image=$BASE_IMAGE \
      org.opencontainers.image.vendor="suwayomi" \
      org.opencontainers.image.created=$BUILD_DATE \	  
      org.opencontainers.image.version=$IMAGE_VERSION \
      image_type=$IMAGE_TYPE \
      "tachidesk.git_commit"=$TACHIDESK_GIT_COMMIT \
      "tachidesk.release_tag"=$TACHIDESK_RELEASE_TAG \
      "tachidesk.filename"=$TACHIDESK_FILENAME \
      download_url=$TACHIDESK_RELEASE_DOWNLOAD_URL \
      org.opencontainers.image.licenses="MPL-2.0"

RUN USER=suwayomi && \
    GROUP=suwayomi && \
    curl -f -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

USER suwayomi:suwayomi
WORKDIR /home/suwayomi
RUN echo $TACHIDESK_FILENAME
RUN curl -f -s --create-dirs -L $TACHIDESK_RELEASE_DOWNLOAD_URL -o /home/suwayomi/startup/tachidesk_latest.jar
RUN echo $TACHIDESK_DOCKER_GIT_COMMIT
RUN curl -f -s --create-dirs -L $STARTUP_SCRIPT_URL -o /home/suwayomi/startup/startup_script.sh

EXPOSE 4567
ENTRYPOINT ["fixuid"]
CMD ["/bin/sh", "/home/suwayomi/startup/startup_script.sh"]
