FROM node:lts-jessie

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app
RUN npm install -g yarn && npm cache clean --force;
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

# Bundle app source
COPY . /usr/src/app/

# Install app dependencies

#EXPOSE 7500

CMD dockerize -wait http://elasticsearch:9200 -timeout 5m yarn start:prod
