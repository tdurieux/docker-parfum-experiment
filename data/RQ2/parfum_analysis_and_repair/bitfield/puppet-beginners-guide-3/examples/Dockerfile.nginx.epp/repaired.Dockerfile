<% | String $message | -%>
FROM nginx:1.13.3-alpine
RUN echo "<%= $message %>" >/usr/share/nginx/html/index.html

LABEL org.label-schema.vendor="Bitfield Consulting" \
  org.label-schema.url="http://bitfieldconsulting.com" \
  org.label-schema.name="Nginx Dynamic Message" \
  org.label-schema.version="1.0.0" \
  org.label-schema.vcs-url="github.com:bitfield/puppet-beginners-guide.git" \
  org.label-schema.docker.schema-version="1.0"