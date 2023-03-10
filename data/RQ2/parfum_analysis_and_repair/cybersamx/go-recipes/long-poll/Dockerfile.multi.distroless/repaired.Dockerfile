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

# --- Deployment ---

FROM gcr.io/distroless/static

# --- Variables ---

ARG SRC_DIR="/src/long-poll"
ARG APP_DIR="/app"
ARG APP_NAME="long-poll"

# --- Copy app over ---

COPY --from=builder ${SRC_DIR}/${APP_NAME} ${APP_DIR}/${APP_NAME}

# --- Runtime configurations ---

# Distroless defines USER nobody:nobody.
EXPOSE 8000
# ARG variables are only available in build-time, so you can't use ARG variables in
# ENTRYPOINT or CMD commands.