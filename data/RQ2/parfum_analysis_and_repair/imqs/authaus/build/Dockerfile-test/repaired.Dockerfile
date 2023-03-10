FROM golang:1.13

WORKDIR /test

RUN go get github.com/tebeka/go2xunit

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy code in
COPY . .