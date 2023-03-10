ARG FROM_TAG=release-alpine
FROM ponylang/ponyc:${FROM_TAG}

RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache \
  bash \
  git-fast-import \
  libffi \
  libffi-dev \
  libressl \
  libressl-dev \
  python3 \
  python3-dev \
  py3-pip \
  && pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir mkdocs \
  && pip3 install --no-cache-dir mkdocs-ponylang
