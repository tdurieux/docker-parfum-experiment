FROM node:12-slim as build

RUN apt-get update \
	&& apt-get -y --no-install-recommends install git \
	&& rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

COPY . /app
WORKDIR /app
RUN rm -rf node_modules
RUN yarn install && yarn cache clean;
RUN yarn gulp build && yarn cache clean;
RUN rm -rf node_modules
RUN yarn install --prod && yarn cache clean;

# ---------------------
# Final
FROM node:12-slim

LABEL maintainer="Jamie Curnow <jc@jc21.com>"
ENV NODE_ENV=production

RUN apt-get update \
	&& apt-get -y --no-install-recommends install curl \
	&& rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

COPY --from=build /app/config/default.json /app/config/default.json
COPY --from=build /app/dist                /app/dist
COPY --from=build /app/node_modules        /app/node_modules
COPY --from=build /app/views               /app/views
COPY --from=build /app/knexfile.js         /app/knexfile.js
COPY --from=build /app/package.json        /app/package.json
COPY --from=build /app/src/backend         /app/src/backend

WORKDIR /app

CMD node src/backend/index.js

HEALTHCHECK --interval=15s --timeout=3s CMD curl -f http://localhost/ || exit 1
