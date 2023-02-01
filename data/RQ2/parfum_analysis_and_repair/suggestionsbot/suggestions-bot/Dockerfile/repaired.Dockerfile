FROM nikolaik/python-nodejs:python3.10-nodejs16-alpine AS base

# create working directory for bot
WORKDIR /opt/suggestions

# add git
RUN apk update && apk add --no-cache git

### dependencies & builder
FROM base AS builder

# install production dependencies
COPY package.json yarn.lock ./

# install make
RUN apk add --no-cache g++ make

RUN yarn install --production --pure-lockfile && yarn cache clean;
RUN cp -RL node_modules /tmp/node_modules

# install all dependencies
RUN yarn install --pure-lockfile && yarn cache clean;

### runner
FROM base

# copy runtime dependencies
COPY --from=builder /tmp/node_modules node_modules

# copy remaining files
COPY . .

CMD ["yarn", "start"]
