# multi-stage builds

# building
FROM golang:1 as builder
WORKDIR /src/
# get&cache dependancies first
COPY go.mod .
RUN go mod download
# copy & build
COPY . .
RUN CGO_ENABLED=0 go build -o websentry .

# actual image