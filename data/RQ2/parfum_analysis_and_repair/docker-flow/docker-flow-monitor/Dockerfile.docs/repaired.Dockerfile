### ---- MKDOCS base image ----
FROM python:3.7-alpine3.10 AS build

ENV MKDOCS_VERSION="1.0.4" \
    GIT_REPO='false' \
    LIVE_RELOAD_SUPPORT='false'

RUN \
    apk add --update --no-cache  \
        ca-certificates \
        bash \
        git \
        openssh ; \
    pip install --no-cache-dir mkdocs==${MKDOCS_VERSION} && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

RUN mkdir /workdir && cd /workdir && \
    pip install --no-cache-dir pygments pymdown-extensions && \
    mkdocs new mkdocs

ADD ./docs /workdir/mkdocs/docs
WORKDIR /workdir/mkdocs

RUN  mkdocs build --site-dir /site
### ----




### ---- NGINX ----
FROM nginx:1.11-alpine
LABEL maintainer="Viktor Farcic <viktor@farcic.com>"
LABEL maintainer="Alessandro Affinito <affinito.ale@gmail.com>"
COPY --from=build /site /usr/share/nginx/html