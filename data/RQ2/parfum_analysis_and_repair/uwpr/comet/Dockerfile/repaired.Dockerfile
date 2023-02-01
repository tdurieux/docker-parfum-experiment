FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends procps -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY comet.exe ./comet

ENV PATH="/app:$PATH"
