FROM ubuntu:20.04

COPY readme.md /
RUN apt-get update && apt-get install --no-install-recommends -y curl tar bash && rm -rf /var/lib/apt/lists/*