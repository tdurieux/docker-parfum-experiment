FROM node:13-alpine AS ui-build

COPY frontend /src

RUN cd /src && \
    yarn config set network-timeout 300000 && \
    yarn install && \
    yarn build && yarn cache clean;

FROM python:3.6-alpine

COPY requirements*.txt /tmp/

RUN apk add --no-cache --virtual .build-deps g++ musl-dev make postgresql-dev && \
    apk add --no-cache libpq &&\
    pip install --disable-pip-version-check --no-cache-dir -r /tmp/requirements.txt \
    -r /tmp/requirements-postgres.txt && \
    apk del .build-deps && \
    rm /tmp/requirements*.txt && \
    mkdir /app

COPY --chown=1001 rfhub2 /app/rfhub2
COPY --chown=1001 --from=ui-build /src/build /app/rfhub2/static

RUN mv /app/rfhub2/static/index.html /app/rfhub2/templates/index.html

WORKDIR /app

USER 1001

CMD ["python", "-m", "rfhub2"]