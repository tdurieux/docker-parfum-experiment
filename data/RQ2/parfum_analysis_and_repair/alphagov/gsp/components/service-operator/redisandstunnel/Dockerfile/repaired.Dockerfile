FROM redis
RUN apt-get update && apt-get install --no-install-recommends -y stunnel && apt-get purge && apt-get autoremove && rm -rf /var/lib/apt/lists/*;
COPY stunnel.conf /etc/stunnel/redis-cli.conf
