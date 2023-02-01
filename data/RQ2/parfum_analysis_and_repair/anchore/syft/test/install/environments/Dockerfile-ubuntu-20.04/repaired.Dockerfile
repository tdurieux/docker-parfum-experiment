FROM ubuntu:20.04
RUN apt update -y && apt install --no-install-recommends make python3 curl unzip -y && rm -rf /var/lib/apt/lists/*;