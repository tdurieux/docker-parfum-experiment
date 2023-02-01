# Dockerfile for Python 3 with xz-utils (for tar.xz unpacking)

FROM python:3.6-slim

RUN apt update && apt install --no-install-recommends -y xz-utils wget git && rm -rf /var/lib/apt/lists/*;
