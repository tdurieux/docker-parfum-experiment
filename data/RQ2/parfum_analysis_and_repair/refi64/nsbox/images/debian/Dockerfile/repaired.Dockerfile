ARG IMAGE_TAG
FROM docker.io/debian:$IMAGE_TAG
RUN apt update && apt install --no-install-recommends -y python3 python3-apt && apt clean && rm -rf /var/lib/apt/lists/*
