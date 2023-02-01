# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM node:14.16.0-slim

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# Copy the local package files to the container's workspace.
ADD . /usr/src/SLPDB

# Switch to the correct working directory.
WORKDIR /usr/src/SLPDB/regtest

# Create the data volume.
VOLUME ["/data"]
