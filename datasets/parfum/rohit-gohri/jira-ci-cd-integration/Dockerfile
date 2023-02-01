# ------------------------------------------------------------------------------
# Generate build
# ------------------------------------------------------------------------------
FROM node:16-alpine as generator

LABEL stage=generator

WORKDIR /jci

# Install app dependencies
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

RUN yarn install --immutable

# Bundle app source
COPY . .

# Package only Docker version
RUN yarn package:docker

# Install production dependencies
RUN yarn workspaces focus --production

# ------------------------------------------------------------------------------
# Second image (release image)
# ------------------------------------------------------------------------------
FROM node:16-alpine

WORKDIR /usr/src/jira-ci-cd-integration

# Now we copy the compiled ncc build folder
COPY --from=generator /jci/dist/docker dist
COPY --from=generator /jci/node_modules ./node_modules

CMD ["node", "dist/index.js"]
