FROM node:14-alpine as builder
WORKDIR /app

# dependencies
ADD package.json yarn.lock ./
RUN yarn --frozen-lockfile && yarn cache clean;

# library code
ADD src src

# bundle
RUN yarn esbuild src/bin/start.ts --outdir=lib --platform=node --target=node14 --bundle && yarn cache clean;

FROM node:14-alpine
WORKDIR /app
COPY --from=builder /app/lib .

# bindings
EXPOSE 9229
ENV HOST 0.0.0.0
ENV PORT 9229
VOLUME /app/.cognito
ENTRYPOINT ["node", "/app/start.js"]