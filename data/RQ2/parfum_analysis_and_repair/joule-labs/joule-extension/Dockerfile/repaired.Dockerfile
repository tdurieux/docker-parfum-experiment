# This Dockerfile can be used to build a production release of joule:
#
# Use `yarn build:docker` to build the dockerfile and copy out the deterministic build.

FROM node:14-slim
RUN apt-get update && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN ls -la
RUN yarn && yarn cache clean;
COPY . ./
RUN yarn build && yarn cache clean;
RUN cd dist-prod && find . -type f ! -name '*.zip' -print0 | sort -z | xargs -r0 sha256sum > manifest.txt
