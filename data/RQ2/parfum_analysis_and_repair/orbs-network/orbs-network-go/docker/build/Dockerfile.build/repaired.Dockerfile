FROM golang:1.12.9

WORKDIR /src

RUN apt update && apt install --no-install-recommends ca-certificates libgnutls30 -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git bash libc6-dev && rm -rf /var/lib/apt/lists/*;

ADD ./go.* /src/

RUN go mod download

ADD . /src

RUN env

RUN go env

ARG SKIP_DEVTOOLS

ARG GIT_COMMIT

ARG BUILD_FLAG

ARG BUILD_CMD

ARG SEMVER

RUN $BUILD_CMD
