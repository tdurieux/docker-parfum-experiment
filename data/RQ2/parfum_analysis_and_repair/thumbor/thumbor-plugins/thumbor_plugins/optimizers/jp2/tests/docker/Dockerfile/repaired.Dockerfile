FROM python:3.9-slim

WORKDIR /app
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        libopenjp2-7 \
        libopenjp2-7-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

