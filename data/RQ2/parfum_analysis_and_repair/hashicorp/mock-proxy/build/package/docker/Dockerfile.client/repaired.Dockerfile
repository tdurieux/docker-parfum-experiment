FROM alpine:3.11

ARG DOCKERIZE_VERSION="v0.6.1"
ARG DOCKERIZE_SHA="dddbf178ecfd55fa6670b01ac08fef63ef9490212426b9fab8a602345409da8f"

RUN apk add --no-cache \
    ca-certificates curl bash git

# Install Dockerize: https://github.com/jwilder/dockerize
RUN echo "${DOCKERIZE_SHA}  -" > sumfile \
    && curl -f -s -L "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" | \
        tee dockerize.tar.gz | \
        sha256sum -c sumfile \
    && tar -xzvf dockerize.tar.gz \
    && mv "dockerize" "/usr/local/bin/dockerize" \
    && rm -rf "dockerize.tar.gz" "sumfile" "dockerize"

# Set a bash prompt.
ENV PS1="client:-$ "
