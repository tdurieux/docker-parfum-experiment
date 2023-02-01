FROM node:14.16 as builder
RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY package*.json ./
RUN npm install --loglevel verbose && npm cache clean --force;

FROM node:14.16-alpine

WORKDIR /usr/src/app

COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Add the wait script to the image
# Script originally from https://github.com/ufoscout/docker-compose-wait/releases/download/2.4.0/wait /usr/bin/wait
COPY scripts/wait /usr/bin/wait
RUN chmod +x /usr/bin/wait

# Handle unreachable Alpine repo, revert this eventually:
# https://github.com/gliderlabs/docker-alpine/issues/155
RUN sed -i -e 's/dl-cdn/dl-4/' /etc/apk/repositories

RUN apk update && \
    apk add --no-cache rsyslog && \
    apk add --no-cache python3 && \
    apk add --no-cache python3-dev && \
    apk add --no-cache py3-pip && \
    apk add --no-cache curl && \
    apk add --no-cache bash

EXPOSE 7000

ARG git_sha
ARG audius_loggly_disable
ARG audius_loggly_token
ARG audius_loggly_tags

ENV GIT_SHA=$git_sha
ENV logglyDisable=$audius_loggly_disable
ENV logglyToken=$audius_loggly_token
ENV logglyTags=$audius_loggly_tags

HEALTHCHECK --interval=5s --timeout=5s \
    CMD curl -f http://localhost:7000/health_check || exit 1

CMD ["bash", "scripts/start.sh"]
