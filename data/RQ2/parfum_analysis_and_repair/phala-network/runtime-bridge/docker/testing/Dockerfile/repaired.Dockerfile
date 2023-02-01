FROM node:16-buster-slim

ENV PYTHONUNBUFFERED=1
RUN apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    bash \
    build-essential \
    redis-tools \
    tzdata \
    zlib1g-dev liblzma-dev libgmp-dev patch \
    protobuf-compiler \
    curl \
    python \
    python3 \
    git-core && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/app

COPY package.json .
COPY yarn.lock .

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn install && yarn cache clean;
RUN yarn proto:build_prpc
RUN yarn tsc

ENTRYPOINT [ "yarn", "start_module" ]
