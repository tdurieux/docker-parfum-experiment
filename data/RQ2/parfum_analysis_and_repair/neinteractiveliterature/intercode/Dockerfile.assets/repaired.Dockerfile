ARG BASEIMAGE

FROM ${BASEIMAGE} as code
# Make assets readable
USER root
RUN chown root.root -R /usr/src/intercode/public

# Copy into http server
FROM nginx
RUN  rm /usr/share/nginx/html/index.*
COPY --from=code /usr/src/intercode/public /usr/share/nginx/html
RUN chown www-data.root -R /usr/share/nginx/html
COPY nginx-assets.conf /etc/nginx/conf.d/default.conf