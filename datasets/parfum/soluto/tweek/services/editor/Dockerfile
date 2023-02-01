# ---- Deps ----
FROM node:16.0.0-alpine AS dependencies
WORKDIR /opt/app/
COPY package.json yarn.lock ./
RUN yarn --production --network-timeout 1000000

# ---- Build ----
FROM dependencies AS build

RUN yarn --prefer-offline

COPY . .
RUN CI=true yarn test && yarn build

# ---- Release ----
FROM dependencies AS release

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

COPY --from=build /opt/app/build/ ./build
COPY --from=build /opt/app/index.js ./index.js

VOLUME [ "/opt/app/build/config" ]

HEALTHCHECK --interval=10s --timeout=10s --retries=8 \
      CMD wget -O - http://localhost:3000/health || exit 1

CMD node index.js
