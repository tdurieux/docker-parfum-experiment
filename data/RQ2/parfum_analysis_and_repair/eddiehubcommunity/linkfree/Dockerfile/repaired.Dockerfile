FROM node:15 as development
LABEL org.opencontainers.image.source https://github.com/eddiehubcommunity/LinkFree

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --ignore-scripts && npm cache clean --force;
COPY . .

RUN sed -i 's/0.0.0/'`npm -s run env echo '$npm_package_version'`'/g' public/app.json
RUN npm run build

FROM node:15 as production
LABEL org.opencontainers.image.source https://github.com/eddiehubcommunity/LinkFree

ARG NODE_ENV=production

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --production --ignore-scripts && npm cache clean --force;
COPY . .
COPY --from=development /usr/src/app/build ./build
CMD ["npm", "run", "start:prod"]
