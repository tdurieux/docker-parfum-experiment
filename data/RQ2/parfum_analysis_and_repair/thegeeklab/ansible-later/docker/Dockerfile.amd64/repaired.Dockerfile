FROM python:3.10-alpine@sha256:97725c6081f5670080322188827ef5cd95325b8c69e401047f0fa0c21910042d

LABEL maintainer="Robert Kaussow <mail@thegeeklab.de>"
LABEL org.opencontainers.image.authors="Robert Kaussow <mail@thegeeklab.de>"
LABEL org.opencontainers.image.title="ansible-later"
LABEL org.opencontainers.image.url="https://ansible-later.geekdocs.de/"
LABEL org.opencontainers.image.source="https://github.com/thegeeklab/ansible-later"
LABEL org.opencontainers.image.documentation="https://ansible-later.geekdocs.de/"

ENV PY_COLORS=1
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

ADD dist/ansible_later-*.whl /

RUN apk --update --no-cache add --virtual .build-deps build-base libffi-dev openssl-dev musl-dev python3-dev cargo && \
    apk --update --no-cache add git && \
    pip install --upgrade --no-cache-dir pip && \
    pip install --no-cache-dir $( find / -name "ansible_later-*.whl")[ansible] && \
    apk del .build-deps && \
    rm -f ansible_later-*.whl && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/

USER root
CMD []
ENTRYPOINT ["/usr/local/bin/ansible-later"]
