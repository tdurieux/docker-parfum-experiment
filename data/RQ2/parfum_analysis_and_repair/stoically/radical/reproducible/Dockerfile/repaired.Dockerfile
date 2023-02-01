FROM node:13-slim

RUN apt-get update -y && apt-get install --no-install-recommends -y git python3 make wget unzip jq && rm -rf /var/lib/apt/lists/*;

RUN mkdir /build
WORKDIR /build
COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/build" ]
ENTRYPOINT [ "/entrypoint.sh" ]