# Ideally we would us a very small image like plain alpine and just copy the
# pre-built binary into it, but due to e.g. multistage builds not available in
# OpenShift yet, for now the easiest is to build the binary in this image.
FROM golang:1.18-alpine

# Set default ALLOWED_EXTERNAL_PROJECTS env var