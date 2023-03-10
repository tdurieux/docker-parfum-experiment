# ---
# Stage 1: Build binary, create default config file
# ---
FROM ghcr.io/project-zot/golang:1.18 AS builder
RUN mkdir -p /go/src/github.com/project-zot/zot
WORKDIR /go/src/github.com/project-zot/zot
COPY . .
RUN make clean exporter-minimal
RUN echo '{\n\
    "Server": {\n\
        "protocol": "http",\n\
        "host": "127.0.0.1",\n\
        "port": "5050"\n\
    },\n\
    "Exporter": {\n\
        "port": "5051",\n\
        "log": {\n\
            "level": "debug"\n\
        }\n\
    }\n\
}\n' > config.json && cat config.json

# ---
# Stage 2: Final image with nothing but binary and default config file
# ---