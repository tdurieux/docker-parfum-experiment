FROM node:10

RUN apt-get update && apt-get install --no-install-recommends -y wget mysql-client && rm -rf /var/lib/apt/lists/*;

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /usr/idexd/
COPY package*.json ./
RUN npm install -g pm2 && npm cache clean --force;
RUN npm install -g sequelize && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY . .
RUN mkdir lib
RUN npm run build

EXPOSE 8080

ENTRYPOINT [ "pm2" ]