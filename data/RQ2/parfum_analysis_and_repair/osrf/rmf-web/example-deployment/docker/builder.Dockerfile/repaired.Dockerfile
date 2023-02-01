# base image used to build rmf-web packages
# NOTE: be sure to rebuild this when the depedencies change

FROM ubuntu:20.04

SHELL ["bash", "-c"]

RUN apt-get update && apt-get install --no-install-recommends -y curl && \
  curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get update && apt-get install --no-install-recommends -y nodejs python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pipenv

COPY . /root/rmf-web
RUN cd /root/rmf-web && \
  npm install -g npm@latest && \
  npm config set unsafe-perm && \
  npm ci && npm cache clean --force;
