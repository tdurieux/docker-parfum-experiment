FROM golang:1.16-alpine AS souin

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh gcc libc-dev
ENV GOPATH /app

RUN mkdir -p /app/src/github.com/darkweak/souin
WORKDIR /app/src/github.com/darkweak/souin
ADD ./go.* /app/src/github.com/darkweak/souin/
RUN go mod download
RUN go get golang.org/x/lint/golint
RUN mkdir -p /ssl
ADD ./api /app/src/github.com/darkweak/souin/api
ADD ./cache /app/src/github.com/darkweak/souin/cache
ADD ./context /app/src/github.com/darkweak/souin/context
ADD ./tests /app/src/github.com/darkweak/souin/tests
ADD ./rfc /app/src/github.com/darkweak/souin/rfc
ADD ./configuration /app/src/github.com/darkweak/souin/configuration
ADD ./configurationtypes /app/src/github.com/darkweak/souin/configurationtypes
ADD ./default /app/src/github.com/darkweak/souin/default
ADD ./errors /app/src/github.com/darkweak/souin/errors
ADD ./helpers /app/src/github.com/darkweak/souin/helpers
ADD ./plugins /app/src/github.com/darkweak/souin/plugins

WORKDIR /app/src/github.com/darkweak/souin

EXPOSE 80

CMD ["go", "run", "plugins/souin/main.go"]