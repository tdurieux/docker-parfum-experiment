FROM node:12.14-alpine

WORKDIR /usr/src

# Set cdn domain
ARG CDN_BASE_URL
ENV CDN_BASE_URL $CDN_BASE_URL

# Set host
ENV HOST 0.0.0.0

# Set and expose port
ENV PORT 3000
EXPOSE $PORT

# Install dependences
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#node-gyp-alpine
RUN apk add --no-cache --virtual .gyp python make g++ git
COPY package*.json ./
RUN npm ci

CMD ["npm", "run", "dev"]