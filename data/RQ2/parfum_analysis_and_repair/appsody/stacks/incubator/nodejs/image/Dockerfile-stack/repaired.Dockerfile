FROM node:12

ENV APPSODY_MOUNTS=/:/project/user-app
ENV APPSODY_DEPS=/project/user-app/node_modules
ENV APPSODY_PROJECT_DIR=/project

ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_IGNORE_DIR=/project/user-app/node_modules
ENV APPSODY_WATCH_REGEX="^.*.js$"

ENV APPSODY_PREP="npm install && npm run build --if-present"

ENV APPSODY_RUN="npm start --node-options --require=appmetrics-dash/attach"
ENV APPSODY_RUN_ON_CHANGE="npm start --node-options --require=appmetrics-dash/attach"
ENV APPSODY_RUN_KILL=true

ENV APPSODY_DEBUG="npm start --node-options --inspect=0.0.0.0 --require=appmetrics-dash/attach"
ENV APPSODY_DEBUG_ON_CHANGE="npm start --node-options --inspect=0.0.0.0 --require=appmetrics-dash/attach"
ENV APPSODY_DEBUG_KILL=true

ENV APPSODY_TEST="npm test"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=false

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config

WORKDIR /project
RUN npm install && npm cache clean --force;

WORKDIR /project/user-app

ENV PORT=3000
ENV APPSODY_DEBUG_PORT=9229

EXPOSE 3000
EXPOSE 9229
