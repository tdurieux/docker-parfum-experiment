FROM appsody/nodejs-express:0.3

ENV APPSODY_MOUNTS=/:/project/user-app/functions
ENV APPSODY_DEPS=/project/user-app/functions/node_modules

ENV APPSODY_WATCH_DIR=/project/user-app/functions
ENV APPSODY_WATCH_IGNORE_DIR=/project/user-app/functions/node_modules

ENV APPSODY_PREP="npm install --prefix user-app/functions && npm audit fix --prefix user-app/functions"

ENV APPSODY_RUN="npm start"
ENV APPSODY_RUN_ON_CHANGE="npm start"
ENV APPSODY_RUN_KILL=true

ENV APPSODY_DEBUG="npm run debug"
ENV APPSODY_DEBUG_ON_CHANGE="npm run debug"
ENV APPSODY_DEBUG_KILL=true

ENV APPSODY_TEST="npm test && npm test --prefix user-app/functions"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=false

COPY ./LICENSE /licenses/
COPY ./project /project/user-app
COPY ./config /config
WORKDIR /project
RUN npm install && npm audit fix && npm cache clean --force;

ENV PORT=3000
ENV NODE_PATH=/project/user-app/functions/node_modules

EXPOSE 3000
EXPOSE 9229
