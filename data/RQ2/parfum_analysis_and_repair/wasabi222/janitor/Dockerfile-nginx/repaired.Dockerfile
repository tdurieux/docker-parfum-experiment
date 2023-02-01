FROM nginx:1.17.3

RUN apt-get update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

RUN rm /etc/nginx/conf.d/default.conf

COPY ./app/static /opt/janitor/app/static

COPY ./docker/nginx.conf /etc/nginx/conf.d/nginx.conf
