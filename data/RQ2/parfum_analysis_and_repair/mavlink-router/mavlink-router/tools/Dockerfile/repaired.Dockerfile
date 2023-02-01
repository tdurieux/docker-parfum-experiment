FROM arm64v8/ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends --yes \
    libgtest-dev && rm -rf /var/lib/apt/lists/*;
