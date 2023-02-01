# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM node:14.16.0-slim

# Copy the local package files to the container's workspace.
ADD . /bitcoinfilesjs

# Switch to the correct working directory.
WORKDIR /bitcoinfilesjs/regtest

# Create the data volume.