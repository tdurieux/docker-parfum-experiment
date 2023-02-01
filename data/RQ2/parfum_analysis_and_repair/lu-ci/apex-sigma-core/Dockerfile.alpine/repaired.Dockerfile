# |-------<[ Build ]>-------|

FROM python:3.9-alpine AS build

RUN mkdir -p /build
WORKDIR /build

COPY requirements.txt ./
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    libffi-dev \
    openssl-dev \
    libxml2-dev \
    libxslt-dev \
    jpeg-dev \
    libpng-dev \
    libwebp-dev \
    freetype-dev \
    ffmpeg-dev \
    linux-headers \
 && pip install --no-cache-dir virtualenv \
 && virtualenv .venv \
 && source .venv/bin/activate \
 && pip install --no-cache-dir -r requirements.txt \
 && virtualenv --relocatable .venv \
 && sed -i -E 's|^(VIRTUAL_ENV="/)build(/.venv")$|\1app\2|' .venv/bin/activate \
 && apk del .build-deps


# |-------<[ App ]>-------|