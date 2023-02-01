#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/nginx-dev:ubuntu-14.04
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/nginx:ubuntu-14.04

ENV WEB_NO_CACHE_PATTERN="\.(css|js|gif|png|jpg|svg|json|xml)$"

COPY conf/ /opt/docker/

EXPOSE 80 443
