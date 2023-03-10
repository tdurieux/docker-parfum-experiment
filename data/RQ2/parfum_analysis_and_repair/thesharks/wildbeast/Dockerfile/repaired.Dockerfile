FROM node:lts-alpine
ARG COMMIT

WORKDIR /usr/wildbeast

COPY tsconfig.json ./
COPY package*.json ./
COPY src ./src

ENV GIT_COMMIT ${COMMIT}

RUN npm install && npm cache clean --force;
RUN npm prune --production

CMD ["npm", "start"]
