FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y git build-essential sudo && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /workdir/qsym

WORKDIR /workdir/qsym
COPY . /workdir/qsym

RUN ./setup.sh
RUN pip install --no-cache-dir .
