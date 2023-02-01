FROM ubuntu:20.04
MAINTAINER sminot@fredhutch.org

ADD requirements.txt /share/
RUN apt update && \
    apt install --no-install-recommends -y build-essential python3 python3-pip && \
    cd /share && \
    pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;
