ARG SERVICE_VERSION=${SERVICE_VERSION:-2.4.46}
FROM httpd:$SERVICE_VERSION
RUN sed -i "/jessie-updates/d" /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK --interval=1s --retries=90 CMD curl -f http://localhost
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf