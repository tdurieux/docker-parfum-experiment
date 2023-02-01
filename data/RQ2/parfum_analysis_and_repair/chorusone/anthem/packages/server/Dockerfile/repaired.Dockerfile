FROM node:10-alpine AS build

# Install git
RUN apk add --no-cache git

# Create app directory
WORKDIR /usr/src/app

# Copy files
COPY . .

# Install Lerna
RUN npm i -g lerna && npm cache clean --force;

# Install Zeit ncc
RUN npm i -g @zeit/ncc && npm cache clean --force;

# Install dependencies
RUN lerna bootstrap

# Build utils package
RUN yarn utils:build && yarn cache clean;

# Build the server
RUN yarn server:build && yarn cache clean;

# Compile the server into a single js file
RUN cd packages/server && ncc build build/src/server.js -o dist

FROM node:10-alpine AS runtime

# Install dependencies for entrypoint script
RUN apk update && apk add --no-cache bash curl jq

WORKDIR /usr/src/app

# Copy entrypoint file
COPY --from=build /usr/src/app/packages/server/entrypoint.sh /usr/src/app

# Copy dist folder with server index.js file
COPY --from=build /usr/src/app/packages/server/dist /usr/src/app/dist

# Copy schema.graphql file
COPY --from=build /usr/src/app/packages/server/src/schema.graphql /usr/src/app/dist

# Allow entrypoint to be executable
RUN chmod +x entrypoint.sh

# Expose PORT
EXPOSE 8000

CMD [ "node", "dist/index.js" ]