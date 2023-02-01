FROM node:16-bullseye AS builder

WORKDIR /action

COPY package.json yarn.lock  ./

RUN yarn && yarn cache clean;
COPY src ./src
COPY tsconfig.json ./
RUN yarn build && yarn cache clean;
RUN rm -rf node_modules
RUN yarn install --production && yarn cache clean;

# ---

FROM node:16-bullseye AS final

COPY --from=builder /action /action

CMD node /action/dist/main.js
