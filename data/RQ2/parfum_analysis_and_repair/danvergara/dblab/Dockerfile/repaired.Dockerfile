FROM golang:1.18-bullseye AS builder

WORKDIR /src/app

# install system dependencies
RUN apt-get update \
  && apt-get -y --no-install-recommends install netcat \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY go.* ./
RUN go mod download
COPY . .

ARG TARGETOS
ARG TARGETARCH

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH}  go build -o dblab .

FROM scratch AS bin

LABEL org.opencontainers.image.documentation="https://github.com/danvergara/dblab" \
	org.opencontainers.image.source="https://github.com/danvergara/dblab" \
	org.opencontainers.image.title="dblab"

COPY --from=builder /src/app/dblab /bin/dblab
