# Build step
FROM mhart/alpine-node:14
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci 

## Build step complete, copy to working image