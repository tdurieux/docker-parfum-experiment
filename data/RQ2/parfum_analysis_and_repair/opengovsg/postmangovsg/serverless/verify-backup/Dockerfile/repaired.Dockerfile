FROM node:12-alpine

RUN apk update && apk upgrade
RUN apk add --no-cache postgresql
RUN apk add --no-cache curl

WORKDIR /usr/home/postmangovsg

COPY ./package* ./
RUN npm ci

COPY src ./src
COPY scripts ./scripts
COPY tsconfig.json ./

RUN npm run build
RUN npm prune --production

ENTRYPOINT ["sh", "scripts/run.sh"]
