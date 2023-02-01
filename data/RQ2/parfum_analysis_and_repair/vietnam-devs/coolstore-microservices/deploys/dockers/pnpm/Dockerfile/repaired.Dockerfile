FROM node:alpine

RUN apk add --no-cache curl
RUN curl -f -sL https://unpkg.com/@pnpm/self-installer | node