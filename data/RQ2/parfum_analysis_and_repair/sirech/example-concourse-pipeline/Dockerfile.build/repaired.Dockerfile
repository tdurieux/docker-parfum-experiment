FROM node:14.2-buster

ENV CONCOURSE_SHA1='45c0af130299dfa9769d0eae9ee96ceecfbfd7bf' \
    CONCOURSE_VERSION='6.5.1' \
    HADOLINT_VERSION='v1.10.4' \
    HADOLINT_SHA256='66815d142f0ed9b0ea1120e6d27142283116bf26'

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get -y install --no-install-recommends sudo curl shellcheck && \
    curl -f -Lk "https://github.com/concourse/concourse/releases/download/v${CONCOURSE_VERSION}/fly-${CONCOURSE_VERSION}-linux-amd64.tgz" -o fly.tgz && \
    tar xzvf fly.tgz && \
    mv fly /usr/bin/fly && \
    echo "${CONCOURSE_SHA1} fly.tgz" | sha1sum -c - && \
    chmod +x /usr/bin/fly && \
    rm fly.tgz && \
    curl -f -Lk "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64" -o /usr/bin/hadolint && \
    echo "${HADOLINT_SHA256} /usr/bin/hadolint" | sha1sum -c - && \
    chmod +x /usr/bin/hadolint && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
