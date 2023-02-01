#
# Build a binary file
#

FROM golang:1.18-alpine as backend-builder


WORKDIR /build/backend

# Copy dependencies (for better caching)
COPY go.mod go.sum ./
COPY vendor ./vendor

# Copy code
COPY main.go main.go
COPY cmd ./cmd
COPY internal ./internal

# Build
ARG LDFLAGS
RUN go build -ldflags "${LDFLAGS}" -o ./bin/budget-manager ./main.go


#
# Build the final image
#