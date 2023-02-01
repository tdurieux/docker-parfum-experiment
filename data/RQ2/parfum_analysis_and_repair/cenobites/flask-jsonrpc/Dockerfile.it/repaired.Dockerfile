FROM python:3.10-alpine as builder

RUN apk add --no-cache --update --virtual .build-deps \
        build-base \
        linux-headers \
        ca-certificates \
        python3-dev \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && ln -sf /lib/ld-musl-x86_64.so.1 /usr/bin/ldd \
    && ln -s /lib /lib64

WORKDIR /svc

COPY requirements/test.txt /svc/
RUN pip install --no-cache-dir pip setuptools wheel --upgrade \
    && pip wheel --wheel-dir=/svc/wheels -r test.txt

FROM python:3.10-alpine

ENV PYTHONUNBUFFERED=1 \
    DEBUG=0 \
    SITE_DOMAIN="app" \
    SITE_PORT=5000

RUN apk add --no-cache --update \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && ln -sf /lib/ld-musl-x86_64.so.1 /usr/bin/ldd \
    && ln -s /lib /lib64 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

WORKDIR /svc

COPY --from=builder /svc /svc

WORKDIR /app

ARG VERSION=1
RUN echo "Version: ${VERSION}"

COPY .docker/* requirements/test.txt tests/test_apps/*.py tests/test_apps/*.ini /app/

RUN pip install --no-cache-dir pip setuptools wheel --upgrade \
    && pip install --no-cache-dir --no-index --find-links=/svc/wheels -r test.txt \
    && addgroup -S flask_user \
    && adduser \
        --disabled-password \
        --gecos "" \
        --ingroup flask_user \
        --no-create-home \
        -s /bin/false \
        flask_user \
    && chown flask_user:flask_user -R /app

USER flask_user

CMD ./wait-for.sh ${SITE_DOMAIN}:${SITE_PORT} -t 600 -- pytest --junitxml=test-results/junit.xml
