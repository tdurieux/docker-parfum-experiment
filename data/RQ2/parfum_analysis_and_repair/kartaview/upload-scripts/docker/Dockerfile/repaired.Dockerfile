FROM debian:buster-slim

COPY requirements.txt /etc/requirements.txt
COPY git-blacklist /etc/apt/preferences.d/git-blacklist

RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install python3 python3-pip && pip3 install --no-cache-dir -r /etc/requirements.txt && apt-get -y clean && rm -rf /var/lib/apt/lists/*;

