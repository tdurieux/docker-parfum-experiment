FROM node:18-alpine

RUN apk add --no-cache python3 make gcc g++

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]