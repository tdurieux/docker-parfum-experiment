# builder image
# ============================================================================
FROM concourse/golang-builder as builder
ENV CGO_ENABLED 0

RUN mkdir -p /assets/ /app/

ADD fly/fly-*-linux-amd64.tgz /assets/

COPY concourse-pipeline-resource/go.mod concourse-pipeline-resource/go.sum /app/

WORKDIR /app/

RUN go mod download

COPY concourse-pipeline-resource/ /app/

RUN go build -o /assets/in ./cmd/in \
	&& go build -o /assets/out ./cmd/out \
	&& go build -o /assets/check ./cmd/check \
	&& build_timestamp=$(date +%s) \
	&& set -e; for pkg in $(go list ./... | grep -v "acceptance"); do \
		go test -o "/tests/$(basename $pkg).${build_timestamp}.test" -c $pkg; \
	done

# runtime image
# ============================================================================
FROM ubuntu:bionic AS resource
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder assets/ /opt/resource/
RUN chmod +x /opt/resource/*

# test image
# ============================================================================
FROM resource AS tests
COPY --from=builder /tests /go-tests
RUN set -e; for test in /go-tests/*.test; do \
		$test; \
	done

# export runtime image
# ============================================================================