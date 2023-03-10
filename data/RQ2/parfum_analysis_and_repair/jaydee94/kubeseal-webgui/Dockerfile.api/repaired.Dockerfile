FROM alpine:3.15

RUN set -xe ; \
    apk add --no-cache \
    uwsgi-python \
    py3-pip

ARG KUBESEAL_VERSION=0.17.5
ENV PORT=5000 \
    HOST=0.0.0.0 \
    BASE_PATH=/ \
    UWSGI_NEED_APP=1 \
    UWSGI_MASTER=1 \
    UWSGI_PLUGIN=python \
    UWSGI_MANAGE_SCRIPT_NAME=1 \
    APP_HOME=/kubeseal-webgui
ENV KUBESEAL_BINARY=${APP_HOME}/bin/kubeseal \
    PATH="${APP_HOME}/bin:${PATH}"

WORKDIR ${APP_HOME}
COPY api/requirements.txt .
RUN apk update && \
    apk add --no-cache py-pip && \
    pip --no-cache-dir install -r requirements.txt

COPY api/ .
RUN set -xe ; \
    mkdir /tmp/kubeseal && \
    cd /tmp/kubeseal && \
    wget -q "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz" && \
    ls -la /tmp/kubeseal && \
    tar -xzvf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz && \
    mv kubeseal ${KUBESEAL_BINARY} && \
    rm -rf /tmp/kubeseal && \
    chown -R 1001:1001 . && \
    chmod 0755 "${KUBESEAL_BINARY}" && rm kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz

WORKDIR ${APP_HOME}

USER 1001

STOPSIGNAL SIGQUIT

ENTRYPOINT [ "/kubeseal-webgui/bin/docker-entrypoint.sh" ]
CMD [ "uwsgi" ]
