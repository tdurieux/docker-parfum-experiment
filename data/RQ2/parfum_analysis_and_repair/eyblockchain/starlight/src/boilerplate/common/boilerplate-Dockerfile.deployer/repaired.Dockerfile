FROM node:12.18

WORKDIR /app

RUN apt-get update -y && apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;

COPY ./package.json ./package-lock.json ./
COPY entrypoint.sh entrypoint.sh
COPY contracts contracts
COPY migrations migrations
COPY truffle-config.js truffle-config.js
RUN chmod +x entrypoint.sh
RUN npm ci
ENTRYPOINT ["./entrypoint.sh"]
