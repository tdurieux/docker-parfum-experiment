FROM ubuntu:18.04
RUN apt update -y && apt install --no-install-recommends git wget curl vim python3 -y && rm -rf /var/lib/apt/lists/*;
COPY sofaroot/tools/prepare.sh prepare.sh
RUN ./prepare.sh
COPY sofaroot /sofaroot
