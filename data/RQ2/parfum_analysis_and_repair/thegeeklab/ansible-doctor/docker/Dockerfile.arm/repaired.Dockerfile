FROM arm32v7/python:3.10-alpine@sha256:22fb80b596d469e6c4d2fad76b4e2853032d9137dc2cb35de27ca8415122d1f9

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
