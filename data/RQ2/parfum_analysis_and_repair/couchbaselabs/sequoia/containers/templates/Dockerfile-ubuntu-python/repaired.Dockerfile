FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y git python-dev python-pip && rm -rf /var/lib/apt/lists/*;
