# Use the official Docker images
# https://registry.hub.docker.com/_/node/
#
FROM node:0.12.7

RUN apt-get update && apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir httpbin gunicorn