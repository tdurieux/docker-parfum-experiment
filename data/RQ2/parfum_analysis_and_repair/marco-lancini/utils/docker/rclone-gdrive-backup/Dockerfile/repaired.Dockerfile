FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y curl unzip zip && rm -rf /var/lib/apt/lists/*;
# I know, I know...
RUN curl -f https://rclone.org/install.sh | bash

WORKDIR /src
COPY docker/rclone-gdrive-backup/rclone-run.sh /src
