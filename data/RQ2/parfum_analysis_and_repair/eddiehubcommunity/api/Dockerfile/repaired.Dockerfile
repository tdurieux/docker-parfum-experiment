FROM node:15 as development
LABEL org.opencontainers.image.source https://github.com/eddiehubcommunity/api
ARG github_token

WORKDIR /usr/src/app


COPY package*.json ./

RUN npm install --ignore-scripts && npm cache clean --force;
RUN rm -f .npmrc

COPY . .

RUN npm run build

FROM node:15 as production
LABEL org.opencontainers.image.source https://github.com/eddiehubcommunity/api
ARG github_token
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --production --ignore-scripts && npm cache clean --force;

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD ["npm", "run", "start:prod"]

