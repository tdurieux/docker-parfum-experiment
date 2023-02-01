FROM phusion/baseimage:0.9.19

COPY scripts /root/scripts/

RUN apt-get update && apt-get install --no-install-recommends -y letsencrypt && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT bash -c "bash /root/scripts/run-certbot.sh && sleep infinity"
