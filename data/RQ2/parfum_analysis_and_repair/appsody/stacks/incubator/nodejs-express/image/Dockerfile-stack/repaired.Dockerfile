FROM appsody/nodejs:0.3

ENV APPSODY_PROJECT_DIR=/project
ENV APPSODY_MOUNTS=/:/project/user-app
ENV APPSODY_DEPS=/project/user-app/node_modules

ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_IGNORE_DIR=/project/user-app/node_modules
ENV APPSODY_WATCH_REGEX="^.*.js$"

ENV APPSODY_PREP="npm install --prefix user-app"

ENV APPSODY_RUN="npm start"
ENV APPSODY_RUN_ON_CHANGE="npm start"
ENV APPSODY_RUN_KILL=true

ENV APPSODY_DEBUG="npm run debug"
ENV APPSODY_DEBUG_ON_CHANGE="npm run debug"
ENV APPSODY_DEBUG_KILL=true

ENV APPSODY_TEST="npm test && npm test --prefix user-app"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=false

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config
WORKDIR /project
RUN npm install && npm cache clean --force;

ENV PORT=3000
ENV APPSODY_DEBUG_PORT=9229
ENV NODE_PATH=/project/user-app/node_modules

EXPOSE 3000
EXPOSE 9229
