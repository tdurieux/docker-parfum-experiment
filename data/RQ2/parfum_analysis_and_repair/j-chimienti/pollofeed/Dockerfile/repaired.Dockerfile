FROM node:carbon
MAINTAINER joe chimienti <jchimien@gmail.com>
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
ARG PORT=4321
ENV PORT $PORT
EXPOSE $PORT

# get latest npm
RUN npm i -g npm@latest && npm cache clean --force;
RUN mkdir /pollofeed
RUN chown -R node:node /pollofeed
WORKDIR /pollofeed
USER node
COPY --chown=node:node package.json package-lock.json  ./
RUN npm install && npm cache clean --force;
COPY --chown=node:node . .
RUN npm run build
HEALTHCHECK --interval=30s CMD node healthcheck.js
CMD node ./src/www.js
