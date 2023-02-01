FROM golang:alpine

MAINTAINER Pavel Simzicov <sharovik89@ya.ru>

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=1 \
    GOOS=linux \
    GOARCH=amd64 \
    APP_PATH="/home/go/src/github.com/sharovik/devbot"

WORKDIR ${APP_PATH}

#I am guessing you already already aware of distroless. It is a matter of developer taste, but distroless has been something I have fallen in love with due to security and simplicity.
COPY . .

RUN apk add --no-cache bash && apk add --no-cache make && apk add build-base && apk add --no-cache git

RUN make vendor
RUN make build

# Command to run when starting the container
ENTRYPOINT ["./bin/slack-bot-current-system"]
