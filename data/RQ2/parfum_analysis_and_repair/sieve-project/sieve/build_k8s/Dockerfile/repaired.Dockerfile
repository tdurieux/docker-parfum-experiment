FROM kindest/node:latest
RUN echo "Build my own kind image..." \
    && apt update && apt install --no-install-recommends -y bash vim && rm -rf /var/lib/apt/lists/*;
