# Install deps
FROM node:16 AS base
WORKDIR /base
COPY . .
RUN yarn install --frozen-lockfile && yarn cache clean;

# Build app
FROM base AS build
ENV NODE_ENV=production
WORKDIR /build
COPY --from=base /base ./
RUN yarn run build
RUN yarn install --production --ignore-scripts --prefer-offline && yarn cache clean;

# Create production container
FROM node:16 AS production
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /build/package.json /build/yarn.lock /build/server.js ./
# Need to add dummy RUN statements so Docker doesn't crash...
# Ref. https://github.com/moby/moby/issues/37965
RUN true
COPY --from=build /build/next.config.js ./
RUN true
COPY --from=build /build/yarn.lock ./
RUN true
COPY --from=build /build/.next ./.next
RUN true
COPY --from=build /build/public ./public
RUN true
COPY --from=build /build/node_modules ./node_modules
RUN yarn cache clean

# Running the app
EXPOSE 3000
CMD [ "yarn", "start" ]
