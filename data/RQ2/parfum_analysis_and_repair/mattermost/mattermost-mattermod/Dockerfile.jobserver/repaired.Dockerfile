FROM golang:1.17.6 AS builder

WORKDIR /go/src/mattermod

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN make build-jobserver

################

FROM debian:buster-slim

RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates \
    && apt-get clean all \
    && rm -rf /var/cache/apt/ && rm -rf /var/lib/apt/lists/*;

RUN groupadd \
        --gid 1000 mattermod \
    && useradd \
        --home-dir /app \
        --create-home \
        --uid 1000 \
        --gid 1000 \
        --shell /bin/sh \
        --skel /dev/null \
        mattermod \
    && chown -R mattermod:mattermod /app

COPY --from=builder /go/src/mattermod/dist/jobserver /usr/local/bin/

WORKDIR /app

RUN for d in logs; do \
        mkdir -p /app/${d} ; \
        chown -R mattermod:mattermod /app/${d}/ ; \
    done

USER mattermod
EXPOSE 9000

ENTRYPOINT ["jobserver"]
