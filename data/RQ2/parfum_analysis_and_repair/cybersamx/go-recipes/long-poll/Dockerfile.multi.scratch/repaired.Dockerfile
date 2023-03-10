# CREDIT: Partial based on https://github.com/chemidy/smallest-secured-golang-docker-image
#         for building clean, secure Go docker image using the scratch base image.

# --- Build ---

FROM golang:1.13.4-alpine as builder

# --- Variables ---

# NOTE: Careful not to put sensitive info in ARG or ENV, someone can run docker history on
#       the image. Use a multi-stage docker build process.

# Build-time arguments.
ARG SRC_DIR="/src/long-poll"
ARG APP_NAME="long-poll"
ARG APP_USER="golang"
ARG UID=10001

# --- Set up the build directory ---

WORKDIR ${SRC_DIR}

# Third-party modules.
COPY go.mod ./
ENV GO111MODULE=on
RUN go mod download
RUN go mod verify

# App source.
COPY pkg pkg
COPY main.go ./

# --- Build ---

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' -a \
    -o ${SRC_DIR}/${APP_NAME}

# --- Set up system dependencies ---

# See https://stackoverflow.com/a/55757473/12429735
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${APP_USER}"

RUN apk update && \
    apk add --no-cache ca-certificates tzdata

# --- Deployment ---

FROM scratch

# --- Variables ---

ARG APP_USER="golang"
ARG SRC_DIR="/src/long-poll"
ARG APP_DIR="/app"
ARG APP_NAME="long-poll"

# --- Copy system files over ---

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# --- Copy app over ---

COPY --from=builder ${SRC_DIR}/${APP_NAME} ${APP_DIR}/${APP_NAME}

# --- Runtime configurations ---

EXPOSE 8000
USER ${APP_USER}
# ARG variables are only available in build-time, so you can't use ARG variables in
# ENTRYPOINT or CMD commands.