FROM alpine:latest as builder

RUN apk add --no-cache nodejs-current yarn go git

COPY dashboard/ /build
COPY .git/ /build/.git

WORKDIR /build

RUN yarn install --frozen-lockfile && yarn cache clean;
RUN yarn build

RUN sh -c 'go build -ldflags "-X main.version=$(git rev-parse HEAD)"'

FROM alpine:latest

COPY --from=builder /build/dashboard /bin/dashboard

ENTRYPOINT /bin/dashboard