FROM python:3.9.1-alpine3.12

ARG git_version

COPY . /manheim_c7n_tools
RUN cd /manheim_c7n_tools \
  && apk add --no-cache bash git curl \
  && apk add --no-cache --virtual .build-deps \
      gcc \
      linux-headers \
      make \
      musl-dev \
      libffi-dev \
      openssl-dev \
  && pip install --no-cache-dir -r requirements.txt \
  && pip install --no-cache-dir -e . \
  # clean up build dependencies
  && apk del .build-deps \
  && rm -Rf /root/.cache

LABEL com.manheim.commit=$git_version \
      org.opencontainers.image.revision=$git_version \
      com.manheim.repo="https://github.com/manheim/manheim-c7n-tools.git" \
      org.opencontainers.image.source="https://github.com/manheim/manheim-c7n-tools.git" \
      org.opencontainers.image.url="https://github.com/manheim/manheim-c7n-tools" \
      org.opencontainers.image.authors="man-releaseengineering@manheim.com"
