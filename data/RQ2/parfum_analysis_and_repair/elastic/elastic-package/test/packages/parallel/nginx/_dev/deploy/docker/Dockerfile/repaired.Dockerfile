ARG SERVICE_VERSION=${SERVICE_VERSION:-1.19.5}
FROM nginx:${SERVICE_VERSION}
RUN sed -i "/jessie-updates/d" /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK --interval=1s --retries=90 CMD curl -f http://localhost/server-status
COPY ./nginx.conf /etc/nginx/
