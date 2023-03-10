FROM node:17-alpine as ui-build
COPY web /tmp/web
WORKDIR /tmp/web
ARG APP_VERSION=1.0.0
ARG GITHUB_URL='https://github.com/x1unix/go-playground'
RUN yarn install --silent && \
    REACT_APP_VERSION=$APP_VERSION NODE_ENV=production REACT_APP_GITHUB_URL=$GITHUB_URL yarn build && yarn cache clean;

FROM golang:1.18-alpine as build
WORKDIR /tmp/playground
COPY cmd ./cmd
COPY pkg ./pkg
COPY go.mod .
COPY go.sum .
ARG APP_VERSION=1.0.0
RUN echo "Building server with version $APP_VERSION" && \
    go build -o server -ldflags="-X 'main.Version=$APP_VERSION'" ./cmd/playground && \
    GOOS=js GOARCH=wasm go build -o ./worker.wasm ./cmd/webworker && \
    cp $(go env GOROOT)/misc/wasm/wasm_exec.js .

FROM golang:1.18-alpine as production
WORKDIR /opt/playground
ENV GOROOT /usr/local/go
ENV APP_CLEAN_INTERVAL=10m
ENV APP_DEBUG=false
ENV APP_PLAYGROUND_URL='https://play.golang.org'
ENV APP_GOTIP_URL='https://gotipplay.golang.org'
ENV APP_GTAG_ID=''
COPY data ./data
COPY --from=ui-build /tmp/web/build ./public
COPY --from=build /tmp/playground/server .
COPY --from=build /tmp/playground/worker.wasm ./public
COPY --from=build /tmp/playground/wasm_exec.js ./public
EXPOSE 8000
ENTRYPOINT /opt/playground/server \
    -f='/opt/playground/data/packages.json' \
    -addr=:8000
