# ----------------------------------------------------
# In stage one, we're installing dependencies
# and building the golang application.
# ----------------------------------------------------

FROM golang:1.16-alpine as builder

ENV GO111MODULE=on \
    GOOS=linux \
    CGO_ENABLED=1 \
    BUILD_PATH=/build

WORKDIR $BUILD_PATH

RUN apk add --no-cache musl-dev gcc

ADD go.mod go.sum $BUILD_PATH/
RUN go mod download

COPY . $BUILD_PATH
RUN go build -ldflags="-s -w" -o commits.lol



# ----------------------------------------------------
# In stage two, we're copying the app binary and
# other dependencies into a minimal image.
# ----------------------------------------------------