# Build Stage

FROM golang:1.18 AS api-build-env

WORKDIR /src
ADD . .
RUN CGO_ENABLED=0 go build -o mailwhale

WORKDIR /app
RUN cp /src/mailwhale . && \
    cp /src/version.txt . && \
    cp -r /src/templates .

FROM node:14 AS ui-build-env

WORKDIR /src
ADD webui .
RUN yarn && \
    yarn build

# Run Stage

# When running the application using `docker run`, you can pass environment variables
# to override config values using `-e` syntax.