# Dockerfile
FROM ubuntu:trusty

RUN apt-get update -y && apt-get install --no-install-recommends python git -y && rm -rf /var/lib/apt/lists/*;

COPY ./install_pkg.sh /

