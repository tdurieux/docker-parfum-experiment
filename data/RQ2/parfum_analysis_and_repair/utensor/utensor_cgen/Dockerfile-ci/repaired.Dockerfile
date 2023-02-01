FROM ubuntu
MAINTAINER Michael Bartling "michael.bartling15@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    python3 \
    python3-pip \
    gcc \
    wget \
    lcov \
    g++ && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel
RUN pip3 install --no-cache-dir pytest graphviz
COPY . .
RUN python3 setup.py install

