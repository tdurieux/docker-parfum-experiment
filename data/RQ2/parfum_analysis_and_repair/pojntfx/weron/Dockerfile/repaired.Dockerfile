# Build container
FROM golang:bullseye AS build

# Setup environment
RUN mkdir -p /data
WORKDIR /data

# Build the release
COPY . .
RUN make

# Extract the release
RUN mkdir -p /out
RUN cp out/weron /out/weron

# Release container
FROM debian:bullseye

# Add certificates
RUN apt update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

# Add the release
COPY --from=build /out/weron /usr/local/bin/weron

CMD /usr/local/bin/weron
