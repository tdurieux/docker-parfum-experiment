FROM node:12 as build
WORKDIR /build

COPY ./package.json ./package-lock.json ./
RUN NPM_CONFIG_LOGLEVEL=warn npm install && npm cache clean --force;

COPY ./ ./
RUN NODE_ENV=production npm run build


FROM node:12
ENV NODE_ENV production
CMD ["node", "./server/localserver.js"]
WORKDIR /opt/app

COPY ./package.json ./package-lock.json ./
RUN NPM_CONFIG_LOGLEVEL=warn npm install --production && npm cache clean --force;
COPY --from=build /build/build/ ./

