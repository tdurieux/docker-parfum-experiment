FROM nginx:1.13.7

RUN apt-get update && apt-get install --no-install-recommends -y unzip procps && rm /etc/nginx/conf.d/default.conf && rm -rf /var/lib/apt/lists/*;