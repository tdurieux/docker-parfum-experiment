FROM ubuntu

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;
