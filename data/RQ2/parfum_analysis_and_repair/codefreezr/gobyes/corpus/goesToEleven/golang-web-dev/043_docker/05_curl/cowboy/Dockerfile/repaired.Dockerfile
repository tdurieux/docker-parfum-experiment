# This docker file builds an image that runs curl
FROM ubuntu:latest
RUN apt-get -y update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
