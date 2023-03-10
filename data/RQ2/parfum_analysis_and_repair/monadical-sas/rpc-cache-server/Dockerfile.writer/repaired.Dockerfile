FROM node:16-buster

ARG port=3001

WORKDIR /app
COPY ./package.json /app/

RUN npm install && npm cache clean --force;

COPY . /app/

EXPOSE $port

# Command can be overwritten by providing a different command in the template directly.
CMD ["node", "dist/writer/index.js"]