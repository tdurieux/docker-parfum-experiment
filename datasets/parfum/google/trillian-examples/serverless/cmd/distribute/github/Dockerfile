FROM golang:1.17-alpine AS builder

ARG GOFLAGS=""
ENV GOFLAGS=$GOFLAGS
ENV GO111MODULE=on

# Move to working directory /build
WORKDIR /build

# Copy and download dependency using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the code into the container
COPY . .

# Build the application
RUN go build -o /build/bin/distribute ./serverless/cmd/distribute/github

# Build release image
FROM alpine

COPY --from=builder /build/bin/distribute /bin/distribute
ENTRYPOINT ["/bin/distribute"]