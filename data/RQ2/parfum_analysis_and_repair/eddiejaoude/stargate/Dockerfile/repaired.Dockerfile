FROM node:15 As development
LABEL org.opencontainers.image.source https://github.com/eddiejaoude/stargate

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=development && npm cache clean --force;

COPY . .

RUN npm run build

FROM node:15 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
ENV HUSKY=0
ENV VERSION="v0.0.0"

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD ["npm", "run", "start:prod"]
