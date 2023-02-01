FROM maven:3.6-slim
RUN apt-get update && apt-get install --no-install-recommends -y libsodium-dev && rm -rf /var/lib/apt/lists/*;
