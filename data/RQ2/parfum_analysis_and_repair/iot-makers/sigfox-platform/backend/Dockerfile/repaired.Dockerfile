FROM node:14-alpine
RUN apk add --no-cache curl

WORKDIR /backend
COPY package*.json /backend/
COPY yarn.lock /backend/
RUN yarn --frozen-lockfile

EXPOSE $PORT
HEALTHCHECK --interval=15s --timeout=15s --retries=3 \
  CMD curl --silent --fail localhost:$PORT/ || exit 1

COPY ./ /backend/
ARG GIT_REV
ENV GIT_REV $GIT_REV