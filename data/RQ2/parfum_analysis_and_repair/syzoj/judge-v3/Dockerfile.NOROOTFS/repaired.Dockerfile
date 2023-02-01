FROM node:10-buster

# Install OS dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 build-essential libboost-all-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

# Install NPM dependencies
COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile && yarn cache clean;

# Copy code and build
COPY . .
RUN yarn build && yarn cache clean;

ENV NODE_ENV=production \
    SYZOJ_JUDGE_RUNNER_INSTANCE=runner \
    SYZOJ_JUDGE_SANDBOX_ROOTFS_PATH=/rootfs \
    SYZOJ_JUDGE_WORKING_DIRECTORY=/tmp/working \
    SYZOJ_JUDGE_BINARY_DIRECTORY=/tmp/binary \
    SYZOJ_JUDGE_TESTDATA_PATH=/app/testdata \
    SYZOJ_JUDGE_DO_NOT_USE_X32_ABI=true

VOLUME ["/app/config", "/app/testdata", "/rootfs"]

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["daemon"]
