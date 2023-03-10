FROM node:alpine AS builder
RUN apk update
# Set working directory
WORKDIR /app
RUN yarn global add turbo && yarn cache clean;
COPY . .
RUN turbo prune --scope=@freestuffbot/discord-interactions --docker

# Add lockfile and package.json's of isolated subworkspace
FROM node:alpine AS installer
RUN apk update
WORKDIR /app
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/yarn.lock ./yarn.lock
RUN yarn install && yarn cache clean;

FROM node:alpine AS sourcer
RUN apk update
WORKDIR /app
COPY --from=installer /app/ .
COPY --from=builder /app/out/full/ .
COPY .gitignore .gitignore
RUN yarn turbo run build --scope=@freestuffbot/discord-interactions --include-dependencies --no-deps && yarn cache clean;

EXPOSE 80
ENTRYPOINT [ "yarn", "run-discord-interactions" ]
