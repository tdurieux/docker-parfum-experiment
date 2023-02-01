FROM node:16-slim
RUN apt-get update && apt-get -y --no-install-recommends install socat curl && rm -rf /var/lib/apt/lists/*;
COPY prepare-node.sh prepare-node.sh
