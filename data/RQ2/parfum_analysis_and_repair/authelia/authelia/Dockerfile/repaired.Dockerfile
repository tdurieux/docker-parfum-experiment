# ===================================
# ===== Authelia official image =====
# ===================================
FROM alpine:3.16.0

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

# Set environment variables