# spin up nginx with custom conf
FROM nginx:1.19.4
MAINTAINER David Wharton

ARG DALTON_EXTERNAL_PORT
ARG DALTON_EXTERNAL_PORT_SSL

RUN rm /etc/nginx/nginx.conf && rm -rf /etc/nginx/conf.d
COPY nginx-conf/nginx.conf /etc/nginx/nginx.conf
COPY nginx-conf/conf.d /etc/nginx/conf.d
COPY nginx-conf/tls /etc/nginx/tls

# adjust nginx config so redirects point to external port(s).
# order of sed operations matters since one replaced string is a subset of the other.