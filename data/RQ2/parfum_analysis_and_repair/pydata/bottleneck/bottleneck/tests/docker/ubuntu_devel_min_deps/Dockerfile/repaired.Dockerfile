FROM ubuntu:devel
RUN apt-get update && apt-get install --no-install-recommends -y gcc python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
WORKDIR /tmp
CMD ["pip3", "install", "/bottleneck_src"]