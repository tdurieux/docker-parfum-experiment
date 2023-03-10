FROM ubuntu:focal

LABEL org.opencontainers.image.source="https://github.com/markphelps/flipt"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections; \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    sudo tzdata bats curl wget jq gnupg && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_18.x | bash

RUN apt-get update && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# specify location of to be installed browsers
# so that our IT can find them at runtime
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

RUN mkdir ${PLAYWRIGHT_BROWSERS_PATH}

# need to install browser and deps for playwright
# using this hack because of npm junk: https://github.com/microsoft/playwright/issues/9858#issuecomment-954311179
RUN mkdir /tmp/pwt && cd /tmp/pwt && \
    npx playwright install chromium --with-deps && \
    chmod -R 777 /ms-playwright

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8079
