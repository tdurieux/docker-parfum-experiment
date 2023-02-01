FROM node:15

# Create app directory
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl unzip jq && \
    npm install -g typescript && \
    npm install -g ts-node && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000

ADD run.sh /

ENTRYPOINT [ "/run.sh" ]