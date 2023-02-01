FROM golang:1-alpine

# Working directory
ENV APP_DIR "$GOPATH/src/github.com/Noah-Huppert/human-call-filter"
RUN mkdir -p "$APP_DIR"
WORKDIR "$APP_DIR"

# Prequisits
RUN apk --update --no-cache add curl git nodejs nodejs-npm
RUN curl -f https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# Source code
COPY . .

# Install dependencies
RUN dep ensure
RUN cd static && npm install && npm cache clean --force;

# Build
RUN go build -o "human-call-filter" main.go

# Execute
ENTRYPOINT [ "./human-call-filter" ]
