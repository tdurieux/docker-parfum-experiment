FROM debian:jessie

ENV POSTGREST_VERSION 0.3.1.1
RUN apt-get update && \
    apt-get install --no-install-recommends -y tar xz-utils wget libpq-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://github.com/begriffs/postgrest/releases/download/v${POSTGREST_VERSION}/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz && \
    tar --xz -xvf postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz && \
    mv postgrest /usr/local/bin/postgrest && \
    rm postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz

ENTRYPOINT ["/usr/local/bin/postgrest", "-p", "9441", "-a", "postgres"]
EXPOSE 9441
