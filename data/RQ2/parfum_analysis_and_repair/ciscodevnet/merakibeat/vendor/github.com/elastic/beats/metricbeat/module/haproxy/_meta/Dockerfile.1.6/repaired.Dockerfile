FROM haproxy:1.6
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK --interval=1s --retries=90 CMD nc -z localhost 14567
COPY ./haproxy.conf /usr/local/etc/haproxy/haproxy.cfg
EXPOSE 14567
