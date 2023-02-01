FROM ubuntu:18.04

COPY ./install_fbthrift.sh /

RUN apt-get update && apt-get install --no-install-recommends -y sudo && bash -x /install_fbthrift.sh && rm -rf /var/lib/apt/lists/*;

