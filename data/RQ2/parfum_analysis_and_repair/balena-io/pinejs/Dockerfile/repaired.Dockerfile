FROM node:16-alpine as runner

WORKDIR /usr/src/pine

COPY . ./
RUN npm install && npm cache clean --force;


FROM runner as sut
CMD npm run mocha

FROM runner


