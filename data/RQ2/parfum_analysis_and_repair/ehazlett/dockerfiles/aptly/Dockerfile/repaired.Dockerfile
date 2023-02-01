FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y aptly gnupg2 rsync && rm -rf /var/lib/apt/lists/*;
