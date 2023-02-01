FROM node:14.16 as builder
RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY package*.json ./
RUN npm install --loglevel verbose && npm cache clean --force;

FROM node:14.16-alpine

WORKDIR /usr/src/app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

ARG git_sha
ENV GIT_SHA=$git_sha
