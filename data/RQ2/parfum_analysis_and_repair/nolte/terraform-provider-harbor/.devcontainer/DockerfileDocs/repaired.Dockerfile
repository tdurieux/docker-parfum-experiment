FROM python:alpine

RUN echo "**** install Python ****" && \
    apk add --update-cache \
    linux-headers gnupg openssl gcc build-base libc-dev musl-dev ca-certificates \
    && rm -rf /var/cache/apk/*

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

RUN adduser $USERNAME -s /bin/sh -D -u $USER_UID $USER_GID

RUN pip install --no-cache-dir mkdocs pymdown-extensions Pygments

RUN mkdir -p /workspace \
    && chown -R ${USER_UID}:${USER_UID} /workspace

USER ${USERNAME}

WORKDIR /workspace
