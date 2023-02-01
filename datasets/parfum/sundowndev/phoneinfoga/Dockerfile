FROM node:15.11.0-alpine AS client_builder

WORKDIR /app

COPY ./client .

RUN yarn install --immutable

RUN yarn build

FROM golang:1.17.8-alpine as go_builder

LABEL maintainer="Sundowndev" \
  org.label-schema.name="phoneinfoga" \
  org.label-schema.description="Advanced information gathering & OSINT tool for phone numbers." \
  org.label-schema.url="https://github.com/sundowndev/phoneinfoga" \
  org.label-schema.vcs-url="https://github.com/sundowndev/phoneinfoga" \
  org.label-schema.vendor="Sundowndev" \
  org.label-schema.schema-version="1.0"

WORKDIR /app

COPY . .

RUN apk add git
RUN go get -v -t -d ./...

COPY --from=client_builder /app/dist ./client/dist

RUN go generate ./...

RUN go build -v -ldflags="-s -w -X 'github.com/sundowndev/phoneinfoga/v2/config.Version=$(git describe --abbrev=0 --tags)' -X 'github.com/sundowndev/phoneinfoga/v2/config.Commit=$(git rev-parse --short HEAD)'" -v -o phoneinfoga .

FROM golang:1.17.8-alpine

WORKDIR /app

COPY --from=go_builder /app/phoneinfoga .

EXPOSE 5000

ENTRYPOINT ["/app/phoneinfoga"]
