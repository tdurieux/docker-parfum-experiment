# Run with:
# $ npm run eval-firebase-dumps-in-docker

FROM node:10
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
ENTRYPOINT node ./src/evaluateGroupFile.js $FILEPATH
