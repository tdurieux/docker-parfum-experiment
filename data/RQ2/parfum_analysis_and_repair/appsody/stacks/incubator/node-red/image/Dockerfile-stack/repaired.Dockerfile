FROM node:12

ENV APPSODY_MOUNTS=/:/project/user-app
ENV APPSODY_DEPS=/project/user-app/node_modules

ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_IGNORE_DIR=/project/user-app/node_modules
ENV APPSODY_WATCH_REGEX="^.*.json$"

ENV APPSODY_INSTALL="npm install --prefix user-app"

ENV APPSODY_RUN="npm start"
ENV APPSODY_RUN_ON_CHANGE="npm start"
ENV APPSODY_RUN_KILL=true

ENV APPSODY_DEBUG="npm run debug"
ENV APPSODY_DEBUG_ON_CHANGE="npm run debug"
ENV APPSODY_DEBUG_KILL=true

ENV APPSODY_TEST="npm test"

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config
WORKDIR /project
RUN npm install && npm cache clean --force;

ENV PORT=3000
ENV NODE_PATH=/project/user-app/node_modules

EXPOSE 3000
EXPOSE 9229
