FROM ubuntu:latest

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl \
                        git \
                        cmake \
                        make \
                        automake \
                        autoconf \
                        python \
                        g++ \
                        zlib1g-dev && rm -rf /var/lib/apt/lists/*;


RUN curl -f https://dl.eventql.io/eventql/v0.4.0-rc0/eventql-0.4.0-rc0-linux_x86_64.tgz | tar xvz

RUN mkdir -p /var/evql

RUN groupadd -r eventql && useradd -r -g eventql eventql

EXPOSE 9175
USER  eventql
ENTRYPOINT ["/usr/local/bin/evqld",  "--datadir", "/var/evql"]
CMD ["--standalone"]
