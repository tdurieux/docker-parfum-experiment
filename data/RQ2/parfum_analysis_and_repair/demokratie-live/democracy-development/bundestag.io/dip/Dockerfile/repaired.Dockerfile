FROM node:14-alpine AS base_stage
WORKDIR /app

FROM base_stage as build_stage
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

FROM base_stage as production_stage
ENV NODE_ENV=production
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean;
COPY --from=build_stage /app/build ./build
ENTRYPOINT [ "yarn", "run", "start" ]

