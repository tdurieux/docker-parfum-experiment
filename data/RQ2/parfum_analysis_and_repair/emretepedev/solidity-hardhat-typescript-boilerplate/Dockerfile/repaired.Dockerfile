FROM ubuntu:20.04

WORKDIR /labs

COPY . /labs/

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir solc-select slither-analyzer mythril
RUN bin/svm
