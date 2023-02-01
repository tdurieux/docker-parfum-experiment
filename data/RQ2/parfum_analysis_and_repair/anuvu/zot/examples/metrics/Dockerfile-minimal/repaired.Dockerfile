# ---
# Stage 1: Install certs, build binary, create default config file
# ---
FROM ghcr.io/project-zot/golang:1.18 AS builder
RUN mkdir -p /go/src/github.com/project-zot/zot
WORKDIR /go/src/github.com/project-zot/zot
COPY . .
RUN make clean binary-minimal
RUN echo '{\n\
    "storage": {\n\
        "rootDirectory": "/var/lib/registry"\n\
    },\n\
    "http": {\n\
        "address": "0.0.0.0",\n\
        "port": "5050"\n\
    },\n\
    "log": {\n\
        "level": "debug"\n\
    }\n\
}\n' > config.json && cat config.json

# ---
# Stage 2: Final image with nothing but certs, binary, and default config file
# ---