### ---- MKDOCS base image ----
FROM alpine:latest AS build

ENV MKDOCS_VERSION="1.0.4" \
    GIT_REPO='false' \
    LIVE_RELOAD_SUPPORT='false' \
    PYTHON_VERSION='2'

RUN \
    apk add --update --no-cache  \
        ca-certificates \
        bash \
        git \
        openssh \
        linux-headers \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        py-setuptools; \
    easy_install-2.7 pip && \
    pip install --no-cache-dir mkdocs==${MKDOCS_VERSION} && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

RUN mkdir /workdir && cd /workdir && \
    pip install --no-cache-dir pygments pymdown-extensions && \
    mkdocs new mkdocs

ADD ./docs /workdir/mkdocs/docs
RUN cd mkdocs  &&  mkdocs build --site-dir /site

WORKDIR /workdir/mkdocs



### ---- NGINX ----
FROM nginx:1.11-alpine
LABEL maintainer="Viktor Farcic <viktor@farcic.com>"
LABEL maintainer="Alessandro Affinito <affinito.ale@gmail.com>"
COPY --from=build /site /usr/share/nginx/html