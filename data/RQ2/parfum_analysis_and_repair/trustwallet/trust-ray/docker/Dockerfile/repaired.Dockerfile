FROM ubuntu:17.04

COPY ./entrypoints /entrypoints

WORKDIR /opt/server

RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl git make && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && npm install -g npm@5.6 && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD /entrypoints/run
