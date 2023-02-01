FROM golang:1.12-alpine

# Install git

RUN apk update && apk add --no-cache git

WORKDIR /usr/src/app

COPY go.mod go.sum ./

RUN go mod download 

# Copy the source from the current directory to the working Directory inside the container 
COPY . .

# Run tests
CMD CGO_ENABLED=0 go test -v  ./tests/...