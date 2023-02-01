FROM ubuntu:20.04

RUN apt update && \
    apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;

ADD . /usr/local/clinker/
RUN pip3 install --no-cache-dir /usr/local/clinker/
