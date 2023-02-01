# This Dockerfile builds all the dependencies needed by the monorepo, and should
# be used to build any of the follow-on services
#
# ### BASE: Install deps
FROM ethereumoptimism/foundry:latest as foundry
FROM node:16-alpine3.14 as base

RUN apk --no-cache add curl \
    jq \
    python3 \
    ca-certificates \
    git \
    make \
    gcc \
    musl-dev \
    linux-headers \
    bash \
    build-base \
    gcompat

ENV GLIBC_KEY=https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
ENV GLIBC_KEY_FILE=/etc/apk/keys/sgerrand.rsa.pub
ENV GLIBC_RELEASE=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk

RUN wget -q -O ${GLIBC_KEY_FILE} ${GLIBC_KEY} \
    && wget -O glibc.apk ${GLIBC_RELEASE} \
    && apk add --no-cache glibc.apk --force

COPY --from=foundry /usr/local/bin/forge /usr/local/bin/forge
COPY --from=foundry /usr/local/bin/cast /usr/local/bin/cast

# copy over the needed configs to run the dep installation
# note: this approach can be a bit unhandy to maintain, but it allows
# us to cache the installation steps
WORKDIR /opt/optimism
COPY *.json yarn.lock ./
COPY packages/sdk/package.json ./packages/sdk/package.json
COPY packages/core-utils/package.json ./packages/core-utils/package.json
COPY packages/common-ts/package.json ./packages/common-ts/package.json
COPY packages/contracts/package.json ./packages/contracts/package.json
COPY packages/contracts-bedrock/package.json ./packages/contracts-bedrock/package.json
COPY packages/contracts-periphery/package.json ./packages/contracts-periphery/package.json
COPY packages/contracts-governance/package.json ./packages/contracts-governance/package.json
COPY packages/data-transport-layer/package.json ./packages/data-transport-layer/package.json
COPY packages/hardhat-deploy-config/package.json ./packages/hardhat-deploy-config/package.json
COPY packages/message-relayer/package.json ./packages/message-relayer/package.json
COPY packages/fault-detector/package.json ./packages/fault-detector/package.json
COPY packages/replica-healthcheck/package.json ./packages/replica-healthcheck/package.json
COPY packages/drippie-mon/package.json ./packages/drippie-mon/package.json
COPY integration-tests/package.json ./integration-tests/package.json

RUN yarn install --frozen-lockfile && yarn cache clean

COPY ./packages ./packages
COPY ./integration-tests ./integration-tests

# build it!
RUN yarn build


FROM base as deployer
WORKDIR /opt/optimism/packages/contracts
COPY ./ops/scripts/deployer.sh .
CMD ["yarn", "run", "deploy"]

FROM base as deployer-bedrock
WORKDIR /opt/optimism/packages/contracts-bedrock
CMD ["yarn", "run", "deploy"]

FROM base as data-transport-layer
WORKDIR /opt/optimism/packages/data-transport-layer
COPY ./ops/scripts/dtl.sh .
CMD ["node", "dist/src/services/run.js"]


FROM base as integration-tests
WORKDIR /opt/optimism/integration-tests
COPY ./ops/scripts/integration-tests.sh ./
CMD ["yarn", "test:integration"]


FROM base as message-relayer
WORKDIR /opt/optimism/packages/message-relayer
COPY ./ops/scripts/relayer.sh .
CMD ["npm", "run", "start"]


FROM base as fault-detector
WORKDIR /opt/optimism/packages/fault-detector
COPY ./ops/scripts/detector.sh .
CMD ["npm", "run", "start"]


FROM base as replica-healthcheck
WORKDIR /opt/optimism/packages/replica-healthcheck
ENTRYPOINT ["npm", "run", "start"]

FROM base as drippie-mon
WORKDIR /opt/optimism/packages/drippie-mon
ENTRYPOINT ["npm", "run", "start"]
