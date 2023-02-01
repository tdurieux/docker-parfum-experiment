FROM php:latest
RUN apt-get update && apt install -y --no-install-recommends zip unzip && rm -rf /var/lib/apt/lists/*;