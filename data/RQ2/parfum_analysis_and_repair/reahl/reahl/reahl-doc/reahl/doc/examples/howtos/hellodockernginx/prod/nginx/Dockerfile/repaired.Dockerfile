FROM nginx:1.19

RUN apt-get update && \
    apt-get install -y --no-install-recommends ssl-cert && \
    rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;
COPY prod/nginx/app.conf /etc/nginx/conf.d/default.conf