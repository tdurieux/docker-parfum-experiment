# Build Assets
FROM node:12 AS build

RUN mkdir /srv/bt && chown node:node /srv/bt

USER node

WORKDIR /srv/bt

COPY --chown=node:node . .

RUN npm install --quiet && npm cache clean --force;
ENV ENV prod
RUN npm run bundle


# Set up runtime container
FROM node:12 AS production

RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_85.0.4183.102-1_amd64.deb
RUN apt install --no-install-recommends -y ./google-chrome*.deb -f && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

USER node

WORKDIR /srv/bt
COPY --from=build --chown=node:node /srv/bt/ .

ENV ENV=prod

EXPOSE 8080

CMD ["node",  "./api/index.js"]
