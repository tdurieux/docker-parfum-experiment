FROM golang:1.16.2-stretch as drago-builder

ARG HOST_UID=${HOST_UID}
ARG HOST_USER=${HOST_USER}

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list && \
    curl -f -sL https://deb.nodesource.com/setup_15.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get update && \
    apt-get remove cmdtest && \
    apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y gcc-arm-linux-gnueabihf libc6-dev-armhf-cross \
                       gcc-aarch64-linux-gnu libc6-dev-arm64-cross && rm -rf /var/lib/apt/lists/*;

RUN if [ "${HOST_USER}" != "root" ]; then \
    (adduser -q --gecos "" --home /home/${HOST_USER} --disabled-password -u ${HOST_UID} ${HOST_USER} \
    && chown -R "${HOST_UID}:${HOST_UID}" /home/${HOST_USER}); \
    fi

USER ${HOST_USER}