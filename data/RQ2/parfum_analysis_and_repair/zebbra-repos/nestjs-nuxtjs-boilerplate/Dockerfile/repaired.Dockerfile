##########################################################################
#### BUILD CONTAINER
##########################################################################
FROM node:14.16.0-slim AS builder

RUN apt-get update && \
  apt-get -y --no-install-recommends install g++ build-essential python git -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /src

# Install build dependencies
ADD package.json yarn.lock scripts /src/
ADD scripts/ /src/scripts/
RUN yarn install && yarn cache clean;

# Build application
ADD . /src
RUN yarn build

# We only want the dist folder, remove the rest
RUN find ./dist/app/client -mindepth 1 ! -regex '^./dist/app/client/dist.*' -delete

##########################################################################
#### RUNTIME CONTAINER
##########################################################################
FROM node:14.16.0-slim

RUN apt-get update && \
  apt-get -y --no-install-recommends install g++ build-essential python && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /app

# Set environment variables
ENV NODE_ENV=production

# Install runtime dependencies
ADD package.json yarn.lock /app/
ADD scripts/ /app/scripts/
RUN yarn install && yarn cache clean;

# Copy app from former build stage
COPY --from=builder /src/dist /app/dist

CMD ["yarn", "start:prod"]
