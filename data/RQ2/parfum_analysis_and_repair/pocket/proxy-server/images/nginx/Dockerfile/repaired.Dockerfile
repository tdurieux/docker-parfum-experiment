FROM nginx:1.21

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf
