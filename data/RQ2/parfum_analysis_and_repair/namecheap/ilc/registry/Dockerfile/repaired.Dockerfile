FROM node:16-alpine

RUN apk --no-cache add --virtual builds-deps build-base python3 && \
    ln -sf python3 /usr/bin/python

# Legacy infrastructure support
RUN npm install -g stdout-mq@^2.4.0 && npm cache clean --force;

WORKDIR /codebase

COPY package-lock.json package.json /codebase/
RUN npm ci --no-package-lock --ignore-scripts
RUN npm rebuild bcrypt --build-from-source
RUN npm rebuild @vscode/sqlite3
RUN npm rebuild @newrelic/native-metrics
RUN npm install mysql && npm cache clean --force;

COPY client/package-lock.json client/package.json /codebase/client/
RUN cd ./client && npm ci --ignore-scripts

ADD ./ /codebase

RUN npm run build

CMD ["npm", "run", "start-docker"]
