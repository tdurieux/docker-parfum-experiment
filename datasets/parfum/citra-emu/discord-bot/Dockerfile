FROM node:16-alpine AS build

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies and add source files
COPY package.json yarn.lock tsconfig.json ./
COPY src/ ./src 
RUN yarn install --frozen-lockfile && yarn build && rm -f dist/*.map

# Second stage
FROM node:16-alpine

WORKDIR /usr/src/app

# Copy artifacts
COPY --from=build /usr/src/app/dist/ ./
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY env.json src/responses.json ./
COPY src/responses ./responses/

RUN addgroup -S app -g 50000 && \
    adduser -S -g app -u 50000 app && \
    mkdir /data && chown app:app /data/

USER app

ENTRYPOINT [ "node", "server.js" ]
