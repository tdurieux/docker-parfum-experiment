FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
