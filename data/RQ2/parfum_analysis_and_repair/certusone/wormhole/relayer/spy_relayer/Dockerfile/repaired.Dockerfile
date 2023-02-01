FROM node:lts-alpine3.15@sha256:a2c7f8ebdec79619fba306cec38150db44a45b48380d09603d3602139c5a5f92

RUN mkdir -p /app
WORKDIR /app

RUN apk add --no-cache python3 \
        make \
        g++

COPY . .

RUN echo $(ls -1 .)
RUN echo $(less Dockerfile)

WORKDIR ./relayer/spy_relayer

RUN npm ci && \
    npm run build

#TODO don't hardcode for tilt but accept env file
# RUN --mount=type=cache,uid=1000,gid=1000,target=/home/node/.npm \
#   npm run tilt_relay
