FROM timescale/timescaledb-ha:pg13-latest
USER root
ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB starter_kit
COPY scripts/* /docker-entrypoint-initdb.d/
RUN apt-get update \
    && apt-get install --no-install-recommends -y wget unzip; rm -rf /var/lib/apt/lists/*; \
    wget https://assets.timescale.com/docs/downloads/nft_sample.zip; \
    unzip nft_sample.zip; \
    rm nft_sample.zip;
USER postgres