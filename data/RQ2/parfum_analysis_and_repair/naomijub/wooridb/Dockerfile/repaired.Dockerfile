FROM rust:latest
RUN apt-get update && apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

ADD https://github.com/naomijub/wooridb/archive/0.1.6.tar.gz /
RUN tar -zxvf 0.1.6.tar.gz && rm 0.1.6.tar.gz
WORKDIR /wooridb-0.1.6
RUN rm -rf book/ woori-db/data/ benches/ data/*.txt

EXPOSE 1438

ENTRYPOINT [ "make" ]