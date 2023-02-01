FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y zip unzip && apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD fwbuild-instance /usr/local/bin
ENTRYPOINT ["/usr/local/bin/fwbuild-instance"]
