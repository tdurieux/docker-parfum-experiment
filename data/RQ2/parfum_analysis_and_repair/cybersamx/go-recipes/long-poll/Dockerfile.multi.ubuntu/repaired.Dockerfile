# --- Build ---

FROM golang:1.13.4 as builder

# --- Variables --

# NOTE: Careful not to put sensitive info in ARG or ENV, someone can run docker history on
#       the image. Use a multi-stage docker build process.

# Build-time arguments.
ARG SRC_DIR="/src/long-poll"
ARG APP_NAME="long-poll"

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

RUN go build -o ${SRC_DIR}/${APP_NAME}

# --- Deployment ---

FROM ubuntu:18.10

# --- Variables --

# Build-time arguments.
ARG APP_USER="golang"
ARG APP_GROUP=${APP_USER}
ARG SRC_DIR="/src/long-poll"
ARG APP_DIR="/app"
ARG APP_NAME="long-poll"

# --- Install system packages ---

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

# --- Run container as non-privileged user ---

# See https://stackoverflow.com/a/55757473/12429735
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "${APP_DIR}" \
    --shell "/sbin/nologin" \
    --no-create-home \
    "${APP_USER}"

# --- Copy app over ---

COPY --from=builder ${SRC_DIR}/${APP_NAME} ${APP_DIR}/${APP_NAME}

# --- Runtime configurations ---

EXPOSE 8000
USER ${APP_USER}
# ARG variables are only available in build-time, so you can't use ARG variables in
# ENTRYPOINT or CMD commands.
ENTRYPOINT [ "/app/long-poll" ]
