# Copyright (c) 2018-2021 Codenotary, Inc. All Rights Reserved.
# This software is released under Apache License 2.0.
# The full license information can be found under:
# https://www.apache.org/licenses/LICENSE-2.0

FROM golang:1.16.6-buster as build
WORKDIR /src
COPY . .
RUN GOOS=linux GOARCH=amd64 make static

FROM node:stretch-slim
COPY --from=build /src/cas /bin/cas
RUN apt-get update -yq && apt-get install --no-install-recommends -yq ca-certificates && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "/bin/cas" ]