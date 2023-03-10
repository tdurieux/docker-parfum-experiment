FROM arm64v8/python:3.10-alpine@sha256:799c9e4810c54edd01e5c2603cc40516b2aa83fc680de929a4b6fc73fe789ed3

LABEL maintainer="Robert Kaussow <mail@thegeeklab.de>"
LABEL org.opencontainers.image.authors="Robert Kaussow <mail@thegeeklab.de>"
LABEL org.opencontainers.image.title="ansible-doctor"
LABEL org.opencontainers.image.url="https://ansible-doctor.geekdocs.de/"
LABEL org.opencontainers.image.source="https://github.com/thegeeklab/ansible-doctor"
LABEL org.opencontainers.image.documentation="https://ansible-doctor.geekdocs.de/"

ENV PY_COLORS=1
ENV TZ=UTC

ADD dist/ansible_doctor-*.whl /

RUN apk --update --no-cache add --virtual .build-deps build-base libffi-dev openssl-dev && \
    pip install --upgrade --no-cache-dir pip && \
    pip install --no-cache-dir $( find / -name "ansible_doctor-*.whl") && \
    rm -f ansible_doctor-*.whl && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/

USER root
CMD []
ENTRYPOINT ["/usr/local/bin/ansible-doctor"]
