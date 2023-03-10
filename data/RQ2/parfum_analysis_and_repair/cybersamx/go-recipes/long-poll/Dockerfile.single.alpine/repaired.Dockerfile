FROM golang:1.13.4-alpine

# --- Variables --

# NOTE: Careful not to put sensitive info in ARG or ENV, someone can run docker history on
#       the image. Use a multi-stage docker build process.

# Build-time arguments.
ARG APP_USER="golang"
ARG APP_GROUP=${APP_USER}
ARG SRC_DIR="/src/long-poll"
ARG APP_DIR="/app"
ARG APP_NAME="long-poll"

# --- Install system packages ---

RUN apk update && \
    apk add --no-cache ca-certificates

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

RUN go build -o ${APP_DIR}/${APP_NAME}

# --- Run container as non-privileged user ---

# See https://stackoverflow.com/a/55757473/12429735
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "${APP_DIR}" \
    --shell "/sbin/nologin" \
    --no-create-home \
    "${APP_USER}"

# --- Runtime configurations ---

EXPOSE 8000
USER ${APP_USER}
# ARG variables are only available in build-time, so you can't use ARG variables in
# ENTRYPOINT or CMD commands.
ENTRYPOINT [ "/app/long-poll" ]