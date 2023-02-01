FROM node:9 AS build
WORKDIR /srv
ADD package.json .
RUN npm install && npm cache clean --force;

FROM node:9-slim
COPY --from=build /srv .
ADD ./watch-npm.js watch-npm.js
ADD ./lib/changelog.js lib/changelog.js
ADD ./lib/npm-discovery.js lib/npm-discovery.js
CMD ["node", "watch-npm.js"]
