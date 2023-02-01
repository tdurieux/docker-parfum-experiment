FROM ubuntu:20.04

RUN apt update
RUN apt -y --no-install-recommends install ca-certificates python3 libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir mitmproxy redis

RUN mkdir /app/
ADD service.py /app/
ADD *.sh /tmp/
RUN chmod +x /tmp/*.sh

ENTRYPOINT ["/bin/sh", "/tmp/proxy_run.sh"]
