FROM phusion/baseimage:latest

MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>

COPY run-certbot.sh /root/certbot/run-certbot.sh

RUN apt-get update && apt-get install --no-install-recommends -y letsencrypt && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT bash -c "bash /root/certbot/run-certbot.sh && sleep infinity"
