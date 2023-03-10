####################################################################################################
## Builder
####################################################################################################
FROM rust:alpine AS builder

RUN apk add --no-cache g++

WORKDIR /usr/src/libreddit

COPY . .

RUN cargo install --path .

####################################################################################################
## Final image
####################################################################################################
FROM alpine:latest

# Import ca-certificates from builder
COPY --from=builder /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

# Copy our build
COPY --from=builder /usr/local/cargo/bin/libreddit /usr/local/bin/libreddit

# Use an unprivileged user.
RUN adduser --home /nonexistent --no-create-home --disabled-password libreddit
USER libreddit

# Tell Docker to expose port 8080
EXPOSE 8080

# Run a healthcheck every minute to make sure Libreddit is functional