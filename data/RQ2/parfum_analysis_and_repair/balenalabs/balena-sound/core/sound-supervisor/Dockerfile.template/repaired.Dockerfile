FROM balenalib/%%BALENA_ARCH%%-node:14 as build

WORKDIR /usr/src
COPY core/sound-supervisor/package*.json ./
RUN npm install && npm cache clean --force;

#dev-cmd-live=npm run livepush

COPY core/sound-supervisor/src ./src
COPY core/sound-supervisor/tsconfig.json .
RUN npm run build
COPY VERSION .

FROM node:14-alpine3.14

WORKDIR /usr/src

COPY core/sound-supervisor/package*.json ./
COPY --from=build /usr/src/build ./build
COPY VERSION .

RUN npm install --production && npm cache clean --force;

CMD [ "npm", "start" ]
