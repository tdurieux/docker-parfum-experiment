FROM ubuntu:@@@TAG_NAME@@@
RUN apt-get update && apt-get install --no-install-recommends -y curl openssl perl && rm -rf /var/lib/apt/lists/*;
