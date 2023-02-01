# Build

FROM node:17.2 as build
COPY . /work
WORKDIR /work
RUN cd src/server && yarn run build

# Production