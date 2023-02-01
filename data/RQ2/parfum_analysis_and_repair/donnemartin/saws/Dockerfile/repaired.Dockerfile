FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
    groff \
    python-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir saws

ENTRYPOINT ["saws"]
