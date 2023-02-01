# Dockerfile used to build a build step that builds container-diff in CI.
FROM golang:1.14
RUN apt-get update && apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
WORKDIR     /workspace
