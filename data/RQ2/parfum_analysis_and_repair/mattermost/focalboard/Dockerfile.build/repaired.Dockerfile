# This dockerfile is used to build Focalboard for Linux
# it builds all the parts inside the container and the last stage just holds the
# package that can be extracted using docker cp command
# ie
# docker build -f Dockerfile.build --no-cache -t focalboard-build:dirty .
# docker run --rm -v /tmp/dist:/tmp -d --name test focalboard-build:dirty /bin/sh -c 'sleep 1000'
# docker cp test:/dist/focalboard-server-linux-amd64.tar.gz .

# build frontend
FROM node:16.3.0@sha256:ca6daf1543242acb0ca59ff425509eab7defb9452f6ae07c156893db06c7a9a4 AS frontend

WORKDIR /webapp
COPY webapp .

RUN npm install --no-optional && npm cache clean --force;
RUN npm run pack

# build backend and package
FROM golang:1.18.3@sha256:b203dc573d81da7b3176264bfa447bd7c10c9347689be40540381838d75eebef AS backend

COPY . .
COPY --from=frontend /webapp/pack webapp/pack

# RUN apt-get update && apt-get install libgtk-3-dev libwebkit2gtk-4.0-dev -y
RUN make server-linux
RUN make server-linux-package-docker

# just hold the packages to output later
FROM alpine:3.12@sha256:c75ac27b49326926b803b9ed43bf088bc220d22556de1bc5f72d742c91398f69 AS dist

WORKDIR /dist

COPY --from=backend /go/dist/focalboard-server-linux-amd64.tar.gz .
