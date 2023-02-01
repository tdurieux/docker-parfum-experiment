# ========================================
# ===== Build image for the frontend =====
# ========================================
FROM node:18-alpine AS builder-frontend

WORKDIR /node/src/app

COPY .pnpm-store /root/.pnpm-store
COPY web ./

# Install the dependencies and build
RUN yarn global add pnpm && \
    pnpm install --frozen-lockfile && pnpm coverage && yarn cache clean;

# =======================================
# ===== Build image for the backend =====
# =======================================
FROM golang:1.18.4-alpine AS builder-backend

WORKDIR /go/src/app

RUN \
echo ">> Downloading required apk's..." && \
apk --no-cache add gcc musl-dev

COPY go.mod go.sum ./

RUN \
echo ">> Downloading go modules..." && \
go mod download

COPY / ./

# Prepare static files to be embedded in Go binary
COPY --from=builder-frontend /node/src/internal/server/public_html internal/server/public_html

ARG LDFLAGS_EXTRA
RUN \
mv api internal/server/public_html/api && \
cd cmd/authelia && \
chmod 0666 /go/src/app/.healthcheck.env && \
echo ">> Starting go build (coverage via go test)..." && \
CGO_ENABLED=1 CGO_CPPFLAGS="-D_FORTIFY_SOURCE=2 -fstack-protector-strong" CGO_LDFLAGS="-Wl,-z,relro,-z,now" go test -c --tags coverage -covermode=atomic \
-ldflags "${LDFLAGS_EXTRA}" -o authelia -coverpkg github.com/authelia/authelia/...

# ===================================
# ===== Authelia official image =====
# ===================================
FROM alpine:3.16.0

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app

COPY --from=builder-backend /go/src/app/cmd/authelia/authelia /go/src/app/LICENSE /go/src/app/healthcheck.sh /go/src/app/.healthcheck.env ./

EXPOSE 9091

VOLUME /config

ENV PATH="/app:${PATH}"

CMD ["authelia", "-test.coverprofile=/authelia/coverage.txt", "COVERAGE", "--config", "/config/configuration.yml"]
HEALTHCHECK --interval=30s --timeout=3s CMD /app/healthcheck.sh
