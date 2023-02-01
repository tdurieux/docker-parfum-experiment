FROM haproxy:2.4

EXPOSE 80 443

ENV MODULE_NAME haproxy
USER root

ADD modules/${MODULE_NAME}/config /config
ADD modules/${MODULE_NAME}/script/init_container.sh /usr/local/bin/init_container

RUN apt-get update -y && apt-get install --no-install-recommends -y \
        supervisor \
        net-tools && rm -rf /var/lib/apt/lists/*;

RUN chmod 500 /usr/local/bin/init_container && \
    chmod -R 400 /config

CMD ["/usr/local/bin/init_container"]
