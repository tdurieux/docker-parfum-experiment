FROM ubuntu:bionic

RUN apt update && apt install --no-install-recommends -qy make python3 python3-pip python3-venv git && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /app

WORKDIR /app
