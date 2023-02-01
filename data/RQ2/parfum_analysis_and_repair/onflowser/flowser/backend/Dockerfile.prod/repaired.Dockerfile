FROM ubuntu:20.04 as production

WORKDIR /app

RUN apt-get update
RUN apt-get -yq --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -yq --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;
# version v0.28.4 breaks storage script logic
RUN curl -f https://storage.googleapis.com/flow-cli/install.sh > /tmp/install.sh && sh /tmp/install.sh v0.28.3
ENV PATH="$PATH:/root/.local/bin:/app/data-storage"

COPY package*.json ./

RUN npm install --silent glob rimraf && npm cache clean --force;
RUN npm install && npm cache clean --force;

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

COPY . .

CMD ["npm", "run", "start"]
