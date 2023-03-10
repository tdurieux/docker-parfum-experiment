##################################################
# Local dev image only
# See: Dockerfile and README for Production image
##################################################

FROM node:14

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --yes --no-install-recommends \
  build-essential \
  libcairo2-dev \
  libpango1.0-dev \
  libjpeg-dev \
  libgif-dev \
  librsvg2-dev && \
  \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN yarn install && yarn cache clean;

ENV NODE_ENV='development'
CMD [ "node", "lib/index.js" ]
