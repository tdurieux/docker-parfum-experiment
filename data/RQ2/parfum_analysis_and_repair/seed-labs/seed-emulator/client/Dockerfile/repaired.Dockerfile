FROM node:14
COPY start.sh /
WORKDIR /usr/src/app
COPY . .
WORKDIR /usr/src/app/frontend
RUN npm install && npm cache clean --force;
RUN npm install -D webpack-cli && npm cache clean --force;
RUN ./node_modules/.bin/webpack --mode production
WORKDIR /usr/src/app/backend
RUN npm install && npm cache clean --force;
RUN npm install -D typescript && npm cache clean --force;
RUN ./node_modules/.bin/tsc
ENTRYPOINT ["sh", "/start.sh"]
