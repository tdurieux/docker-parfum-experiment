FROM nginx

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

COPY ./static /usr/share/nginx/html
COPY ./dc.conf /etc/nginx/conf.d/default.conf
