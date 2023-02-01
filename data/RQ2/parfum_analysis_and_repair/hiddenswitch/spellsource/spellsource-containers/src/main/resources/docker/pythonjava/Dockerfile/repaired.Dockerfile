FROM openjdk:11-buster
RUN apt update && apt install --no-install-recommends -y python3 python3-pip && pip3 install --no-cache-dir --upgrade pip setuptools && rm -rf /var/lib/apt/lists/*
ENTRYPOINT /usr/bin/python3