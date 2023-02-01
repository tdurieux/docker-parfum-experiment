ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}
RUN sed -i "/jessie-updates/d" /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK --interval=1s --retries=90 CMD curl -f http://localhost/nginx_status
COPY ./nginx.conf /etc/nginx/
