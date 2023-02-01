FROM ubuntu

#ENV http_proxy
#ENV https_proxy

RUN apt update && apt install --no-install-recommends -y stress-ng && rm -rf /var/lib/apt/lists/*;

ENV SHELL=/bin/bash

ENTRYPOINT ["/usr/bin/stress-ng"]

