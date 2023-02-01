FROM ubuntu:latest

RUN apt update && apt-get install --no-install-recommends python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p numerous

COPY requirements.txt ./numerous

WORKDIR numerous

RUN pip3 install --no-cache-dir -r requirements.txt

