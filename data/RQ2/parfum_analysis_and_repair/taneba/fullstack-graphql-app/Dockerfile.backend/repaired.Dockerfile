FROM node:16 as pruner
RUN apt update && \
    apt install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

RUN yarn global add turbo
WORKDIR "/app"
RUN pwd

# Prune the workspace for the backend aapp
COPY .git ./.git
COPY . .
RUN pwd
RUN turbo prune --scope=backend --docker

# Add pruned lockfile and package.json's of the pruned subworkspace
FROM pruner as builder
WORKDIR "/app"
COPY --from=pruner /app/out/json/ .
COPY --from=pruner /app/out/yarn.lock ./yarn.lock

# Install only the deps needed to build the target
RUN yarn install && yarn cache clean;
COPY --from=pruner /app/.git ./.git
COPY --from=pruner /app/out/full/ .
RUN turbo run build --scope=backend
RUN pwd
RUN ls

# Copy source code of pruned subworkspace and build
FROM node:16-alpine
WORKDIR "/app"
EXPOSE 4000
COPY --from=builder /app/apps/backend/dist/ .
COPY --from=pruner /app/out/json/ .
COPY --from=pruner /app/out/yarn.lock ./yarn.lock
RUN yarn install --production && yarn cache clean;
CMD node ./apps/backend/dist/index.js