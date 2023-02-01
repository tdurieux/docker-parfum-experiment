FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y cmake python python3 python3-pip libseccomp-dev gcc g++ strace && pip3 install --no-cache-dir setuptools --upgrade && rm -rf /var/lib/apt/lists/*;
WORKDIR /src