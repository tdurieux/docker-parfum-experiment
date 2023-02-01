FROM debian:9-slim
RUN apt -y update && apt -y install --no-install-recommends jekyll && rm -rf /var/lib/apt/lists/*;
