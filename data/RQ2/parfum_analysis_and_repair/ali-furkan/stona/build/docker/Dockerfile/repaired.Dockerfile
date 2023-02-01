# Deployment Image
FROM ubuntu:latest

COPY docker-entrypoint.sh stona /stona/

WORKDIR /stona

# Launching ENVs