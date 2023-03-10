ARG PLATFORM=amd64
FROM ${PLATFORM}/debian:buster-slim

# Avoid tzdata prompt
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "Creating container based on ${PLATFORM}/debian:buster-slim" && \
    apt-get update && \
    apt-get install --no-install-recommends -y protobuf-compiler libprotoc-dev python3-pip \
    python3-grpcio python3-sklearn && \
    apt-get clean && \
    pip3 install --no-cache-dir numpy protobuf flask && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY ./samples/apps/anomaly-detection-app .

# Link the container to the Akri repository
LABEL org.opencontainers.image.source https://github.com/project-akri/akri

CMD python3 ./anomaly_detection.py