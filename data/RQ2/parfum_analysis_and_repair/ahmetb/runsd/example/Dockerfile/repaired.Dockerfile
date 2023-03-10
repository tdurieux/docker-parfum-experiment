# Build go binary
FROM golang:alpine AS build
WORKDIR /src/app
COPY ./ .
RUN CGO_ENABLED=0 go build -o /app .

# Copy resulting binary to a new small image
FROM alpine
RUN apk add --no-cache curl bind-tools
COPY --from=build /app /app

# This is how you integrate with runsd: