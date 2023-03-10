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
RUN go build -o /build/bin/pixel_bt_feeder ./feeder/cmd/pixel_bt_feeder

# Build release image
FROM alpine

COPY --from=builder /build/bin/pixel_bt_feeder /bin/pixel_bt_feeder
ENTRYPOINT ["/bin/pixel_bt_feeder"]