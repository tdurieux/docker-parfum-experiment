FROM node:15.12.0 as node

COPY . .

FROM node as test-npm
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run test

FROM node as test-yarn
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY . .
RUN yarn run test