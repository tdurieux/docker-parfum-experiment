FROM node

WORKDIR /workspace

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
