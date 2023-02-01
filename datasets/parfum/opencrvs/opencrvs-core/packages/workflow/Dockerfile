FROM node:erbium-alpine
WORKDIR /usr/src/app

# Override the base log level (info).
ENV NPM_CONFIG_LOGLEVEL warn

# Install npm dependencies first (so they may be cached if dependencies don't change)
COPY package.json package.json
COPY packages/workflow/tsconfig.json packages/workflow/tsconfig.json
COPY packages/workflow/package.json packages/workflow/package.json
COPY packages/commons packages/commons
COPY yarn.lock yarn.lock
RUN yarn install --production

# Copy package source
COPY --from=opencrvs-build packages/workflow/build packages/workflow/build

# Copy dependant package(s) source
COPY --from=opencrvs-build packages/commons packages/commons

EXPOSE 5050
WORKDIR /usr/src/app/packages/workflow

CMD yarn start:prod
