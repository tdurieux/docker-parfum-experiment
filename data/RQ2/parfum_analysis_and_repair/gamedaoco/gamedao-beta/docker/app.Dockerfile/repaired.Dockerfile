# ===========================================================

FROM node:alpine as builder
RUN apk update && apk add --no-cache curl git gnupg python3 make g++

WORKDIR /app
COPY . .

RUN yarn && NODE_ENV=production yarn build
CMD ["ls", "-al", "build"]

# ===========================================================