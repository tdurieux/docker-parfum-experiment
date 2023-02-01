# ---
# Stage 1: Build binary, create default config file
# ---
FROM ghcr.io/project-zot/golang:1.18 AS builder
ARG COMMIT
ARG OS
ARG ARCH
RUN mkdir -p /go/src/github.com/project-zot/zot
WORKDIR /go/src/github.com/project-zot/zot
COPY . .
RUN make COMMIT=$COMMIT OS=$OS ARCH=$ARCH clean exporter-minimal
RUN echo '{\n\
    "Server": {\n\
        "protocol": "http",\n\
        "host": "127.0.0.1",\n\
        "port": "5000"\n\
    },\n\
    "Exporter": {\n\
        "port": "5001",\n\
        "log": {\n\
            "level": "debug"\n\
        }\n\
    }\n\
}\n' > config.json && cat config.json

# ---
# Stage 2: Final image with nothing but binary and default config file
# ---