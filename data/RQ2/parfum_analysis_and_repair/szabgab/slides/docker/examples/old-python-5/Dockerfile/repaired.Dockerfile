FROM ubuntu:20.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir requests

COPY curl.py /opt/

ENTRYPOINT ["/opt/curl.py"]

