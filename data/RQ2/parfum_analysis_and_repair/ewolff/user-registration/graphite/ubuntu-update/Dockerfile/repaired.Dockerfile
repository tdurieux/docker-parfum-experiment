FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y -qq wget && rm -rf /var/lib/apt/lists/*;

