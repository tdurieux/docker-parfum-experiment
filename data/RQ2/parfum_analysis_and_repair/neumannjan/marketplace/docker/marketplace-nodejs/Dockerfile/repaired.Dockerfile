FROM node:9.5-stretch

RUN apt-get update && apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;

COPY laravel-echo-server.conf /etc/supervisor/conf.d
COPY entrypoint.sh /

ENTRYPOINT /bin/bash /entrypoint.sh
