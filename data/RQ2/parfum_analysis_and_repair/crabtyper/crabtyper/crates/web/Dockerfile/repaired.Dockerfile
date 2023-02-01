FROM rust:latest

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/crabtyper-web

COPY . .

RUN npm install && npm cache clean --force;

RUN npm run setup

CMD [ "npm", "run", "prod" ]
