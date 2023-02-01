FROM node:12-buster

RUN apt-get update
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y uuid-runtime && rm -rf /var/lib/apt/lists/*;
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
