FROM node:14.15.0

WORKDIR /app
COPY . /app

RUN npm install && npm cache clean --force;
RUN JOBS=max PATH=$(npm bin):$PATH node-pre-gyp rebuild
CMD npm run test
