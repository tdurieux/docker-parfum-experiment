FROM ubuntu:18.04 as magic

RUN apt-get update && apt-get install --no-install-recommends -yq magic && rm -rf /var/lib/apt/lists/*;
