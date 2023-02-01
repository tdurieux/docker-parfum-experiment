# Use the official Docker images
# https://registry.hub.docker.com/_/node/
#
FROM node:9.3.0-stretch

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade cffi
RUN pip3 install --no-cache-dir httpbin gunicorn


RUN npm install crawler -g && npm cache clean --force;
