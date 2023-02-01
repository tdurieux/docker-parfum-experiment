FROM node:erbium-alpine
WORKDIR /usr/src/app

# Override the base log level (info).
ENV NPM_CONFIG_LOGLEVEL warn

# Install npm dependencies first (so they may be cached if dependencies don't change)
COPY package.json package.json
COPY packages/metrics/tsconfig.json packages/metrics/tsconfig.json
COPY packages/metrics/package.json packages/metrics/package.json
COPY packages/commons packages/commons
COPY yarn.lock yarn.lock
RUN yarn install --production

# Copy package build
COPY --from=opencrvs-build /packages/metrics packages/metrics

# Copy dependant package(s) source
COPY --from=opencrvs-build packages/commons packages/commons

EXPOSE 1050
WORKDIR /usr/src/app/packages/metrics

CMD yarn start:prod
