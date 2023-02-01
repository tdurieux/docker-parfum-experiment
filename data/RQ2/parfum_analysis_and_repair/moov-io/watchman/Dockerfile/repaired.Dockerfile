FROM golang:1.18-buster as backend
WORKDIR /go/src/github.com/moov-io/watchman
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends make gcc g++ && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN go mod download
RUN make build-server

FROM node:18-buster as frontend
COPY webui/ /watchman/
WORKDIR /watchman/
RUN npm install --legacy-peer-deps && npm cache clean --force;
RUN npm run build

FROM debian:stable-slim
LABEL maintainer="Moov <support@moov.io>"

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY --from=backend /go/src/github.com/moov-io/watchman/bin/server /bin/server

COPY --from=frontend /watchman/build/ /watchman/
ENV WEB_ROOT=/watchman/

# USER moov # TODO(adam): non-root users

EXPOSE 8080
EXPOSE 9090
ENTRYPOINT ["/bin/server"]
