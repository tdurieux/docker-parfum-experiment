FROM debian:jessie
RUN apt-get -q update && \
    apt-get -qy --no-install-recommends install python squid3 curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN sed -i "s/^#acl localnet/acl localnet/" /etc/squid3/squid.conf
RUN sed -i "s/^#http_access allow localnet/http_access allow localnet/" /etc/squid3/squid.conf
RUN mkdir -p /var/cache/squid3
RUN mv /etc/squid3/squid.conf /etc/squid3/squid.conf.in
RUN chown -R proxy:proxy /var/cache/squid3
RUN curl -sL --insecure -o /bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64
RUN chmod +x /bin/dumb-init
ADD deploy_squid.py /tmp/deploy_squid.py

ENTRYPOINT ["/bin/dumb-init"]

# Use unbuffered IO so output displays in docker-compose
CMD ["python", "-u", "/tmp/deploy_squid.py"]
