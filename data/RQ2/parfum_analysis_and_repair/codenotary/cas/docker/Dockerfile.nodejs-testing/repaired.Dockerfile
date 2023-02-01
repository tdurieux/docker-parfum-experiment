# Copyright (c) 2018-2021 Codenotary, Inc. All Rights Reserved.
# This software is released under Apache License 2.0.
# The full license information can be found under:
# https://www.apache.org/licenses/LICENSE-2.0

FROM golang:1.16.6-buster as build
WORKDIR /src
COPY . .
RUN GOOS=linux GOARCH=amd64 make static

FROM node:latest
COPY ./integration/work/js /work/my-app
WORKDIR /work/my-app
RUN npm install && npm cache clean --force;
COPY --from=build /src/cas /bin/cas
ENTRYPOINT [ "/bin/cas" ]
