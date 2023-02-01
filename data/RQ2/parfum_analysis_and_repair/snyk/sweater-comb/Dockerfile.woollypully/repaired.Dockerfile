FROM node:14-alpine AS build-env
WORKDIR /sweater-comb
COPY ["package.json", "yarn.lock", "./"]
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

FROM node:14-alpine AS clean-env
COPY --from=build-env /sweater-comb/build/ /sweater-comb/
COPY --from=build-env /sweater-comb/babel.config.js /sweater-comb/
COPY --from=build-env /sweater-comb/package*.json /sweater-comb/
WORKDIR /sweater-comb
RUN yarn install --production && yarn cache clean;

FROM gcr.io/distroless/nodejs-debian11
ENV NODE_ENV production
COPY --from=clean-env /sweater-comb/ /sweater-comb/
WORKDIR /sweater-comb
USER 1000
ENTRYPOINT ["/nodejs/bin/node", "woollypully/index.js"]
