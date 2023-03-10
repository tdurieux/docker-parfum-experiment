FROM debian:stable AS dependencies

RUN apt-get update -y && \
 apt-get install --no-install-recommends -y build-essential curl git && \
 curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
 apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

FROM dependencies AS modules

WORKDIR /app

COPY ./package*.json ./
RUN npm install --production && npm cache clean --force;

FROM modules AS app

WORKDIR /app

COPY . .

EXPOSE 4000

CMD ["npm", "run", "prod:start-app"]
