FROM node:16-slim AS build
ENV NODE_ENV production

WORKDIR /ril
COPY . /ril/

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN yarn workspaces focus @ril/api \
  && yarn workspaces foreach -ptR --from @ril/api run build && yarn cache clean;

# ---

FROM node:16-slim AS production
WORKDIR /ril

COPY --from=build /ril .

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libssl-dev && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "yarn", "workspace", "@ril/api", "run", "start" ]
