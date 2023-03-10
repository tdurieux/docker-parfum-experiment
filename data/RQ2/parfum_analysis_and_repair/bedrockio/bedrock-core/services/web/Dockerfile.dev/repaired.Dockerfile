FROM node:16.13.0-alpine

# Note layers should be ordered from less to more likely to change.

# Update & install required packages
RUN apk add --no-cache --update bash curl;

# Set work directory
WORKDIR /service

COPY scripts/install_githooks scripts/install_githooks

# Install dependencies and store yarn cache
COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/root/.yarn YARN_CACHE_FOLDER=/root/.yarn yarn install --frozen-lockfile && yarn cache clean;

# Copy app source
COPY . .

EXPOSE 2200

CMD ["yarn", "start"]
