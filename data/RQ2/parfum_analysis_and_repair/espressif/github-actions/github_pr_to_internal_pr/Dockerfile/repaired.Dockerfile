FROM node:current-bullseye-slim

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

COPY requirements.txt /tmp/

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y python3-pip && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt && rm -rf /var/lib/apt/lists/*;

COPY github_pr_to_internal_pr.py /

ENTRYPOINT ["/usr/bin/python3", "/github_pr_to_internal_pr.py"]
