<% | String $git_url | -%>
FROM nginx:1.13.3-alpine
RUN apk update \
  && apk add --no-cache git \
  && cd /usr/share/nginx \
  && mv html html.orig \
  && git clone <%= $git_url %> html

LABEL org.label-schema.vendor="Bitfield Consulting" \
  org.label-schema.url="http://bitfieldconsulting.com" \
  org.label-schema.name="Nginx Git Website" \
  org.label-schema.version="1.0.0" \
  org.label-schema.vcs-url="github.com:bitfield/puppet-beginners-guide.git" \
  org.label-schema.docker.schema-version="1.0"
