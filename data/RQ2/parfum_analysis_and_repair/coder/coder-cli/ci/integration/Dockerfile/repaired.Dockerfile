FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y jq curl build-essential && rm -rf /var/lib/apt/lists/*;
