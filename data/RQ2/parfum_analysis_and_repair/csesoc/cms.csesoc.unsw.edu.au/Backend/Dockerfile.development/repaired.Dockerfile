FROM golang:1.18-alpine as build-env

# make current working directory /app
WORKDIR /go/src/cms.csesoc.unsw.edu.au

# copy go.mod and go.sum
COPY go.mod go.sum ./

COPY . .

# downloding dependencies
RUN go mod download
RUN apk add --no-cache --update npm
RUN go get github.com/githubnemo/CompileDaemon

EXPOSE 8080

# export environment variable for gopath
ENV GOPATH /go

# might start the app
CMD ["go", "run", "main.go"]

# For some reason compile daemon is broken
# ENTRYPOINT CompileDaemon --build="go build main.go" --command="./main"