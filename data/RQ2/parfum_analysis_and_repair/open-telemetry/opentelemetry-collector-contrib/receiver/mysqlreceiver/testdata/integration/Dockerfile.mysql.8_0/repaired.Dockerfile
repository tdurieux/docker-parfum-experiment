FROM mysql:8.0.27

RUN \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29 && \
    apt-get update && \
    apt-get install --no-install-recommends -y libmariadb3 && rm -rf /var/lib/apt/lists/*;

COPY scripts/setup.sh /setup.sh
RUN chmod +x /setup.sh

ENV MYSQL_DATABASE=otel
ENV MYSQL_USER=otel
ENV MYSQL_PASSWORD=otel
ENV MYSQL_ROOT_PASSWORD=otel
