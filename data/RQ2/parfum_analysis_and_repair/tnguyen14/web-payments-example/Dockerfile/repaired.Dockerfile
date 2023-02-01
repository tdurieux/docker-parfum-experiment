FROM mhart/alpine-node:6.3

RUN addgroup -S app && adduser -S -g app app

COPY package.json /src/
RUN chown -R app:app /src/

USER app
WORKDIR /src
RUN npm install && npm cache clean --force;

USER root
COPY . /src/
RUN chown -R app:app /src/*

USER app
CMD ["npm", "start"]

