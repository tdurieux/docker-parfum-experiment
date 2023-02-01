# Get the prebuilt binaries of the app
ARG PRE_IMAGE
FROM $PRE_IMAGE as build

# Build the resultant image.
FROM simplyboo6/vimtur-base@sha256:71c4016340f175f1c4c113f794f0a6d994944d7ee943c720a3a5afb596560069

RUN apk add --no-cache jq

COPY --from=build /app /app

WORKDIR /app

# Yarn doesn't have prune