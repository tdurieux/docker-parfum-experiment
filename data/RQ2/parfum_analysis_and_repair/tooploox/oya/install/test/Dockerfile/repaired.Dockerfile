FROM debian

ENV USER root

RUN apt-get update && apt-get install --no-install-recommends -y wget curl && rm -rf /var/lib/apt/lists/*;
