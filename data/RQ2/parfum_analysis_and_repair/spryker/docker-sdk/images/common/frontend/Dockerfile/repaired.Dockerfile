# syntax = docker/dockerfile:experimental
# For brotli support you can use something like fholzer/nginx-brotli:v1.18.0
ARG SPRYKER_FRONTEND_IMAGE=nginx:alpine

FROM ${SPRYKER_FRONTEND_IMAGE} as frontend-basic

RUN mkdir -p /etc/nginx/template/ && chmod 0777 /etc/nginx/template/
COPY --chown=root:root nginx/nginx.original.conf /etc/nginx/nginx.conf
COPY --chown=root:root nginx/conf.d/frontend.default.conf.tmpl /etc/nginx/template/default.conf.tmpl
COPY --chown=root:root nginx/conf.d/resolver.conf.tmpl /etc/nginx/template/resolver.conf.tmpl
COPY --chown=root:root nginx/auth /etc/nginx/auth
COPY --chown=root:root nginx/entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENV SPRYKER_DNS_RESOLVER_FLAGS="valid=10s ipv6=off"
ENV SPRYKER_DNS_RESOLVER_IP=""

# Build info