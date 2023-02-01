FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y hugo && rm -rf /var/lib/apt/lists/*;

WORKDIR /srv/hugo

EXPOSE 1313

