FROM node:8.9.4

WORKDIR /usr/src/app

COPY package*.json ./

RUN docker -d &
RUN npm config set strict-ssl false
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm cache verify
RUN npm install -g -D ember-cli && npm cache clean --force;
RUN npm config set registry=https://registry.npmjs.com/
RUN npm install -D && npm cache clean --force;

COPY . .

EXPOSE 4200

CMD ["ember", "serve"]
