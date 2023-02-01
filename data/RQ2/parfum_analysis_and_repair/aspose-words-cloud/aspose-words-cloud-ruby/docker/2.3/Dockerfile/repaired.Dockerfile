FROM ruby:2.3
RUN apt-get update && apt install -y --no-install-recommends zip unzip && rm -rf /var/lib/apt/lists/*;