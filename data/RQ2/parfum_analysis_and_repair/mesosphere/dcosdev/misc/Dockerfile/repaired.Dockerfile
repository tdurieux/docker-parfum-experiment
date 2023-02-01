FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.11/dcos
RUN mv dcos /usr/local/bin
RUN chmod +x /usr/local/bin/dcos

COPY . /dcosdev
RUN cd /dcosdev && pip install --no-cache-dir . && cd .. && rm -rf /dcosdev
