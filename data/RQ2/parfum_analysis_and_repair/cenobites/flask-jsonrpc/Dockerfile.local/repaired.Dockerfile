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

ARG VERSION=1
RUN echo "Version: ${VERSION}"

COPY . ./

ARG FLASK_ASYNC=0
RUN pip install --no-cache-dir pip setuptools wheel --upgrade \
    && echo "Flask Async? ${FLASK_ASYNC}" \
    && [[ ${FLASK_ASYNC} = 1 ]] && PROJECT_PATH=".[async]" || PROJECT_PATH="." \
    && pip wheel --wheel-dir=/svc/wheels -e ${PROJECT_PATH}

FROM python:3.10-alpine

ENV PYTHONUNBUFFERED=1 \
    DEBUG=0

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

ARG FLASK_ASYNC=0
RUN pip install --no-cache-dir pip setuptools wheel --upgrade \
    && echo "Flask Async? ${FLASK_ASYNC}" \
    && [[ ${FLASK_ASYNC} = 1 ]] && PIP_INSTALL_PACKAGES="Flask-JSONRPC[async]" || PIP_INSTALL_PACKAGES="Flask-JSONRPC" \
    && pip install --no-cache-dir --no-index --find-links=/svc/wheels ${PIP_INSTALL_PACKAGES} \
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

ARG VERSION=1
RUN echo "Version: ${VERSION}"

COPY .docker/* /app/
COPY tests/test_apps/app/__init__.py /app/app.py
COPY tests/test_apps/async_app/__init__.py /app/async_app.py
