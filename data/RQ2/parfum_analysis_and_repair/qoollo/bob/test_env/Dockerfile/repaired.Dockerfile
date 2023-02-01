FROM ubuntu:latest
WORKDIR /home/py/rust/bob/
RUN apt update && apt install --no-install-recommends -y iproute2 iputils-ping netcat curl && rm -rf /var/lib/apt/lists/*;
# COPY ../target/debug/bobd /bin/bobd