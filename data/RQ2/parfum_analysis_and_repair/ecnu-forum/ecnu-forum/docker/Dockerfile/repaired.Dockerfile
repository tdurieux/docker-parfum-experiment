# alpine based image
FROM mondedie/flarum:1.2.0 AS base

LABEL version="1.0"
LABEL description="flarum custom image"
LABEL maintainer="oceanlvr"

WORKDIR /flarum/app

COPY .nginx.conf .nginx.conf
COPY extend.php extend.php
COPY flarum flarum
COPY site.php site.php

# composer file