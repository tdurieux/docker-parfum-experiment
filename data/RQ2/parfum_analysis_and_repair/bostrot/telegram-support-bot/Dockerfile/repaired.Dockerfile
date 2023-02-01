FROM node:16-alpine
WORKDIR /bot

COPY . /bot

RUN apk update
RUN apk add --no-cache wget python3 build-base
RUN npm install && npm cache clean --force;

CMD ["npm", "run", "prod", "--prefix", "/bot"]
