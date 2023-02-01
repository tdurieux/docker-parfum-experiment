FROM nvidia/cuda:9.2-devel-ubuntu18.04 AS base

RUN mkdir -p /code
WORKDIR /code
CMD "hs-miner"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY binding.gyp \
     package.json \
     #package-lock.json \
     /code/

COPY scripts /code/scripts/

FROM base AS build
# Install build dependencies
RUN apt-get install --no-install-recommends -y git python make g++ perl bash npm && rm -rf /var/lib/apt/lists/*;

# Install hsd
COPY src /code/src/
RUN npm install --production && npm cache clean --force;
RUN npm run install-testnet

FROM base
ENV PATH="${PATH}:/code/bin:/code/node_modules/.bin"
COPY --from=build /code/node_modules /code/node_modules/
COPY --from=build /code/build /code/build/
COPY bin /code/bin/
COPY lib /code/lib/

